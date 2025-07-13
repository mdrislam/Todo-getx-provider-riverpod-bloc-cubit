import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_multiple_state_management/providers/todpo_providers.dart';

class AddTodoButton extends ConsumerWidget {
  const AddTodoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _showAddDialog(ref),
      child: const Icon(Icons.add),
    );
  }

  void _showAddDialog(WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: ref.context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter task title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(todoListProvider.notifier)
                    .addTodo(controller.text.trim());
              }
              final todos = ref.watch(todoListProvider);
              print(todos.length);
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
