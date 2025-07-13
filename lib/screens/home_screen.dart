import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_multiple_state_management/providers/todpo_providers.dart';
import 'package:todo_multiple_state_management/widgets/add_todo.dart';
import 'package:todo_multiple_state_management/widgets/empty_state.dart';
import 'package:todo_multiple_state_management/widgets/todo_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final completedCount = ref
        .watch(todoListProvider.notifier)
        .completedTodos
        .length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Todo App'),
        actions: [
          if (completedCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _deleteCompleted(ref),
              tooltip: 'Delete Completed',
            ),
        ],
      ),
      body: todos.isEmpty ? EmptyState() : TodoList(),

      floatingActionButton: const AddTodoButton(),
    );
  }

  void _deleteCompleted(WidgetRef ref) {
    showDialog(
      context: ref.context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Completed Tasks'),
        content: const Text(
          'Are you sure you want to delete all completed tasks?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(todoListProvider.notifier).deleteCompleted();

              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
