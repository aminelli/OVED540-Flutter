/// Stati per MediaPickerBloc
library;

import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class MediaPickerState extends Equatable {
  const MediaPickerState();

  @override
  List<Object?> get props => [];
}

/// Stato iniziale
class MediaPickerInitial extends MediaPickerState {}

/// Stato di caricamento
class MediaPickerLoading extends MediaPickerState {}

/// Stato con media selezionati
class MediaPickerLoaded extends MediaPickerState {
  final List<File> selectedFiles;

  const MediaPickerLoaded({this.selectedFiles = const []});

  @override
  List<Object?> get props => [selectedFiles];

  MediaPickerLoaded copyWith({List<File>? selectedFiles}) {
    return MediaPickerLoaded(
      selectedFiles: selectedFiles ?? this.selectedFiles,
    );
  }
}

/// Stato di errore
class MediaPickerError extends MediaPickerState {
  final String message;

  const MediaPickerError({required this.message});

  @override
  List<Object?> get props => [message];
}
