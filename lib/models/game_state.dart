import 'package:flutter/foundation.dart';
import 'flash_card.dart';

@immutable
class GameState {
  final List<FlashCardItem> cardStack;
  final int currentIndex;
  final bool isShowingDots;
  final Set<int> countedDots;
  final int totalStars;
  final int stacksCompleted;

  const GameState({
    this.cardStack = const [],
    this.currentIndex = 0,
    this.isShowingDots = false,
    this.countedDots = const {},
    this.totalStars = 0,
    this.stacksCompleted = 0,
  });

  FlashCardItem? get currentCard {
    if (cardStack.isNotEmpty && currentIndex < cardStack.length) {
      return cardStack[currentIndex];
    }
    return null;
  }

  GameState copyWith({
    List<FlashCardItem>? cardStack,
    int? currentIndex,
    bool? isShowingDots,
    Set<int>? countedDots,
    int? totalStars,
    int? stacksCompleted,
  }) {
    return GameState(
      cardStack: cardStack ?? this.cardStack,
      currentIndex: currentIndex ?? this.currentIndex,
      isShowingDots: isShowingDots ?? this.isShowingDots,
      countedDots: countedDots ?? this.countedDots,
      totalStars: totalStars ?? this.totalStars,
      stacksCompleted: stacksCompleted ?? this.stacksCompleted,
    );
  }
}
