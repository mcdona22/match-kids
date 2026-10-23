import 'dart:math' as math;

import 'package:little_star_flashcards/features/number_flash_card/domain/flash_card_session.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flash_card_session_controller.g.dart';

@riverpod
class FlashCardSessionController extends _$FlashCardSessionController
    with UiLoggy {
  @override
  FlashCardSession build() {
    return _newSession();
  }

  bool get allCardsShown => state.currentIndex >= state.cardValues.length;

  int get currentCardValue {
    if (allCardsShown) {
      return state.cardValues.isEmpty ? 0 : state.cardValues.last;
    }
    return state.cardValues[state.currentIndex];
  }

  void markAnswerCorrect() => state = state.copyWith(
      correctAnswersInSession: state.correctAnswersInSession + 1);

  void nextCard() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.cardValues.length) {
      state = state.copyWith(currentIndex: state.cardValues.length);
      return;
    }

    state = state.copyWith(currentIndex: nextIndex);
  }

  void resetSession() {
    state = _newSession();
  }

  FlashCardSession _newSession() {
    final session =
        FlashCardSession(cardValues: _generateRandomNumbers(), currentIndex: 0);
    loggy.debug('session: $session');
    return session;
  }

  List<int> _generateRandomNumbers({count = 10, maxCardValue = 6}) {
    final random = math.Random();

    // Calculate how many numbers belong to the upper 30% tier challenge range
    final upperCount = (count * 0.30).round();
    final baseCount = count - upperCount;

    // Define upper tier range start (e.g., top 25% or within upper bounds)
    final upperTierStart =
        math.max<int>(1, maxCardValue - (maxCardValue * 0.25).round());

    final basePool = List.generate(
      math.max<int>(1, upperTierStart - 1),
      (i) => i + 1,
    );

    final upperPool = List.generate(
      math.max<int>(1, maxCardValue - upperTierStart + 1),
      (i) => upperTierStart + i,
    );

    final List<int> generatedNumbers = [];

    // Draw base numbers (70%)
    for (int i = 0; i < baseCount; i++) {
      final num = basePool.isNotEmpty
          ? basePool[random.nextInt(basePool.length)]
          : maxCardValue;
      generatedNumbers.add(num);
    }

    // Draw upper challenge numbers (30%)
    for (int i = 0; i < upperCount; i++) {
      final num = upperPool.isNotEmpty
          ? upperPool[random.nextInt(upperPool.length)]
          : maxCardValue;
      generatedNumbers.add(num);
    }

    // Shuffle the final sequence so the upper/base cards are mixed randomly
    generatedNumbers.shuffle(random);

    return generatedNumbers;
  }
}
