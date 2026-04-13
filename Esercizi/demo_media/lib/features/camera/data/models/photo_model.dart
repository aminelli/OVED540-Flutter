/// Modello dati per informazioni sulla foto scattata
library;

import 'package:equatable/equatable.dart';

class PhotoModel extends Equatable {
  final String path;
  final DateTime timestamp;
  final int? width;
  final int? height;

  const PhotoModel({
    required this.path,
    required this.timestamp,
    this.width,
    this.height,
  });

  @override
  List<Object?> get props => [path, timestamp, width, height];

  Map<String, dynamic> toJson() => {
        'path': path,
        'timestamp': timestamp.toIso8601String(),
        'width': width,
        'height': height,
      };

  factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        path: json['path'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        width: json['width'] as int?,
        height: json['height'] as int?,
      );
}
