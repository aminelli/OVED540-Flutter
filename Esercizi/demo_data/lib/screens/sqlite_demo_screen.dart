import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/task_model.dart';

/// Schermata demo per SQLite Database (sqflite).
/// 
/// Implementa un sistema CRUD completo per task:
/// - Create: Aggiungi nuovi task
/// - Read: Visualizza tutti i task, filtra per completati/pendenti
/// - Update: Modifica task esistenti, toggle completamento
/// - Delete: Elimina task singoli o tutti i completati
/// 
/// Include anche statistiche e ricerca.
class SqliteDemoScreen extends StatefulWidget {
  const SqliteDemoScreen({super.key});

  @override
  State<SqliteDemoScreen> createState() => _SqliteDemoScreenState();
}

class _SqliteDemoScreenState extends State<SqliteDemoScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  
  List<TaskModel> _tasks = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  String _filter = 'all'; // all, pending, completed

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadStats();
  }

  /// Carica i task in base al filtro selezionato
  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    
    try {
      List<TaskModel> tasks;
      switch (_filter) {
        case 'pending':
          tasks = await _databaseService.getPendingTasks();
          break;
        case 'completed':
          tasks = await _databaseService.getCompletedTasks();
          break;
        default:
          tasks = await _databaseService.getAllTasks();
      }
      
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error loading tasks: $e');
    }
  }

  /// Carica le statistiche del database
  Future<void> _loadStats() async {
    try {
      final stats = await _databaseService.getDatabaseStats();
      setState(() => _stats = stats);
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  /// Mostra dialog per creare/modificare un task
  Future<void> _showTaskDialog({TaskModel? task}) async {
    final isEditing = task != null;
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController =
        TextEditingController(text: task?.description ?? '');
    bool isCompleted = task?.completed ?? false;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: isCompleted,
                  onChanged: (value) {
                    setDialogState(() => isCompleted = value ?? false);
                  },
                  title: const Text('Completed'),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isEmpty) {
                  _showError('Title cannot be empty');
                  return;
                }

                Navigator.pop(context);

                try {
                  if (isEditing) {
                    final updatedTask = task.copyWith(
                      title: title,
                      description: description,
                      completed: isCompleted,
                    );
                    await _databaseService.updateTask(updatedTask);
                    _showSuccess('Task updated!');
                  } else {
                    final newTask = TaskModel(
                      title: title,
                      description: description,
                      completed: isCompleted,
                    );
                    await _databaseService.insertTask(newTask);
                    _showSuccess('Task created!');
                  }
                  _loadTasks();
                  _loadStats();
                } catch (e) {
                  _showError('Error saving task: $e');
                }
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  /// Toggle dello stato completato di un task
  Future<void> _toggleTaskCompleted(TaskModel task) async {
    try {
      await _databaseService.toggleTaskCompleted(task.id!);
      _showSuccess('Task ${task.completed ? "reopened" : "completed"}!');
      _loadTasks();
      _loadStats();
    } catch (e) {
      _showError('Error updating task: $e');
    }
  }

  /// Elimina un task
  Future<void> _deleteTask(TaskModel task) async {
    final confirm = await _showConfirmDialog(
      'Delete Task',
      'Are you sure you want to delete "${task.title}"?',
    );

    if (confirm == true) {
      try {
        await _databaseService.deleteTask(task.id!);
        _showSuccess('Task deleted!');
        _loadTasks();
        _loadStats();
      } catch (e) {
        _showError('Error deleting task: $e');
      }
    }
  }

  /// Elimina tutti i task completati
  Future<void> _deleteCompletedTasks() async {
    final confirm = await _showConfirmDialog(
      'Delete Completed Tasks',
      'Are you sure you want to delete all completed tasks?',
    );

    if (confirm == true) {
      try {
        final count = await _databaseService.deleteCompletedTasks();
        _showSuccess('$count completed tasks deleted!');
        _loadTasks();
        _loadStats();
      } catch (e) {
        _showError('Error deleting completed tasks: $e');
      }
    }
  }

  /// Resetta il database
  Future<void> _resetDatabase() async {
    final confirm = await _showConfirmDialog(
      'Reset Database',
      'This will delete all tasks and reset the database. Continue?',
    );

    if (confirm == true) {
      try {
        await _databaseService.resetDatabase();
        _showSuccess('Database reset successfully!');
        _loadTasks();
        _loadStats();
      } catch (e) {
        _showError('Error resetting database: $e');
      }
    }
  }

  /// Ricerca task
  Future<void> _searchTasks() async {
    final controller = TextEditingController();
    final query = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Tasks'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Search query',
            hintText: 'Enter title or description',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );

    if (query != null && query.isNotEmpty) {
      try {
        final results = await _databaseService.searchTasks(query);
        setState(() => _tasks = results);
        _showSuccess('Found ${results.length} tasks');
      } catch (e) {
        _showError('Error searching: $e');
      }
    }
  }

  /// Mostra statistiche
  void _showStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Database Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Total Tasks', _stats['total']?.toString() ?? '0'),
            _buildStatRow('Completed', _stats['completed']?.toString() ?? '0'),
            _buildStatRow('Pending', _stats['pending']?.toString() ?? '0'),
            const Divider(),
            _buildStatRow(
              'Completion Rate',
              '${_stats['completion_rate'] ?? "0.0"}%',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmDialog(String title, String message) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se SQLite è disponibile (non su web)
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SQLite Demo'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
                const SizedBox(height: 24),
                Text(
                  'SQLite not available on Web',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'SQLite requires a desktop or mobile platform.\n\nPlease run the app on:',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text('Windows'), avatar: Icon(Icons.desktop_windows, size: 18)),
                    Chip(label: Text('macOS'), avatar: Icon(Icons.desktop_mac, size: 18)),
                    Chip(label: Text('Linux'), avatar: Icon(Icons.computer, size: 18)),
                    Chip(label: Text('Android'), avatar: Icon(Icons.android, size: 18)),
                    Chip(label: Text('iOS'), avatar: Icon(Icons.phone_iphone, size: 18)),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Menu'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchTasks,
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStats,
            tooltip: 'Statistics',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'delete_completed':
                  _deleteCompletedTasks();
                  break;
                case 'reset':
                  _resetDatabase();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_completed',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, size: 20),
                    SizedBox(width: 8),
                    Text('Delete Completed'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Reset Database', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtri
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _filter == 'all',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _filter = 'all');
                        _loadTasks();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Pending'),
                    selected: _filter == 'pending',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _filter = 'pending');
                        _loadTasks();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Completed'),
                    selected: _filter == 'completed',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _filter = 'completed');
                        _loadTasks();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Stats Banner
          if (_stats.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatBadge(
                    'Total',
                    _stats['total']?.toString() ?? '0',
                    Colors.blue,
                  ),
                  _buildStatBadge(
                    'Pending',
                    _stats['pending']?.toString() ?? '0',
                    Colors.orange,
                  ),
                  _buildStatBadge(
                    'Done',
                    _stats['completed']?.toString() ?? '0',
                    Colors.green,
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Task List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tasks.isEmpty
                    ? _buildEmptyState()
                    : _buildTaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    String message;
    switch (_filter) {
      case 'pending':
        message = 'No pending tasks';
        break;
      case 'completed':
        message = 'No completed tasks';
        break;
      default:
        message = 'No tasks yet';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
            ),
          ),
          if (_filter == 'all') ...[
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first task',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (value) => _toggleTaskCompleted(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description.isNotEmpty)
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(task.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showTaskDialog(task: task);
                } else if (value == 'delete') {
                  _deleteTask(task);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _showTaskDialog(task: task),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
