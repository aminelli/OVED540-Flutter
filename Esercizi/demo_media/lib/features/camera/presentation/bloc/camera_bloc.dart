/// BLoC per gestire lo stato della fotocamera
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/camera_repository.dart';
import 'camera_event.dart';
import 'camera_state.dart';
import '../../../../core/utils/error_handler.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraRepository _repository;

  CameraBloc({required CameraRepository repository})
      : _repository = repository,
        super(CameraInitial()) {
    on<CameraInitializeEvent>(_onInitialize);
    on<CameraCapturePictureEvent>(_onCapturePicture);
    on<CameraSwitchEvent>(_onSwitch);
    on<CameraLoadSavedPhotosEvent>(_onLoadSavedPhotos);
    on<CameraDeletePhotoEvent>(_onDeletePhoto);
  }

  /// Gestisce l'inizializzazione della fotocamera
  Future<void> _onInitialize(
    CameraInitializeEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraLoading());
    try {
      final controller = await _repository.initializeCamera();
      final savedPhotos = await _repository.getSavedPhotos();
      emit(CameraReady(controller: controller, savedPhotos: savedPhotos));
    } catch (e) {
      emit(CameraError(message: ErrorHandler.getErrorMessage(e)));
    }
  }

  /// Gestisce lo scatto di una foto
  Future<void> _onCapturePicture(
    CameraCapturePictureEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final currentState = state as CameraReady;

    try {
      final photo = await _repository.takePicture();
      emit(CameraPictureTaken(
        photo: photo,
        controller: currentState.controller,
      ));

      // Ricarica le foto salvate
      final savedPhotos = await _repository.getSavedPhotos();
      emit(CameraReady(
        controller: currentState.controller,
        savedPhotos: savedPhotos,
      ));
    } catch (e) {
      emit(CameraError(message: ErrorHandler.getErrorMessage(e)));
      // Ritorna allo stato ready
      emit(currentState);
    }
  }

  /// Gestisce il cambio di fotocamera
  Future<void> _onSwitch(
    CameraSwitchEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final currentState = state as CameraReady;
    emit(CameraLoading());

    try {
      final controller = await _repository.switchCamera();
      emit(CameraReady(
        controller: controller,
        savedPhotos: currentState.savedPhotos,
      ));
    } catch (e) {
      emit(CameraError(message: ErrorHandler.getErrorMessage(e)));
      emit(currentState);
    }
  }

  /// Gestisce il caricamento delle foto salvate
  Future<void> _onLoadSavedPhotos(
    CameraLoadSavedPhotosEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final currentState = state as CameraReady;

    try {
      final savedPhotos = await _repository.getSavedPhotos();
      emit(currentState.copyWith(savedPhotos: savedPhotos));
    } catch (e) {
      // Errore non critico, mantieni lo stato corrente
      emit(currentState);
    }
  }

  /// Gestisce l'eliminazione di una foto
  Future<void> _onDeletePhoto(
    CameraDeletePhotoEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (state is! CameraReady) return;

    final currentState = state as CameraReady;

    try {
      await _repository.deletePhoto(event.photoPath);
      final savedPhotos = await _repository.getSavedPhotos();
      emit(currentState.copyWith(savedPhotos: savedPhotos));
    } catch (e) {
      emit(CameraError(message: ErrorHandler.getErrorMessage(e)));
      emit(currentState);
    }
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }
}
