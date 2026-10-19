import 'dart:math';

import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flash_card.dart';
import '../models/game_state.dart';
import 'settings_provider.dart';

part 'game_provider.g.dart';

@Riverpod(keepAlive: true)
class GameController extends _$GameController {
  @override
  GameState build() {
    _loadStars();
    // Build initial stack
    return _createInitialStack();
  }

  GameState _createInitialStack() {
    final settings = ref.read(settingsControllerProvider);
    final cards = _buildRandomizedStack(
        settings.upperLimit, settings.lowerLimit, settings.stackSize);
    return GameState(
      cardStack: cards,
      currentIndex: 0,
      isShowingDots: false,
      countedDots: const {},
    );
  }

  Future<void> _loadStars() async {
    final prefs = await SharedPreferences.getInstance();
    final stars = prefs.getInt('totalStars') ?? 0;
    state = state.copyWith(totalStars: stars);
  }

  Future<void> _saveStars(int stars) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalStars', stars);
  }

  List<FlashCardItem> _buildRandomizedStack(
      int upperLimit, int lowerLimit, int stackSize) {
    final random = Random();
    final span = max(1, upperLimit - lowerLimit + 1);
    final upperTierCount = max(1, (span * 0.25).round());
    final upperRangeStart =
        max(lowerLimit + 1, upperLimit - upperTierCount + 1);

    final upperCount = max(1, (stackSize * 0.20).round());
    final foundationCount = max(0, stackSize - upperCount);

    final foundationPool = List.generate(
      max(1, upperRangeStart - lowerLimit),
      (i) => lowerLimit + i,
    );
    final upperPool = List.generate(
      max(1, upperLimit - upperRangeStart + 1),
      (i) => upperRangeStart + i,
    );

    final List<FlashCardItem> cards = [];

    // 20% upper range cards
    for (int i = 0; i < upperCount; i++) {
      final num = upperPool[random.nextInt(upperPool.length)];
      cards.add(FlashCardItem(
        id: 'upper_${i}_${DateTime.now().microsecondsSinceEpoch}',
        number: num,
        isUpperRange: true,
      ));
    }

    // 80% foundation cards
    for (int i = 0; i < foundationCount; i++) {
      final num = foundationPool.isNotEmpty
          ? foundationPool[random.nextInt(foundationPool.length)]
          : upperPool[random.nextInt(upperPool.length)];
      cards.add(FlashCardItem(
        id: 'found_${i}_${DateTime.now().microsecondsSinceEpoch}',
        number: num,
        isUpperRange: false,
      ));
    }

    // Fisher-Yates shuffle
    cards.shuffle(random);
    return cards;
  }

  void generateNewStack() {
    final settings = ref.read(settingsControllerProvider);
    final cards = _buildRandomizedStack(
        settings.upperLimit, settings.lowerLimit, settings.stackSize);

    state = state.copyWith(
      cardStack: cards,
      currentIndex: 0,
      isShowingDots: false,
      countedDots: const {},
    );
  }

  void revealDots() {
    state = state.copyWith(isShowingDots: true);
    final card = state.currentCard;
    if (card != null && ref.read(settingsControllerProvider).speechEnabled) {
      ref.read(ttsProvider).speak("${card.number}");
    }
  }

  void resetToNumber() {
    state = state.copyWith(isShowingDots: false, countedDots: const {});
  }

  void tapDot(int dotIndex) {
    final updated = Set<int>.from(state.countedDots)..add(dotIndex);
    state = state.copyWith(countedDots: updated);
    if (ref.read(settingsControllerProvider).speechEnabled) {
      ref.read(ttsProvider).speak("$dotIndex");
    }
  }

  bool advanceCard() {
    final newStars = state.totalStars + 1;
    _saveStars(newStars);

    if (state.currentIndex + 1 < state.cardStack.length) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        isShowingDots: false,
        countedDots: const {},
        totalStars: newStars,
      );
      return false; // Not finished stack
    } else {
      // Completed full stack!
      state = state.copyWith(
        totalStars: newStars,
        stacksCompleted: state.stacksCompleted + 1,
      );
      return true; // Finished full stack
    }
  }
}
