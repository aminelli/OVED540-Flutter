/// BLoC per gestire la selezione di media
library;

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/media_picker_repository.dart';
import 'media_picker_event.dart';
import 'media_picker_state.dart';
import '../../../../core/utils/error_handler.dart';

class MediaPickerBloc extends Bloc<MediaPickerEvent, MediaPickerState> {
  final MediaPickerRepository _repository;

  MediaPickerBloc({required MediaPickerRepository repository})
      : _repository = repository,
        super(MediaPickerInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<PickMultipleImagesEvent>(_onPickMultipleImages);
    on<PickVideoEvent>(_onPickVideo);
    on<TakePhotoEvent>(_onTakePhoto);
    on<RecordVideoEvent>(_onRecordVideo);
    on<PickFileEvent>(_onPickFile);
    on<RemoveMediaEvent>(_onRemoveMedia);
    on<ClearAllMediaEvent>(_onClearAll);
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    emit(MediaPickerLoading());
    try {
      final file = await _repository.pickImageFromGallery();
      if (file != null) {
        final currentFiles = _getCurrentFiles();
        emit(MediaPickerLoaded(selectedFiles: [...currentFiles, file]));
      } else {
        emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
      }
    } catch (e) {
      emit(MediaPickerError(message: ErrorHandler.getErrorMessage(e)));
      emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
    }
  }

  Future<void> _onPickMultipleImages(
    PickMultipleImagesEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    emit(MediaPickerLoading());
    try {
      final files = await _repository.pickMultipleImages();
      if (files.isNotEmpty) {
        final currentFiles = _getCurrentFiles();
        emit(MediaPickerLoaded(selectedFiles: [...currentFiles, ...files]));
      } else {
        emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
      }
    } catch (e) {
      emit(MediaPickerError(message: ErrorHandler.getErrorMessage(e)));
      emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
    }
  }

  Future<void> _onPickVideo(
    PickVideoEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    emit(MediaPickerLoading());
    try {
      final file = await _repository.pickVideoFromGallery();
      if (file != null) {
        final currentFiles = _getCurrentFiles();
        emit(MediaPickerLoaded(selectedFiles: [...currentFiles, file]));
      } else {
        emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
      }
    } catch (e) {
      emit(MediaPickerError(message: ErrorHandler.getErrorMessage(e)));
      emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
    }
  }

  Future<void> _onTakePhoto(
    TakePhotoEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    emit(MediaPickerLoading());
    try {
      final file = await _repository.takePhoto();
      if (file != null) {
        final currentFiles = _getCurrentFiles();
        emit(MediaPickerLoaded(selectedFiles: [...currentFiles, file]));
      } else {
        emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
      }
    } catch (e) {
      emit(MediaPickerError(message: ErrorHandler.getErrorMessage(e)));
      emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
    }
  }

  Future<void> _onRecordVideo(
    RecordVideoEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    emit(MediaPickerLoading());
    try {
      final file = await _repository.recordVideo();
      if (file != null) {
        final currentFiles = _getCurrentFiles();
        emit(MediaPickerLoaded(selectedFiles: [...currentFiles, file]));
      } else {
        emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
      }
    } catch (e) {
      emit(MediaPickerError(message: ErrorHandler.getErrorMessage(e)));
      emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
    }
  }

  Future<void> _onPickFile(
    PickFileEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    emit(MediaPickerLoading());
    try {
      final file = await _repository.pickFile(
        allowedExtensions: event.allowedExtensions,
      );
      if (file != null) {
        final currentFiles = _getCurrentFiles();
        emit(MediaPickerLoaded(selectedFiles: [...currentFiles, file]));
      } else {
        emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
      }
    } catch (e) {
      emit(MediaPickerError(message: ErrorHandler.getErrorMessage(e)));
      emit(MediaPickerLoaded(selectedFiles: _getCurrentFiles()));
    }
  }

  Future<void> _onRemoveMedia(
    RemoveMediaEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    final currentFiles = _getCurrentFiles();
    final updatedFiles =
        currentFiles.where((file) => file.path != event.filePath).toList();
    emit(MediaPickerLoaded(selectedFiles: updatedFiles));
  }

  Future<void> _onClearAll(
    ClearAllMediaEvent event,
    Emitter<MediaPickerState> emit,
  ) async {
    emit(const MediaPickerLoaded(selectedFiles: []));
  }

  List<File> _getCurrentFiles() {
    if (state is MediaPickerLoaded) {
      return (state as MediaPickerLoaded).selectedFiles;
    }
    return [];
  }
}
