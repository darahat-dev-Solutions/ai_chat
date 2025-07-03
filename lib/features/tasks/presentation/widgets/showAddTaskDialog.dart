import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/features/tasks/provider/task_providers.dart';

void showAddTaskDialog(BuildContext context, WidgetRef ref) {
  final textController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text(
            "Add New Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Enter task description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            autofocus: true,
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  ref
                      .read(taskControllerProvider.notifier)
                      .addTask(textController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Task"),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
        ),
  );
}
