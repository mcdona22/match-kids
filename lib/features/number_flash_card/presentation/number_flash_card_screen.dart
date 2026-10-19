import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/number_flash_card/data/number_flash_card_preferences_provider.dart';
import 'package:little_star_flashcards/features/number_flash_card/flash_card_session_controller.dart';
import 'package:little_star_flashcards/features/number_flash_card/presentation/widgets/number_answer_card.dart';
import 'package:little_star_flashcards/features/number_flash_card/presentation/widgets/number_prompt_card.dart';

class NumberFlashCardScreen extends HookConsumerWidget {
  const NumberFlashCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(flashCardSessionControllerProvider);
    final sessionController =
        ref.read(flashCardSessionControllerProvider.notifier);
    final prefs = ref.watch(numberFlashCardPreferencesControllerProvider);
    final isAnswerVisible = useState(false);
    final timerSeconds = useState(prefs.timeout);

    final correctCount = sessionState.correctAnswersInSession;
    final totalCards = sessionState.cardValues.length;
    final incorrectCount = totalCards == 0 ? 0 : totalCards - correctCount;
    final successRate =
        totalCards == 0 ? 0 : ((correctCount / totalCards) * 100).round();

    useEffect(() {
      if (!sessionController.allCardsShown) {
        timerSeconds.value = prefs.timeout;
        isAnswerVisible.value = false;
      }
      return null;
    }, [sessionState.currentIndex, prefs.timeout, sessionState.cardValues]);

    useEffect(() {
      if (sessionController.allCardsShown || isAnswerVisible.value) {
        return null;
      }

      final timer = Timer.periodic(const Duration(seconds: 1), (tick) {
        if (timerSeconds.value <= 1) {
          tick.cancel();
          isAnswerVisible.value = true;
          ref
              .read(ttsProvider)
              .speak(sessionController.currentCardValue.toString());
          return;
        }
        timerSeconds.value = timerSeconds.value - 1;
      });

      return () => timer.cancel();
    }, [
      sessionState.currentIndex,
      sessionController.allCardsShown,
      isAnswerVisible.value,
    ]);

    void revealAnswer() {
      if (sessionController.allCardsShown) return;
      isAnswerVisible.value = true;
      ref
          .read(ttsProvider)
          .speak(sessionController.currentCardValue.toString());
    }

    void recordResult(bool isCorrect) {
      if (sessionController.allCardsShown) return;
      if (isCorrect) {
        sessionController.markAnswerCorrect();
      }
      sessionController.nextCard();
      isAnswerVisible.value = false;
      timerSeconds.value = prefs.timeout;
    }

    final currentValue = sessionController.currentCardValue;
    final showPrompt = !isAnswerVisible.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eliza Number Flash Card'),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: UiDimensions.md),
        //     child: Row(
        //       spacing: UiDimensions.xs,
        //       children: [
        //         const Icon(Icons.check_circle, size: 18),
        //         Text('$correctCount'),
        //         const Icon(Icons.cancel, size: 18),
        //         Text('$incorrectCount'),
        //         const Icon(Icons.trending_up_rounded, size: 18),
        //         Text('$successRate%'),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.all(UiDimensions.lg),
              child: sessionController.allCardsShown
                  ? _CompletedSessionView(
                      correctCount: correctCount,
                      incorrectCount: incorrectCount,
                      successRate: successRate,
                      onReset: () {
                        sessionController.resetSession();
                        isAnswerVisible.value = false;
                        timerSeconds.value = prefs.timeout;
                      },
                    )
                  : showPrompt
                      ? NumberPromptCard(
                          number: currentValue,
                          timerSeconds: timerSeconds.value,
                          onKnowIt: revealAnswer,
                        )
                      : NumberAnswerCard(
                          number: currentValue,
                          correctCount: correctCount,
                          incorrectCount: incorrectCount,
                          onSpeak: (value) =>
                              ref.read(ttsProvider).speak(value.toString()),
                          onRight: () => recordResult(true),
                          onWrong: () => recordResult(false),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletedSessionView extends HookConsumerWidget {
  const _CompletedSessionView({
    required this.correctCount,
    required this.incorrectCount,
    required this.successRate,
    required this.onReset,
  });

  final int correctCount;
  final int incorrectCount;
  final int successRate;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UiDimensions.xl),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(UiDimensions.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: UiDimensions.md,
              children: [
                Text(
                  'Completed',
                  style: theme.textTheme.displayMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: UiDimensions.sm,
                  children: [
                    const Icon(Icons.check_circle, size: 24),
                    Text('Right: $correctCount',
                        style: theme.textTheme.titleLarge),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: UiDimensions.sm,
                  children: [
                    const Icon(Icons.cancel, size: 24),
                    Text('Wrong: $incorrectCount',
                        style: theme.textTheme.titleLarge),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: UiDimensions.sm,
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 24),
                    Text('Success rate: $successRate%',
                        style: theme.textTheme.titleLarge),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
