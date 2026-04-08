import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/hive_service.dart';
import '../models/note_hive_model.dart';

/// Schermata demo per Hive Database.
/// 
/// Implementa un sistema CRUD completo per note:
/// - Create: Aggiungi nuove note con categoria
/// - Read: Visualizza tutte le note, filtra per categoria/preferite
/// - Update: Modifica note esistenti
/// - Delete: Elimina note singole o tutte
/// 
/// Dimostra le funzionalità di Hive:
/// - Operazioni veloci e sincrone
/// - Type-safe storage
/// - Filtri e ricerca
/// - Statistiche
class HiveDemoScreen extends StatefulWidget {
  const HiveDemoScreen({super.key});

  @override
  State<HiveDemoScreen> createState() => _HiveDemoScreenState();
}

class _HiveDemoScreenState extends State<HiveDemoScreen> {
  final HiveService _hiveService = HiveService();
  final TextEditingController _searchController = TextEditingController();
  
  List<NoteHiveModel> _notes = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  String _filter = 'all'; // all, favorites, category
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadStats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carica le note in base al filtro selezionato
  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    
    try {
      List<NoteHiveModel> notes;
      
      if (_searchController.text.isNotEmpty) {
        notes = await _hiveService.searchNotes(_searchController.text);
      } else {
        switch (_filter) {
          case 'favorites':
            notes = await _hiveService.getFavoriteNotes();
            break;
          case 'category':
            if (_selectedCategory != null) {
              notes = await _hiveService.getNotesByCategory(_selectedCategory!);
            } else {
              notes = await _hiveService.getAllNotes();
            }
            break;
          default:
            notes = await _hiveService.getAllNotes();
        }
      }
      
      // Ordina per data di creazione (più recenti prima)
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error loading notes: $e');
    }
  }

  /// Carica le statistiche del database
  Future<void> _loadStats() async {
    try {
      final stats = await _hiveService.getStats();
      setState(() => _stats = stats);
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  /// Mostra dialog per creare/modificare una nota
  Future<void> _showNoteDialog({NoteHiveModel? note}) async {
    final isEditing = note != null;
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    String? category = note?.category;
    bool isFavorite = note?.isFavorite ?? false;
    
    final categories = ['Personal', 'Work', 'Dev', 'Info', 'Ideas', 'Other'];

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(isEditing ? Icons.edit : Icons.add_circle_outline),
              const SizedBox(width: 8),
              Text(isEditing ? 'Edit Note' : 'New Note'),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter note title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter note content',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    hint: const Text('Select category'),
                    items: categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() => category = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: isFavorite,
                    onChanged: (value) {
                      setDialogState(() => isFavorite = value ?? false);
                    },
                    title: const Text('Favorite'),
                    secondary: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : null,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final title = titleController.text.trim();
                final content = contentController.text.trim();
                
                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                
                try {
                  if (isEditing) {
                    final updatedNote = note.copyWith(
                      title: title,
                      content: content,
                      category: category,
                      isFavorite: isFavorite,
                      updatedAt: DateTime.now(),
                    );
                    await _hiveService.updateNote(updatedNote);
                    _showSuccess('Note updated!');
                  } else {
                    final newNote = NoteHiveModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      content: content,
                      createdAt: DateTime.now(),
                      category: category,
                      isFavorite: isFavorite,
                    );
                    await _hiveService.createNote(newNote);
                    _showSuccess('Note created!');
                  }
                  
                  Navigator.pop(context);
                  _loadNotes();
                  _loadStats();
                } catch (e) {
                  _showError('Error saving note: $e');
                }
              },
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? 'Save' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  /// Elimina una nota con conferma
  Future<void> _deleteNote(NoteHiveModel note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _hiveService.deleteNote(note.id);
        _showSuccess('Note deleted');
        _loadNotes();
        _loadStats();
      } catch (e) {
        _showError('Error deleting note: $e');
      }
    }
  }

  /// Toggle favorite status
  Future<void> _toggleFavorite(NoteHiveModel note) async {
    try {
      await _hiveService.toggleFavorite(note.id);
      _loadNotes();
      _loadStats();
    } catch (e) {
      _showError('Error updating favorite: $e');
    }
  }

  /// Mostra statistiche
  void _showStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bar_chart),
            SizedBox(width: 8),
            Text('Hive Statistics'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatRow(
              icon: Icons.note,
              label: 'Total Notes',
              value: _stats['totalNotes']?.toString() ?? '0',
            ),
            _StatRow(
              icon: Icons.star,
              label: 'Favorites',
              value: _stats['favorites']?.toString() ?? '0',
            ),
            _StatRow(
              icon: Icons.category,
              label: 'Categories',
              value: _stats['categories']?.toString() ?? '0',
            ),
            _StatRow(
              icon: Icons.storage,
              label: 'Box Size',
              value: _stats['boxSize']?.toString() ?? '0',
            ),
            if (_stats['categoryList'] != null && 
                (_stats['categoryList'] as List).isNotEmpty) ...[
              const Divider(height: 24),
              const Text(
                'Categories:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: (_stats['categoryList'] as List<String>)
                    .map((cat) => Chip(label: Text(cat)))
                    .toList(),
              ),
            ],
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

  /// Reset database con conferma
  Future<void> _resetDatabase() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Database'),
        content: const Text(
          'This will delete ALL notes and insert sample data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _hiveService.deleteAllNotes();
        await _hiveService.insertSampleData();
        _showSuccess('Database reset complete!');
        _loadNotes();
        _loadStats();
      } catch (e) {
        _showError('Error resetting database: $e');
      }
    }
  }

  /// Compatta il database
  Future<void> _compactDatabase() async {
    try {
      await _hiveService.compact();
      _showSuccess('Database compacted!');
      _loadStats();
    } catch (e) {
      _showError('Error compacting database: $e');
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStats,
            tooltip: 'Statistics',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'compact':
                  _compactDatabase();
                  break;
                case 'reset':
                  _resetDatabase();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'compact',
                child: Row(
                  children: [
                    Icon(Icons.compress, size: 20),
                    SizedBox(width: 8),
                    Text('Compact Database'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore, size: 20, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Reset Database', style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchController.clear());
                          _loadNotes();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => _loadNotes(),
            ),
          ),
          
          // Filters
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filter == 'all',
                  onSelected: (selected) {
                    setState(() {
                      _filter = 'all';
                      _selectedCategory = null;
                    });
                    _loadNotes();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16),
                      SizedBox(width: 4),
                      Text('Favorites'),
                    ],
                  ),
                  selected: _filter == 'favorites',
                  onSelected: (selected) {
                    setState(() {
                      _filter = 'favorites';
                      _selectedCategory = null;
                    });
                    _loadNotes();
                  },
                ),
                const SizedBox(width: 8),
                if (_stats['categoryList'] != null)
                  ...(_stats['categoryList'] as List<String>).map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: _filter == 'category' && _selectedCategory == cat,
                        onSelected: (selected) {
                          setState(() {
                            _filter = 'category';
                            _selectedCategory = cat;
                          });
                          _loadNotes();
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Notes list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_add,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No notes yet',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to create your first note',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          final note = _notes[index];
                          return _NoteCard(
                            note: note,
                            onTap: () => _showNoteDialog(note: note),
                            onDelete: () => _deleteNote(note),
                            onToggleFavorite: () => _toggleFavorite(note),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteDialog(),
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }
}

/// Widget per visualizzare una statistica
class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget card per visualizzare una nota
class _NoteCard extends StatelessWidget {
  final NoteHiveModel note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y • HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      note.isFavorite ? Icons.star : Icons.star_border,
                      color: note.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: onToggleFavorite,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (note.category != null) ...[
                    Chip(
                      label: Text(note.category!),
                      labelStyle: const TextStyle(fontSize: 12),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Icon(Icons.access_time, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(note.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (note.updatedAt != null) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.edit, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'edited',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
