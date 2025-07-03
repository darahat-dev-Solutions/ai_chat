import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/features/tasks/presentation/widgets/micButtonWidget.dart';
import 'package:opsmate/features/tasks/presentation/widgets/showAddTaskDialog.dart';

class Floatingbuttonwidget extends ConsumerStatefulWidget {
  const Floatingbuttonwidget({super.key});

  @override
  ConsumerState<Floatingbuttonwidget> createState() =>
      _FloatingbuttonwidgetState();
}

class _FloatingbuttonwidgetState extends ConsumerState<Floatingbuttonwidget> {
  bool isFabExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Dismiss overlay when expanded
        if (isFabExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => isFabExpanded = false),
              child: Container(
                color: Colors.black.withOpacity(
                  0.2,
                ), // semi-transparent background
              ),
            ),
          ),

        // Mic FAB (Animated Scale & Position)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: isFabExpanded ? 140 : 80,
          right: 20,
          child: AnimatedScale(
            scale: isFabExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: MicButtonWidget(),
          ),
        ),

        // New Task FAB
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: isFabExpanded ? 80 : 80,
          right: isFabExpanded ? 80 : 20,
          child: AnimatedScale(
            scale: isFabExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: FloatingActionButton(
              heroTag: 'addTask',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                setState(() => isFabExpanded = false);
                showAddTaskDialog(context, ref);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),

        // Main FAB
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: 'mainFab',
            onPressed: () {
              setState(() {
                isFabExpanded = !isFabExpanded;
              });
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: AnimatedRotation(
              turns: isFabExpanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.menu),
            ),
          ),
        ),
      ],
    );
  }
}
