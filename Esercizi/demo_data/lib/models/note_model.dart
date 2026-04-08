/// Model per rappresentare una Nota salvata su file system.
/// 
/// Contiene:
/// - filename: nome del file
/// - content: contenuto della nota
/// - lastModified: data ultima modifica
class NoteModel {
  final String filename;
  final String content;
  final DateTime lastModified;

  NoteModel({
    required this.filename,
    required this.content,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  /// Crea un NoteModel da JSON
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      filename: json['filename'] as String,
      content: json['content'] as String,
      lastModified: DateTime.parse(json['lastModified'] as String),
    );
  }

  /// Converte il NoteModel in JSON
  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'content': content,
      'lastModified': lastModified.toIso8601String(),
    };
  }

  NoteModel copyWith({
    String? filename,
    String? content,
    DateTime? lastModified,
  }) {
    return NoteModel(
      filename: filename ?? this.filename,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  String toString() {
    return 'NoteModel(filename: $filename, length: ${content.length})';
  }
}
