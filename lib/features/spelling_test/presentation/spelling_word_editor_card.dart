import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/presentation/card_wrapper.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';

class SpellingWordEditorCard extends HookConsumerWidget {
  const SpellingWordEditorCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileView =
        MediaQuery.sizeOf(context).width <= UiDimensions.mobileWidth;

    final words = ref.watch(spellingWordsProvider).words;
    final textTheme = Theme.of(context).textTheme;
    final controller = useTextEditingController();

    return CardWrapper(
      child: Column(
        spacing: UiDimensions.lg,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit words',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (mobileView)
            Column(spacing: UiDimensions.lg, children: [
              _WordTextInput(controller: controller),
              _WordInputControls(controller: controller),
            ])
          else
            Row(
              spacing: UiDimensions.md,
              children: [
                Expanded(
                  child: _WordTextInput(controller: controller),
                ),
                _WordInputControls(controller: controller),
              ],
            ),
          if (words.isEmpty)
            const Text('No words saved yet.')
          else
            Wrap(
              spacing: UiDimensions.md,
              children: words
                  .map(
                    (word) => InputChip(
                      label: Text(word, style: textTheme.headlineSmall),
                      deleteIcon: Icon(Icons.close_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 24.0),
                      onDeleted: () => ref
                          .read(spellingWordsProvider.notifier)
                          .removeWord(word),
                    ),
                  )
                  .toList(),

              // Text(word)).toList(),
            ),
        ],
      ),
    );
  }
}

class _WordTextInput extends StatelessWidget {
  const _WordTextInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.none,
      decoration: const InputDecoration(
        hintText: 'Add a new word',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _WordInputControls extends HookConsumerWidget {
  const _WordInputControls({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: UiDimensions.inlineGap,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledButton.icon(
          onPressed: () {
            ref.read(spellingWordsProvider.notifier).addWord(controller.text);
            controller.text = '';
          },
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
        ElevatedButton(
            onPressed: ref.read(spellingWordsProvider.notifier).resetSession,
            child: const Text('Clear All'))
      ],
    );
  }
}
