import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opsmate/features/auth/provider/auth_providers.dart';
import 'package:opsmate/features/tasks/application/task_controller.dart';
import 'package:opsmate/features/tasks/presentation/widgets/aiSummaryWidget.dart';
import 'package:opsmate/features/tasks/presentation/widgets/floatingbuttonwidget.dart';
import 'package:opsmate/features/tasks/provider/task_providers.dart';

/// Main Task dashboard
class TaskDashboard extends ConsumerStatefulWidget {
  /// Main Task Dashboard constructor
  const TaskDashboard({super.key});

  @override
  ConsumerState<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends ConsumerState<TaskDashboard> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(taskLoadingProvider);
    final tasks = ref.watch(incompleteTasksProvider);
    final isRecording = ref.watch(isListeningProvider);
    final auth = ref.read(authControllerProvider.notifier);
    String formattedDate = '';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await auth.signOut();
            if (ref.read(authControllerProvider) == null) {
              context.go('/tasks');
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logout Failed')));
            }
          },
          icon: const Icon(Icons.logout),
        ),
        title: const Text('OpsMate'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 10),

                        Text(
                          DateFormat('MMMM d, yyyy').format(DateTime.now()),
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AISummaryWidget(),
                  const SizedBox(height: 16),
                  RefreshIndicator(
                    onRefresh:
                        () =>
                            ref.read(taskControllerProvider.notifier).getTask(),
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];

                                if (task.taskCreationTime != null) {
                                  formattedDate = DateFormat(
                                    'dd MMM, yyyy – hh:mm a',
                                  ).format(
                                    DateTime.parse(task.taskCreationTime ?? ''),
                                  );
                                }
                                return CheckboxListTile(
                                  title: Text(task.title ?? ''),
                                  subtitle: Text(formattedDate),
                                  value: task.isCompleted,
                                  onChanged: (val) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: const Text('Take Action'),
                                          content: TextField(
                                            controller: textController,
                                            decoration: const InputDecoration(
                                              hintText: "Task Title",
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                ref
                                                    .read(
                                                      taskControllerProvider
                                                          .notifier,
                                                    )
                                                    .removeTask(task.tid!);
                                              },
                                              child: const Text('Done'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ref
                                                    .read(
                                                      taskControllerProvider
                                                          .notifier,
                                                    )
                                                    .toggleTask(task.tid!);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (textController
                                                    .text
                                                    .isNotEmpty) {
                                                  ref
                                                      .read(
                                                        taskControllerProvider
                                                            .notifier,
                                                      )
                                                      .editTask(
                                                        task.tid!,
                                                        textController.text,
                                                      );
                                                  Navigator.of(
                                                    dialogContext,
                                                  ).pop();
                                                }
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                  ),

                  const SizedBox(height: 20),
                  if (isRecording)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Listening...',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),

                  // Center(child: MicButtonWidget()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Floatingbuttonwidget(),
    );
  }
}
