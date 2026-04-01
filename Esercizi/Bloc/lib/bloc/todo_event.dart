import 'package:equatable/equatable.dart';
import '../models/todo.dart';

/// Classe astratta base per tutti gli eventi del TodoBloc
/// 
/// Ogni evento rappresenta un'azione dell'utente che richiede
/// un cambiamento nello stato dell'applicazione
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

/// Evento per caricare la lista iniziale dei task
/// 
/// Viene emesso quando l'app si avvia o quando si vuole
/// ricaricare l'intera lista dei task
class LoadTodos extends TodoEvent {
  const LoadTodos();
}

/// Evento per aggiungere un nuovo task alla lista
/// 
/// Richiede il titolo e opzionalmente una descrizione
class AddTodo extends TodoEvent {
  /// Titolo del nuovo task
  final String title;
  
  /// Descrizione opzionale del task
  final String description;

  const AddTodo({
    required this.title,
    this.description = '',
  });

  @override
  List<Object?> get props => [title, description];
}

/// Evento per aggiornare un task esistente
/// 
/// Permette di modificare il titolo, la descrizione o lo stato
/// di completamento di un task esistente
class UpdateTodo extends TodoEvent {
  /// Task aggiornato con le nuove informazioni
  final Todo todo;

  const UpdateTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

/// Evento per eliminare un task dalla lista
/// 
/// Richiede l'ID del task da rimuovere
class DeleteTodo extends TodoEvent {
  /// ID del task da eliminare
  final String id;

  const DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

/// Evento per cambiare lo stato di completamento di un task
/// 
/// Toggle tra completato e non completato
class ToggleTodo extends TodoEvent {
  /// ID del task da modificare
  final String id;

  const ToggleTodo(this.id);

  @override
  List<Object?> get props => [id];
}

/// Evento per eliminare tutti i task completati
/// 
/// Rimuove dalla lista tutti i task che hanno isCompleted = true
class ClearCompleted extends TodoEvent {
  const ClearCompleted();
}
