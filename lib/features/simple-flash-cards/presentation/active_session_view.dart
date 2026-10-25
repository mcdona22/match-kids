import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/flash_card.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/flash_cards_screen.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/flash_screen_controller.dart';
import 'package:loggy/loggy.dart';

class ActiveSessionView extends HookConsumerWidget with UiLoggy {
  const ActiveSessionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashScreenControllerProvider);
    final tts = ref.read(ttsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UiDimensions.xlGap),
      child: Column(
        spacing: UiDimensions.xlGap,
        children: [
          Expanded(
              child: Center(
                  child: FlashCard(
                      value: state.cardDeck[state.currentCardIndex]))),
          LinearProgressIndicator(
            value: (state.currentCardIndex + 1) / state.cardCount,
          ),
          const FlashCardActiveSessionControls()
        ],
      ),
    );
  }
}
