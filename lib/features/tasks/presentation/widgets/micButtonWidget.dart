import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opsmate/app/theme/app_colors.dart';
import 'package:opsmate/features/tasks/provider/task_providers.dart';

class MicButtonWidget extends ConsumerStatefulWidget {
  const MicButtonWidget({super.key});

  @override
  ConsumerState<MicButtonWidget> createState() => _MicButtonWidgetState();
}

class _MicButtonWidgetState extends ConsumerState<MicButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final isRecording = ref.watch(isListeningProvider);
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColor.buttonText, AppColor.accent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(34), // Half of 68
          onTap: () async {
            final voiceService = ref.read(voiceToTextProvider);
            ref.read(isListeningProvider.notifier).state = true;

            SystemSound.play(SystemSoundType.click); //Bip on start
            final text = await voiceService.listenForText();
            ref.read(isListeningProvider.notifier).state = false;
            SystemSound.play(SystemSoundType.alert); //Bip on start

            if (text != null && text.isNotEmpty) {
              await ref.read(taskControllerProvider.notifier).addTask(text);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5), // Border width
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Icon(
                  Icons.mic,
                  size: 30,
                  color: isRecording ? Colors.red : AppColor.buttonText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
