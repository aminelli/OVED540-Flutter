/// Stati per il CameraBloc
library;

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/photo_model.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

/// Stato iniziale
class CameraInitial extends CameraState {}

/// Stato di caricamento
class CameraLoading extends CameraState {}

/// Stato quando la fotocamera è pronta
class CameraReady extends CameraState {
  final CameraController controller;
  final List<PhotoModel> savedPhotos;

  const CameraReady({
    required this.controller,
    this.savedPhotos = const [],
  });

  @override
  List<Object?> get props => [controller, savedPhotos];

  CameraReady copyWith({
    CameraController? controller,
    List<PhotoModel>? savedPhotos,
  }) {
    return CameraReady(
      controller: controller ?? this.controller,
      savedPhotos: savedPhotos ?? this.savedPhotos,
    );
  }
}

/// Stato quando una foto è stata scattata
class CameraPictureTaken extends CameraState {
  final PhotoModel photo;
  final CameraController controller;

  const CameraPictureTaken({
    required this.photo,
    required this.controller,
  });

  @override
  List<Object?> get props => [photo, controller];
}

/// Stato di errore
class CameraError extends CameraState {
  final String message;

  const CameraError({required this.message});

  @override
  List<Object?> get props => [message];
}
