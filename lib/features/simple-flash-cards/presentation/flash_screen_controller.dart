import 'dart:convert';
import 'dart:math';

import 'package:little_star_flashcards/core/providers/shared_preferences_provider.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/flash_card_state.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flash_screen_controller.g.dart';

@riverpod
class FlashScreenController extends _$FlashScreenController with UiLoggy {
  static const _key = 'little_star.flash_card_session';
  static const _defaultStackSize = 20;
  static const _defaultHighestInt = 5;
  static const _defaultChallengingSlice = 0.35;
  static const _defaultGimmeSlice = 0.4;

  @override
  FlashCardState build() {
    ref.onDispose(() => loggy.debug('disposing flash card session controller'));

    const defaultPreferences = FlashCardState(
        cardCount: _defaultStackSize, highestInt: _defaultHighestInt);
    final prefs = ref.read(sharedPreferencesProvider);

    final rawJson = prefs.getString(_key);
    if (rawJson != null && rawJson.isNotEmpty) {
      loggy.debug('preferences found - $rawJson');
      try {
        return FlashCardState.fromJson(jsonDecode(rawJson));
      } catch (e) {
        loggy.warning(
            'Something wrong fetching preferences - returning defaults');
        _writePreferences(session: defaultPreferences);
        return defaultPreferences;
      }
    } else {
      loggy.debug('Preferences not found - using defaults');
      _writePreferences(session: defaultPreferences);
      return defaultPreferences;
    }
  }

  void decrementIndex() {
    if (state.currentCardIndex > 0) {
      state = state.copyWith(currentCardIndex: state.currentCardIndex - 1);
    }
  }

  void incrementIndex() {
    if (state.currentCardIndex < state.cardCount - 1) {
      state = state.copyWith(currentCardIndex: state.currentCardIndex + 1);
    }
  }

  void startTest() => state = state.copyWith(
      testMode: true, cardDeck: _newCardDeck(), currentCardIndex: 0);

  void stopTest() => state = state.copyWith(testMode: false, cardDeck: []);

  void updateSessionConfig(int count, int maxCard) {
    state = state.copyWith(
        cardCount: count, highestInt: maxCard, currentCardIndex: 0);
    _writePreferences();
    loggy.debug('saved session config: $state');
  }

  List<int> _newCardDeck() {
    final random = Random();
    final requiredHardNumberCount = state.cardCount * _defaultChallengingSlice;
    final remainder = state.cardCount - requiredHardNumberCount;
    final gimmeThreshold = (state.highestInt * _defaultGimmeSlice).toInt();

    loggy
        .debug('{hardCount: $requiredHardNumberCount, secureCount: $remainder, '
            'gimme: $gimmeThreshold}');
    final hardNumbers = List.generate(
        requiredHardNumberCount.toInt(),
        (_) =>
            _getRandomBetween(state.highestInt - 2, state.highestInt, random));
    final secureNumbers = List.generate(
        state.cardCount - requiredHardNumberCount.toInt(),
        (_) => _getRandomBetween(gimmeThreshold, state.highestInt - 1, random));
    loggy.debug('hard numbers: $hardNumbers');
    loggy.debug('secure numbers: $secureNumbers');
    final all = [...secureNumbers, ...hardNumbers];
    all.shuffle();
    loggy.debug(all);
    return all;
  }

  int _getRandomBetween(int min, int max, Random random) =>
      min + random.nextInt((max - min) + 1);

  void _writePreferences({FlashCardState? session}) {
    loggy.debug('persisting session preferences : ${session ?? state}');
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode((session ?? state).toJson()));
  }
}
