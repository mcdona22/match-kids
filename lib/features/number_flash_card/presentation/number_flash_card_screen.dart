import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/features/number_flash_card/data/number_flash_card_preferences_provider.dart';
import 'package:little_star_flashcards/features/number_flash_card/flash_card_session_controller.dart';
import 'package:little_star_flashcards/features/number_flash_card/presentation/widgets/number_answer_card.dart';
import 'package:little_star_flashcards/features/number_flash_card/presentation/widgets/number_prompt_card.dart';

class NumberFlashCardScreen extends HookConsumerWidget {
  const NumberFlashCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(flashCardSessionControllerProvider);
    final sessionController = ref.read(flashCardSessionControllerProvider.notifier);
    final prefs = ref.watch(numberFlashCardPreferencesControllerProvider);
    final isAnswerVisible = useState(false);
    final timerSeconds = useState(prefs.timeout);

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
          ref.read(ttsProvider).speak(sessionController.currentCardValue.toString());
          return;
        }
        timerSeconds.value = timerSeconds.value - 1;
      });

      return () => timer.cancel();
    }, [sessionState.currentIndex, sessionController.allCardsShown, isAnswerVisible.value]);

    void revealAnswer() {
      if (sessionController.allCardsShown) return;
      isAnswerVisible.value = true;
      ref.read(ttsProvider).speak(sessionController.currentCardValue.toString());
    }

    void recordResult(bool isCorrect) {
      if (sessionController.allCardsShown) return;

      ref
          .read(numberFlashCardPreferencesControllerProvider.notifier)
          .recordResult(isCorrect: isCorrect);

      sessionController.nextCard();
      isAnswerVisible.value = false;
      timerSeconds.value = prefs.timeout;
    }

    if (sessionController.allCardsShown) {
      return _CompletedSessionView(
        correctCount: prefs.correct,
        incorrectCount: prefs.incorrect,
        onReset: () {
          sessionController.resetSession();
          isAnswerVisible.value = false;
          timerSeconds.value = prefs.timeout;
        },
      );
    }

    final currentValue = sessionController.currentCardValue;
    final showPrompt = !isAnswerVisible.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Flash Card'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 18),
                const SizedBox(width: 4),
                Text('${prefs.correct}'),
                const SizedBox(width: 12),
                const Icon(Icons.cancel, size: 18),
                const SizedBox(width: 4),
                Text('${prefs.incorrect}'),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: showPrompt
                  ? NumberPromptCard(
                      number: currentValue,
                      timerSeconds: timerSeconds.value,
                      onKnowIt: revealAnswer,
                    )
                  : NumberAnswerCard(
                      number: currentValue,
                      correctCount: prefs.correct,
                      incorrectCount: prefs.incorrect,
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

class _CompletedSessionView extends StatelessWidget {
  const _CompletedSessionView({
    required this.correctCount,
    required this.incorrectCount,
    required this.onReset,
  });

  final int correctCount;
  final int incorrectCount;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Session Complete')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Completed',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, size: 24),
                        const SizedBox(width: 8),
                        Text('Right: $correctCount',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cancel, size: 24),
                        const SizedBox(width: 8),
                        Text('Wrong: $incorrectCount',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: onReset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
