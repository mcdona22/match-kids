import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/core/ui/screen_names.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/spelling_words_provider.dart';

class SpellingTestScreen extends HookConsumerWidget {
  const SpellingTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(spellingWordsProvider);
    final selectedWords = useState<Set<String>>(
      words.isEmpty ? <String>{} : words.toSet(),
    );
    final hideWords = useState(false);
    final currentIndex = useState(0);
    final reviewMode = useState(false);
    final textController = useTextEditingController();

    final sessionWords = words
        .where((word) => selectedWords.value.contains(word))
        .toList(growable: false);

    final currentWord = sessionWords.isEmpty
        ? null
        : sessionWords[currentIndex.value % sessionWords.length];

    void updateSelection(String word) {
      final next = {...selectedWords.value};
      if (next.contains(word)) {
        next.remove(word);
      } else {
        next.add(word);
      }
      selectedWords.value = next;
      if (next.isEmpty) {
        currentIndex.value = 0;
        reviewMode.value = false;
      } else if (currentIndex.value >= next.length) {
        currentIndex.value = 0;
      }
    }

    void handleRead() {
      if (currentWord == null) return;
      ref.read(ttsProvider).speak(currentWord);
    }

    void handleNext() {
      if (sessionWords.isEmpty) return;
      if (currentIndex.value >= sessionWords.length - 1) {
        reviewMode.value = true;
        return;
      }
      currentIndex.value += 1;
    }

    void addWord() {
      final candidate = textController.text.trim();
      if (candidate.isEmpty) return;
      final nextList = [...words, candidate];
      ref.read(spellingWordsProvider.notifier).saveWords(nextList);
      selectedWords.value = {...selectedWords.value, candidate};
      textController.clear();
      currentIndex.value = 0;
      reviewMode.value = false;
    }

    void clearWords() {
      if (words.isEmpty) return;
      ref.read(spellingWordsProvider.notifier).saveWords([]);
      selectedWords.value = <String>{};
      reviewMode.value = false;
      currentIndex.value = 0;
    }

    return Scaffold(
      appBar: AppBar(title: const Text(spellingScreenTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UiDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WordEditorCard(
                controller: textController,
                onAdd: addWord,
                onClear: clearWords,
                canClear: words.isNotEmpty,
              ),
              const SizedBox(height: UiDimensions.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Words to practice',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => hideWords.value = !hideWords.value,
                    child: Text(hideWords.value ? 'Show words' : 'Hide words'),
                  ),
                ],
              ),
              const SizedBox(height: UiDimensions.sm),
              if (!hideWords.value)
                Wrap(
                  spacing: UiDimensions.xs,
                  runSpacing: UiDimensions.xs,
                  children: words.map((word) {
                    final isSelected = selectedWords.value.contains(word);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(word),
                      onSelected: (_) => updateSelection(word),
                    );
                  }).toList(),
                ),
              const SizedBox(height: UiDimensions.xl),
              if (sessionWords.isNotEmpty && !reviewMode.value)
                _PracticeCard(
                  currentWord: currentWord ?? '',
                  onRead: handleRead,
                  onNext: handleNext,
                  wordsHidden: hideWords.value,
                )
              else if (reviewMode.value)
                _ReviewWordsCard(words: sessionWords),
              if (sessionWords.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(UiDimensions.md),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      const Text('Select at least one word to start practice.'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordEditorCard extends StatelessWidget {
  const _WordEditorCard({
    required this.controller,
    required this.onAdd,
    required this.onClear,
    required this.canClear,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;
  final VoidCallback onClear;
  final bool canClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UiDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Word list editor', style: theme.textTheme.titleMedium),
            const SizedBox(height: UiDimensions.sm),
            TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Add a spelling word',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => onAdd(),
            ),
            const SizedBox(height: UiDimensions.sm),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add word'),
                ),
                const SizedBox(width: UiDimensions.sm),
                FilledButton.tonalIcon(
                  onPressed: canClear ? onClear : null,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear list'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({
    required this.currentWord,
    required this.onRead,
    required this.onNext,
    required this.wordsHidden,
  });

  final String currentWord;
  final VoidCallback onRead;
  final VoidCallback onNext;
  final bool wordsHidden;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UiDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wordsHidden ? 'Current word is hidden' : 'Current word',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: UiDimensions.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(UiDimensions.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  wordsHidden ? '•••••' : currentWord,
                  style: theme.textTheme.displaySmall,
                ),
              ),
            ),
            const SizedBox(height: UiDimensions.lg),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onRead,
                    icon: const Icon(Icons.volume_up_outlined),
                    label: const Text('Read'),
                  ),
                ),
                const SizedBox(width: UiDimensions.sm),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onNext,
                    icon: const Icon(Icons.skip_next_outlined),
                    label: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewWordsCard extends StatelessWidget {
  const _ReviewWordsCard({required this.words});

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UiDimensions.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Check your spelling',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: UiDimensions.sm),
            Wrap(
              spacing: UiDimensions.xs,
              runSpacing: UiDimensions.xs,
              children: words
                  .map(
                    (word) => Chip(
                        label: Text(word,
                            style: Theme.of(context).textTheme.titleMedium)),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
