import 'package:flutter/material.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';

class SpellingWordEditorCard extends StatelessWidget {
  const SpellingWordEditorCard({
    required this.words,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<String> words;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UiDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit words',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: UiDimensions.md),
            Row(
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
                const SizedBox(width: UiDimensions.sm),
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: UiDimensions.lg),
            if (words.isEmpty)
              const Text('No words saved yet.')
            else
              ...words.map(
                (word) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(word)),
                      IconButton(
                        tooltip: 'Remove word',
                        onPressed: () => onRemove(word),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
