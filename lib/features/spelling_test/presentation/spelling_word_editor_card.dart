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
          Row(
            spacing: UiDimensions.md,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
                    hintText: 'Add a new word',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  ref
                      .read(spellingWordsProvider.notifier)
                      .addWord(controller.text);
                  controller.text = '';
                },
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
              ElevatedButton(
                  onPressed:
                      ref.read(spellingWordsProvider.notifier).resetSession,
                  child: const Text('Clear All'))
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
