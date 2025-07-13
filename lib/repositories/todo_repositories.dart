import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class TodoRepository {
  static final TodoRepository _instance = TodoRepository._internal();
  Database? _database;

  TodoRepository._internal();

  factory TodoRepository() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todo_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos(
            id TEXT PRIMARY KEY,
            title TEXT,
            completed INTEGER,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');
      },
    );
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return maps.map((map) => Todo.fromMap(map)).toList();
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    await db.insert('todos', todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(String id) async {
    final db = await database;
    await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteCompletedTodos() async {
    final db = await database;
    await db.delete('todos', where: 'completed = ?', whereArgs: [1]);
  }
}
