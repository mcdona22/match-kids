import 'package:flutter/material.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_test_view.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_word_editor_card.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/widgets/spelling_word_selection_card.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/words_to_practice.dart';

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
            const SpellingWordEditorCard(),
          ],
          const SizedBox(height: UiDimensions.lg),

          const WordsToPractice(),
          const SizedBox(height: UiDimensions.lg),
          const SpellingTestView(),
          // const PracticeView(),
          // SpellingPracticeCard(
          //   sessionWords: sessionWords,
          //   hideWords: hideWords,
          //   reviewMode: reviewMode,
          //   displayedWord: displayedWord,
          //   onToggleHide: onToggleHide,
          //   onRead: onRead,
          //   onNext: onNext,
          //   onPracticeAgain: onPracticeAgain,
          // ),
        ],
      ),
    );
  }
}
