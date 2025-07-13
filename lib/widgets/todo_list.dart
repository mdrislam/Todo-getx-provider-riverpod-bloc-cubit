import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_multiple_state_management/providers/todpo_providers.dart';
import 'package:todo_multiple_state_management/widgets/todo_item.dart';

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final activeCount = ref.watch(todoListProvider.notifier).activeTodos.length;
    final completedCount = ref
        .watch(todoListProvider.notifier)
        .completedTodos
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '$activeCount Active Tasks',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: todos.length,
            itemBuilder: (ctx, index) {
              final todo = todos[index];
              return TodoItem(todo: todo);
            },
          ),
        ),
        if (completedCount > 0) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '$completedCount Completed Tasks',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
