import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

/// TodoBloc - Gestisce la Business Logic dell'applicazione Todo
/// 
/// Questo è il cuore dell'architettura Bloc. Riceve gli eventi dall'UI,
/// esegue la logica di business e emette nuovi stati che l'UI ascolta.
/// 
/// Vantaggi del pattern Bloc:
/// - Separazione tra logica di business e UI
/// - Testabilità (la logica può essere testata indipendentemente dall'UI)
/// - Gestione prevedibile dello stato
/// - Codice più manutenibile e scalabile
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  /// Lista privata dei task (sorgente di verità)
  List<Todo> _todos = [];

  /// Costruttore - inizializza il Bloc con lo stato iniziale
  /// 
  /// Registra tutti i gestori degli eventi (event handlers)
  TodoBloc() : super(const TodoInitial()) {
    // Registra il gestore per l'evento LoadTodos
    on<LoadTodos>(_onLoadTodos);
    
    // Registra il gestore per l'evento AddTodo
    on<AddTodo>(_onAddTodo);
    
    // Registra il gestore per l'evento UpdateTodo
    on<UpdateTodo>(_onUpdateTodo);
    
    // Registra il gestore per l'evento DeleteTodo
    on<DeleteTodo>(_onDeleteTodo);
    
    // Registra il gestore per l'evento ToggleTodo
    on<ToggleTodo>(_onToggleTodo);
    
    // Registra il gestore per l'evento ClearCompleted
    on<ClearCompleted>(_onClearCompleted);
  }

  /// Gestisce l'evento LoadTodos
  /// 
  /// Carica la lista iniziale dei task. In un'app reale, qui
  /// si farebbe una chiamata a un database o API REST.
  Future<void> _onLoadTodos(
    LoadTodos event,
    Emitter<TodoState> emit,
  ) async {
    try {
      // Emetti lo stato di caricamento
      emit(const TodoLoading());
      
      // Simula un caricamento da database/API (ritardo di 1 secondo)
      await Future.delayed(const Duration(seconds: 1));
      
      // Per questo esempio, carichiamo alcuni task predefiniti
      _todos = [
        const Todo(
          id: '1',
          title: 'Imparare Flutter',
          description: 'Studiare i fondamenti di Flutter e Dart',
          isCompleted: false,
        ),
        const Todo(
          id: '2',
          title: 'Imparare Bloc Pattern',
          description: 'Comprendere architettura Bloc per gestione stato',
          isCompleted: false,
        ),
        const Todo(
          id: '3',
          title: 'Creare app demo',
          description: 'Implementare un\'app di esempio con Bloc',
          isCompleted: false,
        ),
      ];
      
      // Emetti lo stato di successo con i task caricati
      emit(TodoLoaded(_todos));
    } catch (error) {
      // In caso di errore, emetti lo stato di errore
      emit(TodoError('Errore durante il caricamento dei task: $error'));
    }
  }

  /// Gestisce l'evento AddTodo
  /// 
  /// Aggiunge un nuovo task alla lista
  Future<void> _onAddTodo(
    AddTodo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      // Verifica che il titolo non sia vuoto
      if (event.title.trim().isEmpty) {
        emit(const TodoError('Il titolo del task non può essere vuoto'));
        emit(TodoLoaded(_todos)); // Ritorna allo stato precedente
        return;
      }

      // Crea un nuovo Todo con un ID univoco (timestamp)
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title.trim(),
        description: event.description.trim(),
        isCompleted: false,
      );

      // Aggiunge il nuovo task alla lista
      _todos = [..._todos, newTodo];

      // Emetti il nuovo stato con la lista aggiornata
      emit(TodoLoaded(_todos));
    } catch (error) {
      emit(TodoError('Errore durante l\'aggiunta del task: $error'));
      emit(TodoLoaded(_todos));
    }
  }

  /// Gestisce l'evento UpdateTodo
  /// 
  /// Aggiorna un task esistente con nuovi dati
  Future<void> _onUpdateTodo(
    UpdateTodo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      // Trova l'indice del task da aggiornare
      final index = _todos.indexWhere((todo) => todo.id == event.todo.id);
      
      if (index == -1) {
        emit(const TodoError('Task non trovato'));
        emit(TodoLoaded(_todos));
        return;
      }

      // Crea una nuova lista con il task aggiornato
      _todos = List.from(_todos)..[index] = event.todo;

      // Emetti il nuovo stato
      emit(TodoLoaded(_todos));
    } catch (error) {
      emit(TodoError('Errore durante l\'aggiornamento del task: $error'));
      emit(TodoLoaded(_todos));
    }
  }

  /// Gestisce l'evento DeleteTodo
  /// 
  /// Rimuove un task dalla lista
  Future<void> _onDeleteTodo(
    DeleteTodo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      // Rimuove il task con l'ID specificato
      _todos = _todos.where((todo) => todo.id != event.id).toList();

      // Emetti il nuovo stato
      emit(TodoLoaded(_todos));
    } catch (error) {
      emit(TodoError('Errore durante l\'eliminazione del task: $error'));
      emit(TodoLoaded(_todos));
    }
  }

  /// Gestisce l'evento ToggleTodo
  /// 
  /// Cambia lo stato di completamento di un task (da completato a non completato e viceversa)
  Future<void> _onToggleTodo(
    ToggleTodo event,
    Emitter<TodoState> emit,
  ) async {
    try {
      // Trova il task da modificare
      final index = _todos.indexWhere((todo) => todo.id == event.id);
      
      if (index == -1) {
        emit(const TodoError('Task non trovato'));
        emit(TodoLoaded(_todos));
        return;
      }

      // Crea una copia del task con lo stato invertito
      final updatedTodo = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );

      // Aggiorna la lista
      _todos = List.from(_todos)..[index] = updatedTodo;

      // Emetti il nuovo stato
      emit(TodoLoaded(_todos));
    } catch (error) {
      emit(TodoError('Errore durante la modifica del task: $error'));
      emit(TodoLoaded(_todos));
    }
  }

  /// Gestisce l'evento ClearCompleted
  /// 
  /// Rimuove tutti i task completati dalla lista
  Future<void> _onClearCompleted(
    ClearCompleted event,
    Emitter<TodoState> emit,
  ) async {
    try {
      // Mantiene solo i task non completati
      _todos = _todos.where((todo) => !todo.isCompleted).toList();

      // Emetti il nuovo stato
      emit(TodoLoaded(_todos));
    } catch (error) {
      emit(TodoError('Errore durante la pulizia dei task completati: $error'));
      emit(TodoLoaded(_todos));
    }
  }
}
