import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/hard_coded.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/flash_screen_controller.dart';
import 'package:loggy/loggy.dart';

class FlashCard extends HookConsumerWidget with UiLoggy {
  static const size = 300.0;

  const FlashCard({required this.value, super.key});

  final int value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentIndex =
        ref.watch(flashScreenControllerProvider).currentCardIndex;
    final tts = ref.read(ttsProvider);
    return TweenAnimationBuilder(
      key: ValueKey(currentIndex),
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: Duration(milliseconds: 350.hardCoded),
      builder: (_, scale, child) => Transform.scale(
        scale: scale,
        child: child,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size, maxHeight: size),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: ClipOval(
            child: Material(
              color: theme.colorScheme.primary,
              child: InkWell(
                onTap: () => tts.speak(value.toString()),
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
        ),
      ),
    );
  }
}
