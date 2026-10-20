import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_test_body.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';
import 'package:loggy/loggy.dart';

class SpellingTestScreen extends HookConsumerWidget with UiLoggy {
  const SpellingTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(spellingWordsProvider).words;
    final newWordController = useTextEditingController();
    final selectedSessionWords = useState<Set<String>>({});
    final isEditingWords = useState(false);
    final hideWords = useState(false);
    final reviewMode = useState(false);
    final currentWordIndex = useState(0);

    final sessionWords = ref.watch(spellingWordsProvider).words;
    loggy.debug('build: session words: $sessionWords');

    useEffect(() {
      if (selectedSessionWords.value.isEmpty && words.isNotEmpty) {
        selectedSessionWords.value = words.toSet();
      }

      final validSelection = selectedSessionWords.value
          .where((word) => words.contains(word))
          .toSet();
      if (validSelection.length != selectedSessionWords.value.length) {
        selectedSessionWords.value = validSelection;
      }

      if (selectedSessionWords.value.isEmpty && words.isNotEmpty) {
        selectedSessionWords.value = words.toSet();
      }
      return null;
    }, [words]);

    if (sessionWords.isNotEmpty &&
        currentWordIndex.value >= sessionWords.length) {
      currentWordIndex.value = sessionWords.length - 1;
    }

    final currentWord =
        sessionWords.isEmpty ? null : sessionWords[currentWordIndex.value];
    final displayedWord =
        reviewMode.value || hideWords.value ? null : currentWord;

    void toggleWordSelection(String word) {
      final nextSelection = {...selectedSessionWords.value};
      if (nextSelection.contains(word)) {
        nextSelection.remove(word);
      } else {
        nextSelection.add(word);
      }
      selectedSessionWords.value = nextSelection;
      if (!reviewMode.value && nextSelection.isEmpty) {
        currentWordIndex.value = 0;
      }
      final nextSessionWords =
          words.where((value) => nextSelection.contains(value)).toList();
      if (currentWordIndex.value >= nextSessionWords.length) {
        currentWordIndex.value =
            nextSessionWords.isEmpty ? 0 : nextSessionWords.length - 1;
      }
    }

    void addWord() {
      final text = newWordController.text.trim();
      if (text.isEmpty) {
        return;
      }
      final updatedWords = [...words, text];
      ref.read(spellingWordsProvider.notifier).saveWords(updatedWords);
      newWordController.clear();
      selectedSessionWords.value = {...selectedSessionWords.value, text};
      currentWordIndex.value = 0;
      reviewMode.value = false;
    }

    void removeWord(String word) {
      final updatedWords = words.where((value) => value != word).toList();
      ref.read(spellingWordsProvider.notifier).saveWords(updatedWords);
      final nextSelection = {...selectedSessionWords.value};
      nextSelection.remove(word);
      selectedSessionWords.value = nextSelection;
      final nextSessionWords =
          updatedWords.where((value) => nextSelection.contains(value)).toList();
      if (currentWordIndex.value >= nextSessionWords.length) {
        currentWordIndex.value =
            nextSessionWords.isEmpty ? 0 : nextSessionWords.length - 1;
      }
      reviewMode.value = false;
    }

    Future<void> readCurrentWord() async {
      if (currentWord == null) {
        return;
      }
      await ref.read(ttsProvider).speak(currentWord);
    }

    void handleNextWord() {
      if (sessionWords.isEmpty) {
        return;
      }
      if (reviewMode.value) {
        reviewMode.value = false;
        currentWordIndex.value = 0;
        return;
      }
      if (currentWordIndex.value >= sessionWords.length - 1) {
        reviewMode.value = true;
        return;
      }
      currentWordIndex.value += 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Spelling Test')),
      body: SpellingTestBody(
        words: words,
        selectedWords: selectedSessionWords.value,
        hideWords: hideWords.value,
        isEditing: isEditingWords.value,
        reviewMode: reviewMode.value,
        sessionWords: sessionWords,
        displayedWord: displayedWord,
        newWordController: newWordController,
        onToggleSelection: toggleWordSelection,
        onToggleEditor: () => isEditingWords.value = !isEditingWords.value,
        onAdd: addWord,
        onRemove: removeWord,
        onToggleHide: () => hideWords.value = !hideWords.value,
        onRead: readCurrentWord,
        onNext: handleNextWord,
        onPracticeAgain: () {
          reviewMode.value = false;
          currentWordIndex.value = 0;
        },
      ),
    );
  }
}
