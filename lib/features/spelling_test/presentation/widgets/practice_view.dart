import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';
import 'package:loggy/loggy.dart';

class PracticeView extends HookConsumerWidget with UiLoggy {
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(spellingWordsProvider);

    return Column(
      spacing: UiDimensions.md,
      children: [
        const SizedBox(height: 40.0, child: const Text('Practice your words')),
        Column(
          children: state.map((word) => ListTile(title: Text(word))).toList(),
        )
      ],
    );
    return const Center(child: Text('Under Construction'));
  }
}
