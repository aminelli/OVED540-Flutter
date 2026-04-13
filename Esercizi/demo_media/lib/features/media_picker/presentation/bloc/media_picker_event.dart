/// Eventi per MediaPickerBloc
library;

import 'package:equatable/equatable.dart';

abstract class MediaPickerEvent extends Equatable {
  const MediaPickerEvent();

  @override
  List<Object?> get props => [];
}

/// Seleziona una singola immagine
class PickImageEvent extends MediaPickerEvent {}

/// Seleziona multiple immagini
class PickMultipleImagesEvent extends MediaPickerEvent {}

/// Seleziona un video
class PickVideoEvent extends MediaPickerEvent {}

/// Scatta una foto
class TakePhotoEvent extends MediaPickerEvent {}

/// Registra un video
class RecordVideoEvent extends MediaPickerEvent {}

/// Seleziona un file generico
class PickFileEvent extends MediaPickerEvent {
  final List<String>? allowedExtensions;

  const PickFileEvent({this.allowedExtensions});

  @override
  List<Object?> get props => [allowedExtensions];
}

/// Elimina un media selezionato
class RemoveMediaEvent extends MediaPickerEvent {
  final String filePath;

  const RemoveMediaEvent({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

/// Pulisce tutti i media selezionati
class ClearAllMediaEvent extends MediaPickerEvent {}
