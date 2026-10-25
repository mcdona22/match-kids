import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/presentation/hero_with_graphic_view.dart';
import 'package:little_star_flashcards/core/ui/screen_names.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_test_view.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_word_editor_card.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_words_provider.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/widgets/spelling_word_selection_card.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/words_to_practice.dart';
import 'package:loggy/loggy.dart';

class SpellingTestBody extends HookConsumerWidget with UiLoggy {
  const SpellingTestBody({
    required this.hideWords,
    required this.isEditing,
    required this.onToggleEditor,
    super.key,
  });

  final bool hideWords;
  final bool isEditing;

  final VoidCallback onToggleEditor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(spellingWordsProvider);
    final sessionNotifier = ref.read(spellingWordsProvider.notifier);
    final showGraphic =
        MediaQuery.sizeOf(context).height >= UiDimensions.smallHeight;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(UiDimensions.cardPadding),
        children: [
          HeroWithGraphicView(
            showGraphic: showGraphic,
            graphicPath: 'assets/images/numbers.jpg',
            heroTag: '$spellingScreenTitle-hero',
          ),

          if (!session.testMode)
            SpellingWordSelectionCard(
              onToggleEditor: onToggleEditor,
            ),
          if (isEditing && !session.testMode) ...[
            const SizedBox(height: UiDimensions.lg),
            const SpellingWordEditorCard(),
          ],
          const SizedBox(height: UiDimensions.lg),
          SizedBox(
            width: 130.0,
            child: Row(
              children: [
                if (!session.testMode)
                  FilledButton(
                      onPressed: session.selectedWords.isNotEmpty
                          ? () => sessionNotifier.testMode = true
                          : null,
                      child: const Text('Start Test')),
                if (session.testMode)
                  FilledButton(
                      onPressed: () => sessionNotifier.testMode = false,
                      child: const Text('Finished')),
              ],
            ),
          ),

          if (!session.testMode) const WordsToPractice(),
          const SizedBox(height: UiDimensions.lg),
          if (session.testMode) const SpellingTestView(),
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
