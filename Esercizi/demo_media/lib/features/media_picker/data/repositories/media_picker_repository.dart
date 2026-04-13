/// Repository per gestire la selezione di media (foto/video)
library;

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/permission_service.dart';

class MediaPickerRepository {
  final ImagePicker _imagePicker;
  final PermissionService _permissionService;

  MediaPickerRepository({
    required ImagePicker imagePicker,
    required PermissionService permissionService,
  })  : _imagePicker = imagePicker,
        _permissionService = permissionService;

  /// Seleziona una foto dalla galleria
  Future<File?> pickImageFromGallery() async {
    final hasPermission = await _permissionService.requestStoragePermission();
    if (!hasPermission) {
      throw PermissionDeniedException('Permesso storage negato');
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw StorageException('Errore selezione immagine: $e');
    }
  }

  /// Seleziona multiple foto dalla galleria
  Future<List<File>> pickMultipleImages() async {
    final hasPermission = await _permissionService.requestStoragePermission();
    if (!hasPermission) {
      throw PermissionDeniedException('Permesso storage negato');
    }

    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      throw StorageException('Errore selezione immagini: $e');
    }
  }

  /// Seleziona un video dalla galleria
  Future<File?> pickVideoFromGallery() async {
    final hasPermission = await _permissionService.requestStoragePermission();
    if (!hasPermission) {
      throw PermissionDeniedException('Permesso storage negato');
    }

    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      return video != null ? File(video.path) : null;
    } catch (e) {
      throw StorageException('Errore selezione video: $e');
    }
  }

  /// Seleziona un file generico
  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }

      return null;
    } catch (e) {
      throw StorageException('Errore selezione file: $e');
    }
  }

  /// Seleziona multiple file
  Future<List<File>> pickMultipleFiles({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
      }

      return [];
    } catch (e) {
      throw StorageException('Errore selezione file: $e');
    }
  }

  /// Scatta una foto con la fotocamera
  Future<File?> takePhoto() async {
    final hasPermission = await _permissionService.requestCameraPermission();
    if (!hasPermission) {
      throw PermissionDeniedException('Permesso fotocamera negato');
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      throw AppCameraException('Errore scatto foto: $e');
    }
  }

  /// Registra un video con la fotocamera
  Future<File?> recordVideo() async {
    final hasCameraPermission =
        await _permissionService.requestCameraPermission();
    final hasMicPermission =
        await _permissionService.requestMicrophonePermission();

    if (!hasCameraPermission || !hasMicPermission) {
      throw PermissionDeniedException('Permessi fotocamera o microfono negati');
    }

    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 10),
      );

      return video != null ? File(video.path) : null;
    } catch (e) {
      throw AppCameraException('Errore registrazione video: $e');
    }
  }
}
