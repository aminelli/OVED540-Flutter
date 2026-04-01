import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../models/todo.dart';

/// Schermata principale dell'applicazione Todo List
/// 
/// Utilizza BlocBuilder per ascoltare i cambiamenti di stato
/// e ricostruire l'UI di conseguenza
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Pulsante per eliminare tutti i task completati
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Elimina completati',
            onPressed: () {
              // Invia l'evento ClearCompleted al Bloc
              context.read<TodoBloc>().add(const ClearCompleted());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Widget che mostra le statistiche dei task
          const _TodoStats(),
          
          const Divider(height: 1),
          
          // Lista dei task con BlocBuilder
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                // Gestione dei diversi stati
                if (state is TodoInitial) {
                  // Stato iniziale - carica i task
                  context.read<TodoBloc>().add(const LoadTodos());
                  return const Center(
                    child: Text('Inizializzazione...'),
                  );


                } else if (state is TodoLoading) {
                  // Stato di caricamento - mostra indicatore
                  return const Center(
                    child: CircularProgressIndicator(),
                  );


                } else if (state is TodoError) {
                  // Stato di errore - mostra messaggio
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                
                
                } else if (state is TodoLoaded) {
                  // Stato caricato - mostra la lista
                  if (state.todos.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nessun task!\nAggiungi il tuo primo task premendo il pulsante +',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Lista dei task
                  return ListView.builder(
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return _TodoItem(todo: todo);
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      // Pulsante per aggiungere un nuovo task
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        tooltip: 'Aggiungi Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Mostra il dialog per aggiungere un nuovo task
  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuovo Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Titolo',
                hintText: 'Es: Comprare il latte',
                border: OutlineInputBorder(),
              ),
              
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrizione (opzionale)',
                hintText: 'Dettagli aggiuntivi...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text;
              final description = descriptionController.text;
              
              if (title.isNotEmpty) {
                // Invia l'evento AddTodo al Bloc
                context.read<TodoBloc>().add(
                  AddTodo(
                    title: title,
                    description: description,
                  ),
                );
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Aggiungi'),
          ),
        ],
      ),
    );
  }
}

/// Widget che rappresenta un singolo task nella lista
class _TodoItem extends StatelessWidget {
  final Todo todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Permette di eliminare il task con uno swipe
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        // Invia l'evento DeleteTodo al Bloc
        context.read<TodoBloc>().add(DeleteTodo(todo.id));
        
        // Mostra snackbar di conferma
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${todo.title}" eliminato'),
            action: SnackBarAction(
              label: 'ANNULLA',
              onPressed: () {
                // In un'app reale, qui potremmo ripristinare il task
              },
            ),
          ),
        );
      },
      child: ListTile(
        // Checkbox per segnare come completato
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) {
            // Invia l'evento ToggleTodo al Bloc
            context.read<TodoBloc>().add(ToggleTodo(todo.id));
          },
        ),
        
        // Titolo del task (barrato se completato)
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted  ? TextDecoration.lineThrough  : null,
            color: todo.isCompleted  ? Colors.grey : null,
            fontWeight: todo.isCompleted  ? FontWeight.normal  : FontWeight.w500,
          ),
        ),
        
        // Descrizione del task (se presente)
        subtitle: todo.description.isNotEmpty
            ? Text(
                todo.description,
                style: TextStyle(
                  decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  color: Colors.grey,
                ),
              )
            : null,
        
        // Icona che indica se è completato
        trailing: todo.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        
        // Tap per modificare il task
        onTap: () => _showEditTodoDialog(context, todo),
      ),
    );
  }

  /// Mostra il dialog per modificare un task esistente
  void _showEditTodoDialog(BuildContext context, Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifica Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titolo',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrizione',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text;
              final description = descriptionController.text;
              
              if (title.isNotEmpty) {
                // Invia l'evento UpdateTodo al Bloc
                context.read<TodoBloc>().add(
                  UpdateTodo(
                    todo.copyWith(
                      title: title,
                      description: description,
                    ),
                  ),
                );
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }
}



/// Widget che mostra le statistiche dei task
class _TodoStats extends StatelessWidget {
  const _TodoStats();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is! TodoLoaded) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatCard(
                icon: Icons.list,
                label: 'Totali',
                count: state.totalCount,
                color: Colors.blue,
              ),
              _StatCard(
                icon: Icons.pending_actions,
                label: 'Da fare',
                count: state.activeCount,
                color: Colors.orange,
              ),
              _StatCard(
                icon: Icons.check_circle,
                label: 'Completati',
                count: state.completedCount,
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget che rappresenta una card di statistica
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
