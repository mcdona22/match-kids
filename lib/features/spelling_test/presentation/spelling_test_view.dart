import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/core/presentation/card_wrapper.dart';
import 'package:little_star_flashcards/core/presentation/screen_subheading.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';
import 'package:loggy/loggy.dart';

class SpellingTestView extends HookConsumerWidget with UiLoggy {
  const SpellingTestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    const buttonWidth = 200.0;
    const buttonHeight = 75.0;
    const iconSize = 45.0;
    final selectedWords = ref.watch(spellingWordsProvider).selectedWords;
    final currentCardIndex = useState<int>(0);
    final ttsService = ref.watch(ttsProvider);

    return CardWrapper(
        child: Column(
      spacing: UiDimensions.md,
      children: [
        const ScreenSubheading(subtitle: 'Running Test'),
        Text(
          'Word ${currentCardIndex.value + 1} of ${selectedWords.length}',
          style: textTheme.titleMedium,
        ),
        LinearProgressIndicator(
          value: (currentCardIndex.value + 1) / selectedWords.length,
          minHeight: 30.0,
        ),
        const SizedBox(height: UiDimensions.largeGap),
        Row(
          spacing: UiDimensions.inlineGap,
          children: [
            SizedBox(
              width: buttonWidth,
              child: IconButton(
                  icon: const Icon(
                    Icons.fast_rewind,
                    size: iconSize,
                  ),
                  onPressed: currentCardIndex.value == 0
                      ? null
                      : () {
                          currentCardIndex.value = currentCardIndex.value - 1;
                          ttsService
                              .speak(selectedWords[currentCardIndex.value]);
                        }),
            ),
            Expanded(
                child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () =>
                    ttsService.speak(selectedWords[currentCardIndex.value]),
                style: buttonStyle(context),
                child: Text('Speak Word ${currentCardIndex.value + 1}'),
              ),
            )),
            SizedBox(
              width: buttonWidth,
              child: IconButton(
                icon: const Icon(
                  Icons.fast_forward,
                  size: iconSize,
                ),
                onPressed: currentCardIndex.value == selectedWords.length - 1
                    ? null
                    : () {
                        currentCardIndex.value = currentCardIndex.value + 1;
                        ttsService.speak(selectedWords[currentCardIndex.value]);
                      },
              ),
            ),
          ],
        ),
        const Text('Lets test'),
      ],
    ));
  }

  ButtonStyle buttonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      textStyle: theme.textTheme.displayMedium!
          .copyWith(fontWeight: const FontWeight(700)),
    );
  }
}
