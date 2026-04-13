/// Service centralizzato per la gestione dei permessi runtime
library;

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Richiede permesso fotocamera
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Richiede permesso storage
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 13+ usa permessi diversi
      if (await _getAndroidVersion() >= 33) {
        final photos = await Permission.photos.request();
        final videos = await Permission.videos.request();
        return photos.isGranted && videos.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true; // iOS gestisce automaticamente
  }

  /// Richiede permesso microfono
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Richiede permesso posizione
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Richiede permesso posizione sempre attiva (background)
  Future<bool> requestLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();
    return status.isGranted;
  }

  /// Verifica se il permesso fotocamera è concesso
  Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Verifica se il permesso storage è concesso
  Future<bool> isStoragePermissionGranted() async {
    if (Platform.isAndroid) {
      if (await _getAndroidVersion() >= 33) {
        final photos = await Permission.photos.status;
        final videos = await Permission.videos.status;
        return photos.isGranted && videos.isGranted;
      } else {
        final status = await Permission.storage.status;
        return status.isGranted;
      }
    }
    return true;
  }

  /// Verifica se il permesso microfono è concesso
  Future<bool> isMicrophonePermissionGranted() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Verifica se il permesso posizione è concesso
  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Apre le impostazioni dell'app per abilitare i permessi
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Helper per ottenere la versione Android
  Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;
    // Questa è una semplificazione, in produzione usare device_info_plus
    return 33; // Assumiamo Android 13+
  }
}
