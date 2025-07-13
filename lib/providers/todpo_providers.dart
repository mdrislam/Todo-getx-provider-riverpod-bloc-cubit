import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_multiple_state_management/repositories/todo_repositories.dart';
import '../models/todo.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository();
});

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
  (ref) => TodoListNotifier(ref),
);

class TodoListNotifier extends StateNotifier<List<Todo>> {
  final Ref ref;
  TodoListNotifier(this.ref) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final todos = await ref.read(todoRepositoryProvider).getAllTodos();
    state = todos;
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(title: title);
    final repository = ref.read(todoRepositoryProvider);
    await repository.insertTodo(newTodo);
    state = [...state, newTodo];
  }

  Future<void> updateTodo(String id, String newTitle) async {
    final repository = ref.read(todoRepositoryProvider);
    state = state.map((todo) {
      if (todo.id == id) {
        final updatedTodo = Todo(
          id: todo.id,
          title: newTitle,
          completed: todo.completed,
          createdAt: todo.createdAt,
        )..updateTitle(newTitle);
        repository.updateTodo(updatedTodo);
        return updatedTodo;
      }
      return todo;
    }).toList();
  }

  Future<void> toggleTodo(String id) async {
    final repository = ref.read(todoRepositoryProvider);
    state = state.map((todo) {
      if (todo.id == id) {
      
        final updatedTodo = Todo(
          id: todo.id,
          title: todo.title,
          completed: !todo.completed,
          createdAt: todo.createdAt,
        );
        // updatedTodo.toggleComplete();
        repository.updateTodo(updatedTodo);
        return updatedTodo;
      }
      return todo;
    }).toList();
  }

  Future<void> deleteTodo(String id) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.deleteTodo(id);
    state = state.where((todo) => todo.id != id).toList();
  }

  Future<void> deleteCompleted() async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.deleteCompletedTodos();
    state = state.where((todo) => !todo.completed).toList();
  }

  List<Todo> get activeTodos => state.where((todo) => !todo.completed).toList();
  List<Todo> get completedTodos =>
      state.where((todo) => todo.completed).toList();
}
