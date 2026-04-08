import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

/// Service per gestire il database SQLite.
/// 
/// Implementa:
/// - Creazione e gestione del database
/// - Operazioni CRUD (Create, Read, Update, Delete) sui task
/// - Queries con filtri e ordinamento
/// - Transazioni
/// - Migrations
/// 
/// Il database contiene una tabella 'tasks' per dimostrare le funzionalità SQLite.
class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._internal();

  DatabaseService._internal();

  /// Ottiene l'istanza del database (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inizializza il database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, StorageKeys.databaseName);

    return await openDatabase(
      path,
      version: StorageKeys.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Callback di creazione database (prima installazione)
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${StorageKeys.tasksTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    // Inserisci dati di esempio
    await _insertSampleData(db);
  }

  /// Callback di upgrade database (gestione versioni)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementare migrations qui se necessario
    // Esempio:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE tasks ADD COLUMN priority INTEGER');
    // }
  }

  /// Inserisce dati di esempio nel database
  Future<void> _insertSampleData(Database db) async {
    final sampleTasks = [
      TaskModel(
        title: 'Welcome to SQLite Demo',
        description: 'This is a sample task to demonstrate SQLite functionality',
        completed: false,
      ),
      TaskModel(
        title: 'Learn Flutter Storage',
        description: 'Explore different storage options in Flutter',
        completed: false,
      ),
      TaskModel(
        title: 'Complete Demo',
        description: 'Test all CRUD operations',
        completed: true,
      ),
    ];

    for (final task in sampleTasks) {
      await db.insert(
        StorageKeys.tasksTable,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // ==================== CREATE ====================

  /// Inserisce un nuovo task nel database
  /// 
  /// [task] il task da inserire
  /// Ritorna l'ID del task inserito
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert(
      StorageKeys.tasksTable,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Inserisce multiple task in una transazione
  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final task in tasks) {
        await txn.insert(
          StorageKeys.tasksTable,
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // ==================== READ ====================

  /// Ottiene tutti i task dal database
  /// 
  /// [orderBy] campo per ordinamento (default: 'createdAt DESC')
  Future<List<TaskModel>> getAllTasks({String? orderBy}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      StorageKeys.tasksTable,
      orderBy: orderBy ?? 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  /// Ottiene un task specifico per ID
  /// 
  /// [id] ID del task
  /// Ritorna il task o null se non trovato
  Future<TaskModel?> getTaskById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      StorageKeys.tasksTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  /// Ottiene i task completati
  Future<List<TaskModel>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      StorageKeys.tasksTable,
      where: 'completed = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  /// Ottiene i task non completati
  Future<List<TaskModel>> getPendingTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      StorageKeys.tasksTable,
      where: 'completed = ?',
      whereArgs: [0],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  /// Cerca task per titolo o descrizione
  /// 
  /// [query] testo da cercare
  Future<List<TaskModel>> searchTasks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      StorageKeys.tasksTable,
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  /// Conta il numero totale di task
  Future<int> getTaskCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM ${StorageKeys.tasksTable}');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==================== UPDATE ====================

  /// Aggiorna un task esistente
  /// 
  /// [task] il task con i nuovi dati (deve avere un ID)
  /// Ritorna il numero di righe aggiornate
  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      StorageKeys.tasksTable,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  /// Toggle dello stato completed di un task
  /// 
  /// [id] ID del task
  Future<void> toggleTaskCompleted(int id) async {
    final task = await getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(completed: !task.completed);
      await updateTask(updatedTask);
    }
  }

  // ==================== DELETE ====================

  /// Elimina un task specifico
  /// 
  /// [id] ID del task da eliminare
  /// Ritorna il numero di righe eliminate
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      StorageKeys.tasksTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Elimina tutti i task completati
  Future<int> deleteCompletedTasks() async {
    final db = await database;
    return await db.delete(
      StorageKeys.tasksTable,
      where: 'completed = ?',
      whereArgs: [1],
    );
  }

  /// Elimina tutti i task (usa con cautela!)
  Future<int> deleteAllTasks() async {
    final db = await database;
    return await db.delete(StorageKeys.tasksTable);
  }

  // ==================== UTILITY ====================

  /// Chiude il database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Resetta il database (elimina e ricrea)
  Future<void> resetDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, StorageKeys.databaseName);
    
    await deleteDatabase(path);
    _database = null;
    
    // Reinizializza il database
    await database;
  }

  /// Ottiene statistiche del database
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final totalTasks = await getTaskCount();
    final completedTasks = await getCompletedTasks();
    final pendingTasks = await getPendingTasks();

    return {
      'total': totalTasks,
      'completed': completedTasks.length,
      'pending': pendingTasks.length,
      'completion_rate': totalTasks > 0
          ? (completedTasks.length / totalTasks * 100).toStringAsFixed(1)
          : '0.0',
    };
  }
}
