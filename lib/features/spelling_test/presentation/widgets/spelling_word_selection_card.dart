import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';

class SpellingWordSelectionCard extends HookConsumerWidget {
  const SpellingWordSelectionCard({
    // required this.hideWords,
    // required this.isEditing,
    // required this.onToggleSelection,
    required this.onToggleEditor,
    super.key,
  });

  // final bool hideWords;
  // final bool isEditing;
  // final ValueChanged<String> onToggleSelection;
  final VoidCallback onToggleEditor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsState = ref.watch(spellingWordsProvider);
    final notifier = ref.watch(spellingWordsProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    final isEditing = useState<bool>(false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UiDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Words to practice',
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: UiDimensions.md),
            //   Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(UiDimensions.md),
            //     decoration: BoxDecoration(
            //       color: colorScheme.surfaceContainerHighest,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Text(
            //       'Words are hidden during the test. Use “Show words” to review the list.',
            //       style: textTheme.bodyMedium,
            //     ),
            //   )
            // else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: wordsState.words
                  .map(
                    (word) => FilterChip(
                      selected: notifier.isSelected(word),
                      label: Text(
                        word,
                        style: textTheme.titleMedium,
                      ),
                      onSelected: (_) => notifier.toggleSelectionStatus(word),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: UiDimensions.md),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onToggleEditor,
                icon: Icon(
                  isEditing.value
                      ? Icons.expand_less
                      : Icons.edit_note_outlined,
                ),
                label: Text(
                  isEditing.value ? 'Hide list editor' : 'Edit word list',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
