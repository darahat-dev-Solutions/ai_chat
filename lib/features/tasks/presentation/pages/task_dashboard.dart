import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/auth/application/auth_state.dart';
import 'package:flutter_starter_kit/features/auth/provider/auth_providers.dart';
import 'package:flutter_starter_kit/features/tasks/presentation/widgets/ai_summary_widget.dart';
import 'package:flutter_starter_kit/features/tasks/presentation/widgets/floating_button_widget.dart';
import 'package:flutter_starter_kit/features/tasks/presentation/widgets/show_update_delete_task_dialog.dart';
import 'package:flutter_starter_kit/features/tasks/provider/task_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Main Task dashboard
class TaskDashboard extends ConsumerWidget {
  /// Main Task Dashboard constructor
  const TaskDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskControllerProvider);
    final isRecording = ref.watch(isListeningProvider);
    String formattedDate = '';
    ref.listen<AuthState>(authControllerProvider, (prev, next) {
      if (next is AuthSignedOut) {
        context.go('/login');
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ref.read(authControllerProvider.notifier).signOut();
          },
          icon: const Icon(Icons.logout),
        ),
        title: const Text('FlutterStarterKit'),
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
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(width: 10),

                        Text(
                          DateFormat('MMMM d, yyyy').format(DateTime.now()),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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
                            ref
                                .watch(taskControllerProvider.notifier)
                                .loadTasks(),
                    child: tasksAsync.when(
                      data: (tasks) {
                        if (tasks.isEmpty) {
                          return const Center(child: Text('No Tasks yet'));
                        }
                        return ListView.builder(
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
                                showUpdateDeleteTaskDialog(context, ref, task);
                              },
                            );
                          },
                        );
                      },
                      error: (err, stack) => Center(child: Text('Error: $err')),
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                    ),
                  ),

                  const SizedBox(height: 20),
                  if (isRecording)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fiber_manual_record,
                            color: Theme.of(context).colorScheme.error,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Listening...',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
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
      floatingActionButton: FloatingButtonWidget(),
    );
  }
}
