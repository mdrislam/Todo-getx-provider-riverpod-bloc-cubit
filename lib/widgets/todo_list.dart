import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_multiple_state_management/providers/todpo_providers.dart';

import 'todo_item.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '${provider.activeTodos.length} Active Tasks',
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
                itemCount: provider.allTodos.length,
                itemBuilder: (ctx, index) {
                  final todo = provider.allTodos[index];
                  return TodoItem(todo: todo);
                },
              ),
            ),
            if (provider.completedTodos.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  '${provider.completedTodos.length} Completed Tasks',
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
      },
    );
  }
}
