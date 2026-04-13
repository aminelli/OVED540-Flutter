/// Repository per gestire le operazioni della fotocamera
library;

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/photo_model.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/permission_service.dart';

class CameraRepository {
  final PermissionService _permissionService;
  CameraController? _controller;

  CameraRepository({required PermissionService permissionService})
      : _permissionService = permissionService;

  /// Inizializza la fotocamera
  Future<CameraController> initializeCamera() async {
    // Verifica permessi
    final hasPermission = await _permissionService.requestCameraPermission();
    if (!hasPermission) {
      throw PermissionDeniedException('Permesso fotocamera negato');
    }

    try {
      // Ottieni la lista delle fotocamere disponibili
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw AppCameraException('Nessuna fotocamera disponibile');
      }

      // Usa la fotocamera posteriore per default
      final camera = cameras.first;

      // Crea e inizializza il controller
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      return _controller!;
    } catch (e) {
      throw AppCameraException('Errore inizializzazione fotocamera: $e');
    }
  }

  /// Scatta una foto e la salva
  Future<PhotoModel> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw AppCameraException('Fotocamera non inizializzata');
    }

    try {
      // Scatta la foto
      final image = await _controller!.takePicture();

      // Crea directory per salvare le foto
      final directory = await getApplicationDocumentsDirectory();
      final photosDir = Directory(path.join(directory.path, 'photos'));
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Genera nome file unico
      final timestamp = DateTime.now();
      final fileName = 'photo_${timestamp.millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(photosDir.path, fileName);

      // Copia il file nella directory permanente
      await File(image.path).copy(savedPath);

      return PhotoModel(
        path: savedPath,
        timestamp: timestamp,
      );
    } catch (e) {
      throw AppCameraException('Errore durante lo scatto: $e');
    }
  }

  /// Cambia fotocamera (frontale/posteriore)
  Future<CameraController> switchCamera() async {
    if (_controller == null) {
      throw AppCameraException('Fotocamera non inizializzata');
    }

    try {
      final cameras = await availableCameras();
      if (cameras.length < 2) {
        throw AppCameraException('Una sola fotocamera disponibile');
      }

      // Trova la fotocamera opposta
      final currentLens = _controller!.description.lensDirection;
      final newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection != currentLens,
        orElse: () => cameras.first,
      );

      // Disponi del vecchio controller
      await _controller!.dispose();

      // Crea nuovo controller
      _controller = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      return _controller!;
    } catch (e) {
      throw AppCameraException('Errore cambio fotocamera: $e');
    }
  }

  /// Dispone delle risorse della fotocamera
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  /// Ottiene la lista delle foto salvate
  Future<List<PhotoModel>> getSavedPhotos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final photosDir = Directory(path.join(directory.path, 'photos'));

      if (!await photosDir.exists()) {
        return [];
      }

      final files = await photosDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.jpg'))
          .cast<File>()
          .toList();

      return files.map((file) {
        final stats = file.statSync();
        return PhotoModel(
          path: file.path,
          timestamp: stats.modified,
        );
      }).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      throw StorageException('Errore lettura foto salvate: $e');
    }
  }

  /// Elimina una foto
  Future<void> deletePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw StorageException('Errore eliminazione foto: $e');
    }
  }
}
