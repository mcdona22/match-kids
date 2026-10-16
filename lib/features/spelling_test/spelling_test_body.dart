import 'package:flutter/material.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/widgets/spelling_practice_card.dart';
import 'package:little_star_flashcards/features/spelling_test/widgets/spelling_word_editor_card.dart';
import 'package:little_star_flashcards/features/spelling_test/widgets/spelling_word_selection_card.dart';

class SpellingTestBody extends StatelessWidget {
  const SpellingTestBody({
    required this.words,
    required this.selectedWords,
    required this.hideWords,
    required this.isEditing,
    required this.reviewMode,
    required this.sessionWords,
    required this.displayedWord,
    required this.newWordController,
    required this.onToggleSelection,
    required this.onToggleEditor,
    required this.onAdd,
    required this.onRemove,
    required this.onToggleHide,
    required this.onRead,
    required this.onNext,
    required this.onPracticeAgain,
    super.key,
  });

  final List<String> words;
  final Set<String> selectedWords;
  final bool hideWords;
  final bool isEditing;
  final bool reviewMode;
  final List<String> sessionWords;
  final String? displayedWord;
  final TextEditingController newWordController;
  final ValueChanged<String> onToggleSelection;
  final VoidCallback onToggleEditor;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;
  final VoidCallback onToggleHide;
  final VoidCallback onRead;
  final VoidCallback onNext;
  final VoidCallback onPracticeAgain;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(UiDimensions.cardPadding),
        children: [
          SpellingWordSelectionCard(
            words: words,
            selectedWords: selectedWords,
            hideWords: hideWords,
            isEditing: isEditing,
            onToggleSelection: onToggleSelection,
            onToggleEditor: onToggleEditor,
          ),
          if (isEditing) ...[
            const SizedBox(height: UiDimensions.lg),
            SpellingWordEditorCard(
              words: words,
              controller: newWordController,
              onAdd: onAdd,
              onRemove: onRemove,
            ),
          ],
          const SizedBox(height: UiDimensions.lg),
          SpellingPracticeCard(
            sessionWords: sessionWords,
            hideWords: hideWords,
            reviewMode: reviewMode,
            displayedWord: displayedWord,
            onToggleHide: onToggleHide,
            onRead: onRead,
            onNext: onNext,
            onPracticeAgain: onPracticeAgain,
          ),
        ],
      ),
    );
  }
}
