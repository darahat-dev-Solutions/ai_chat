import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/tasks/provider/task_providers.dart';

/// Dialog Task Update and Delete function
void showUpdateDeleteTaskDialog(BuildContext context, WidgetRef ref, task) {
  final textController = TextEditingController();
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Take Action'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Task Title"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                ref.read(taskControllerProvider.notifier).removeTask(task.tid!);
              },
              child: const Text('Done'),
            ),
            TextButton(
              onPressed: () {
                ref.read(taskControllerProvider.notifier).toggleTask(task.tid!);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  ref
                      .read(taskControllerProvider.notifier)
                      .editTask(task.tid!, textController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
  );
}
