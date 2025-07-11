import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/tasks/provider/task_providers.dart';

/// AISummaryWidget is for showing AI provided summary
class AISummaryWidget extends ConsumerWidget {
  ///const AISummaryWidget to call AISummaryWidget from other
  const AISummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(incompleteTasksProvider);
    final isExpandedAiSummary = ref.watch(isExpandedSummaryProvider);
    final summaryAsync = ref.watch(aiSummaryProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AI-Generated Summary",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          if (!tasks.hasValue)
            const Text("No tasks available to summarize.")
          else
            summaryAsync.when(
              data: (summary) {
                final showToggle = summary.length > 200;
                final displayText =
                    isExpandedAiSummary
                        ? summary
                        : '${summary.substring(0, 200)}...';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayText),

                    if (showToggle)
                      TextButton(
                        onPressed: () {
                          ref.read(isExpandedSummaryProvider.notifier).state =
                              !isExpandedAiSummary;
                        },
                        child: Text(
                          isExpandedAiSummary ? "See Less" : "See More",
                        ),
                      ),
                  ],
                );
              },
              loading:
                  () => const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("Generating summary..."),
                  ),
              error:
                  (e, _) => const Text(
                    "Unable to generate summary. Please try again.",
                  ),
            ),
        ],
      ),
    );
  }
}
