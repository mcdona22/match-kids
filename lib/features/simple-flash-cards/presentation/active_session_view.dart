import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final cardValue = state.cardDeck[state.currentCardIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UiDimensions.xlGap),
      child: Column(
        spacing: UiDimensions.xlGap,
        children: [
          Expanded(
            child: Center(
              child: FlashCard(value: cardValue),
            ),
          ),
          LinearProgressIndicator(
            value: (state.currentCardIndex + 1) / state.cardCount,
          ),
          NumberDots(
            value: cardValue,
            key: ValueKey(state.currentCardIndex),
          ),
          const FlashCardActiveSessionControls()
        ],
      ),
    );
  }
}

class NumberDots extends HookConsumerWidget with UiLoggy {
  const NumberDots({required this.value, this.initialHelp = false, super.key});

  final int value;
  final bool initialHelp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final showHelp = useState(initialHelp);

    return SizedBox(
      width: 250.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: UiDimensions.sectionGap,
        children: [
          OutlinedButton.icon(
              onPressed: () => showHelp.value = !showHelp.value,
              label: Text(showHelp.value ? 'Hide Help' : 'Show Help'),
              icon: const Icon(Icons.help_outline)),
          GridView.builder(
            shrinkWrap: true,
            itemCount: 10,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              child: index < value
                  ? showHelp.value
                      ? Container(
                          color: theme.colorScheme.primaryFixed,
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: theme.textTheme.headlineSmall!.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                  : const SizedBox.shrink(),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1,
            ),
          ),
        ],
      ),
    );
  }
}
