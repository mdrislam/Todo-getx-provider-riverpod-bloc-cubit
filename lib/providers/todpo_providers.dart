import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../database/database_helper.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Todo> get allTodos => [..._todos];
  List<Todo> get activeTodos =>
      _todos.where((todo) => !todo.completed).toList();
  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.completed).toList();

  Future<void> loadTodos() async {
    final todos = await _dbHelper.getAllTodos();
    _todos.clear();
    _todos.addAll(todos);
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final todo = Todo(title: title);
    _todos.add(todo);
    await _dbHelper.insertTodo(todo);
    notifyListeners();
  }

  Future<void> updateTodo(String id, String newTitle) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index >= 0) {
      _todos[index].updateTitle(newTitle);
      await _dbHelper.updateTodo(_todos[index]);
      notifyListeners();
    }
  }

  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index >= 0) {
      _todos[index].toggleComplete();
      await _dbHelper.updateTodo(_todos[index]);
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _dbHelper.deleteTodo(id);
    notifyListeners();
  }

  Future<void> deleteCompleted() async {
    _todos.removeWhere((todo) => todo.completed);
    await _dbHelper.deleteCompletedTodos();
    notifyListeners();
  }
}
