/// Eventi per il CameraBloc
library;

import 'package:equatable/equatable.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

/// Evento per inizializzare la fotocamera
class CameraInitializeEvent extends CameraEvent {}

/// Evento per scattare una foto
class CameraCapturePictureEvent extends CameraEvent {}

/// Evento per cambiare fotocamera
class CameraSwitchEvent extends CameraEvent {}

/// Evento per caricare le foto salvate
class CameraLoadSavedPhotosEvent extends CameraEvent {}

/// Evento per eliminare una foto
class CameraDeletePhotoEvent extends CameraEvent {
  final String photoPath;

  const CameraDeletePhotoEvent({required this.photoPath});

  @override
  List<Object?> get props => [photoPath];
}
