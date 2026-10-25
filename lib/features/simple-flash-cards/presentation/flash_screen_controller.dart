import 'dart:convert';

import 'package:little_star_flashcards/core/providers/shared_preferences_provider.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/flash_card_state.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flash_screen_controller.g.dart';

@riverpod
class FlashScreenController extends _$FlashScreenController with UiLoggy {
  static const _key = 'little_star.flash_card_session';
  static const _defaultStackSize = 10;
  static const _defaultHighestInt = 5;

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

  _newCardDeck() {
    return List.generate(state.cardCount, (i) => i + 1);
  }

  void _writePreferences({FlashCardState? session}) {
    loggy.debug('persisting session preferences : ${session ?? state}');
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode((session ?? state).toJson()));
  }
}
