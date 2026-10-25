import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/flash_card_state.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/flash_screen_controller.dart';
import 'package:loggy/loggy.dart';

class SessionSummary extends HookConsumerWidget with UiLoggy {
  const SessionSummary({required this.state, super.key});

  final FlashCardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: UiDimensions.largeGap,
      children: [
        Text('Stack count: ${state.cardCount}'),
        Text('Max Number: ${state.highestInt}'),
        Row(
          spacing: UiDimensions.largeGap,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton.icon(
                onPressed:
                    ref.read(flashScreenControllerProvider.notifier).startTest,
                label: const Text('Start Test')),
            FilledButton.icon(onPressed: () {}, label: Text('Edit Details'))
          ],
        )
      ],
    );
  }
}
