import 'package:equatable/equatable.dart';

/// Modello che rappresenta un singolo Task (Attività)
/// 
/// Contiene tutte le informazioni necessarie per gestire un'attività,
/// incluso l'ID univoco, il titolo, la descrizione e lo stato di completamento
class Todo extends Equatable {
  /// Identificatore univoco del task
  final String id;
  
  /// Titolo del task
  final String title;
  
  /// Descrizione dettagliata del task (opzionale)
  final String description;
  
  /// Indica se il task è stato completato
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  /// Crea una copia del Todo con alcuni campi modificati
  /// 
  /// Questo metodo è utile per aggiornare immutabilmente un task
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Lista di proprietà utilizzate per confrontare due oggetti Todo
  /// 
  /// Equatable utilizza questa lista per determinare se due Todo sono uguali
  @override
  List<Object?> get props => [id, title, description, isCompleted];

  /// Rappresentazione testuale del Todo (utile per il debug)
  @override
  String toString() {
    return 'Todo { id: $id, title: $title, description: $description, isCompleted: $isCompleted }';
  }
}
