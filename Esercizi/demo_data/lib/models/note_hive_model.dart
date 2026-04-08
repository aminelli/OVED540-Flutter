import 'package:hive/hive.dart';

part 'note_hive_model.g.dart';

/// Modello Note per Hive database.
/// 
/// Utilizza le annotations di Hive per la generazione automatica del TypeAdapter.
/// Il TypeAdapter permette a Hive di serializzare/deserializzare gli oggetti.
@HiveType(typeId: 0)
class NoteHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime? updatedAt;

  @HiveField(5)
  String? category;

  @HiveField(6)
  bool isFavorite;

  NoteHiveModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.category,
    this.isFavorite = false,
  });

  /// Crea una copia dell'oggetto con alcuni campi modificati
  NoteHiveModel copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    bool? isFavorite,
  }) {
    return NoteHiveModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Converte l'oggetto in una Map (utile per debug/logging)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  @override
  String toString() {
    return 'NoteHiveModel{id: $id, title: $title, category: $category, isFavorite: $isFavorite}';
  }
}
