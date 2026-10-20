import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';
import 'package:loggy/loggy.dart';

class PracticeView extends HookConsumerWidget with UiLoggy {
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final words = ref.watch(spellingWordsProvider).words;

    return Column(
      spacing: UiDimensions.md,
      children: [
        Text('Chosen Words',
            textAlign: TextAlign.start,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Column(
          spacing: UiDimensions.md,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(words.length, (i) {
            return SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 30.0),
                  child: Text(
                    words[i],
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge?.copyWith(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
            ;
          }),
        )
      ],
    );
  }
}
