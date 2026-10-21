import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/core/presentation/screen_subheading.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';
import 'package:loggy/loggy.dart';

class WordsToPractice extends HookConsumerWidget with UiLoggy {
  const WordsToPractice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spellingSession = ref.watch(spellingWordsProvider);
    final selectedWords = spellingSession.selectedWords;
    return Column(
      spacing: UiDimensions.lg,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScreenSubheading(subtitle: 'Selected Words'),
        if (selectedWords.isEmpty)
          Text(
            'No words selected for practice',
            style: Theme.of(context).textTheme.titleLarge,
          )
        else
          ...List.generate(
            selectedWords.length,
            (i) => SelectedWordView(word: selectedWords[i], isEven: i % 2 == 0),
          )
      ],
    );
  }
}

class SelectedWordView extends HookConsumerWidget with UiLoggy {
  const SelectedWordView({required this.word, this.isEven = true, super.key});

  final String word;
  final bool isEven;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loggy.debug('Even is $isEven');
    final theme = Theme.of(context);
    final backgroundColor = isEven
        ? theme.colorScheme.primaryFixedDim
        : theme.colorScheme.primaryContainer;
    final foregroundColor = isEven
        ? theme.colorScheme.onPrimaryFixed
        : theme.colorScheme.onPrimaryContainer;

    loggy.debug('Even is $isEven');
    loggy.debug('colourL $backgroundColor');

    return InkWell(
      onTap: () => ref.read(ttsProvider).speak(word),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(UiDimensions.md)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            word,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium!.copyWith(
                color: foregroundColor,
                letterSpacing: 2.0,
                fontWeight: const FontWeight(700)),
          ),
        ),
      ),
    );
  }
}
