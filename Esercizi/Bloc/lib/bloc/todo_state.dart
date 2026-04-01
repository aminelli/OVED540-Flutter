import 'package:equatable/equatable.dart';
import '../models/todo.dart';

/// Classe astratta base per tutti gli stati del TodoBloc
/// 
/// Rappresenta le diverse situazioni in cui può trovarsi
/// l'applicazione durante la gestione dei task
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

/// Stato iniziale prima del caricamento dei dati
/// 
/// Questo è lo stato di partenza quando il Bloc viene creato
class TodoInitial extends TodoState {
  const TodoInitial();
}

/// Stato di caricamento in corso
/// 
/// Indica che un'operazione è in esecuzione (es: caricamento dei task)
/// Utile per mostrare un indicatore di caricamento nell'UI
class TodoLoading extends TodoState {
  const TodoLoading();
}

/// Stato di successo con la lista dei task caricata
/// 
/// Contiene la lista completa di tutti i task da visualizzare
class TodoLoaded extends TodoState {
  /// Lista di tutti i task
  final List<Todo> todos;

  const TodoLoaded(this.todos);

  @override
  List<Object?> get props => [todos];

  /// Restituisce il numero totale di task
  int get totalCount => todos.length;

  /// Restituisce il numero di task completati
  int get completedCount => todos.where((todo) => todo.isCompleted).length;

  /// Restituisce il numero di task ancora da completare
  int get activeCount => todos.where((todo) => !todo.isCompleted).length;

  /// Restituisce solo i task completati
  List<Todo> get completedTodos => 
      todos.where((todo) => todo.isCompleted).toList();

  /// Restituisce solo i task attivi (non completati)
  List<Todo> get activeTodos => 
      todos.where((todo) => !todo.isCompleted).toList();
}

/// Stato di errore
/// 
/// Indica che si è verificato un problema durante un'operazione
class TodoError extends TodoState {
  /// Messaggio di errore da visualizzare all'utente
  final String message;

  const TodoError(this.message);

  @override
  List<Object?> get props => [message];
}
