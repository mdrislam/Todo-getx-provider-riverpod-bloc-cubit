import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_multiple_state_management/providers/todpo_providers.dart';

import '../widgets/add_todo.dart';
import '../widgets/todo_list.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TodoProvider>(context, listen: false).loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Todo App'),
        actions: [
          Consumer<TodoProvider>(
            builder: (context, provider, _) {
              if (provider.completedTodos.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _deleteCompleted(context),
                  tooltip: 'Delete Completed',
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, _) {
          if (provider.allTodos.isEmpty) {
            return const EmptyState();
          }
          return const TodoList();
        },
      ),
      floatingActionButton: const AddTodoButton(),
    );
  }

  void _deleteCompleted(BuildContext context) {
    showDialog(
      context: context,
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
              Provider.of<TodoProvider>(
                context,
                listen: false,
              ).deleteCompleted();
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
