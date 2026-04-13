/// Gestione centralizzata degli errori
library;

import '../constants/app_constants.dart';

/// Eccezioni personalizzate
class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException([this.message = 'Permesso negato']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Errore di rete']);

  @override
  String toString() => message;
}

class StorageException implements Exception {
  final String message;
  StorageException([this.message = 'Errore di storage']);

  @override
  String toString() => message;
}

class AppCameraException implements Exception {
  final String message;
  AppCameraException([this.message = 'Errore fotocamera']);

  @override
  String toString() => message;
}

class CameraException implements Exception {
  final String message;
  CameraException([this.message = 'Errore fotocamera']);

  @override
  String toString() => message;
}

/// Handler centralizzato per convertire errori in messaggi user-friendly
abstract class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is PermissionDeniedException) {
      return AppConstants.permissionDeniedMessage;
    } else if (error is NetworkException) {
      return AppConstants.networkErrorMessage;
    } else if (error is StorageException) {
      return 'Errore nel salvataggio. Spazio insufficiente o file system non accessibile.';
    } else if (error is CameraException) {
      return 'Impossibile accedere alla fotocamera. Verifica i permessi o riavvia l\'app.';
    } else {
      return AppConstants.defaultErrorMessage;
    }
  }
}
