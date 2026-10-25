import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:loggy/loggy.dart';

class FlashCard extends HookConsumerWidget with UiLoggy {
  static const size = 300.0;

  const FlashCard({required this.value, super.key});

  final int value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tts = ref.read(ttsProvider);
    return ClipOval(
      child: Material(
        color: theme.colorScheme.primary,
        child: InkWell(
          onTap: () => tts.speak(value.toString()),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Text(
                '$value',
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 132,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
