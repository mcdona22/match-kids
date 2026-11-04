import 'dart:convert';

import 'package:little_star_flashcards/core/providers/shared_preferences_provider.dart';
import 'package:little_star_flashcards/features/multiply/multiply_screen_state.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'multiply_screen_controller.g.dart';

@riverpod
class MultiplyScreenController extends _$MultiplyScreenController with UiLoggy {
  static const _key = 'little_star.multiply_session';

  static const _defaultPreferences =
      MultiplyScreenState(cardCount: 20, highestOperand: 3);

  @override
  MultiplyScreenState build() {
    final prefs = ref.read(sharedPreferencesProvider);

    ref.onDispose(() => loggy.debug('MultiplyScreenController disposed'));

    final rawJson = prefs.getString(_key);

    if (rawJson != null && rawJson.isNotEmpty) {
      loggy.debug('preferences found $rawJson');
      try {
        return MultiplyScreenState.fromJson(jsonDecode(rawJson));
      } catch (e) {
        loggy.error(
            'Something not right with the json.  Using defaults', rawJson);
        _writePreferences(session: _defaultPreferences);
        return _defaultPreferences;
      }
    } else {
      loggy.debug('no preferences found using defaults');
      _writePreferences(session: _defaultPreferences);
      return _defaultPreferences;
    }
  }

  updateSessionConfig(int count, int maxOperand) {
    final newState =
        state.copyWith(cardCount: count, highestOperand: maxOperand);

    state = newState;
    _writePreferences(session: newState);
  }

  void persistState() {
    _writePreferences();
  }

  // private helpers

  void _writePreferences({MultiplyScreenState? session}) {
    loggy.debug('persisting session preferences : ${session ?? state}');
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode((session ?? state).toJson()));
  }
}
