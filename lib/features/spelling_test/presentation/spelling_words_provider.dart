import 'dart:convert';

import 'package:little_star_flashcards/core/providers/shared_preferences_provider.dart';
import 'package:little_star_flashcards/features/spelling_test/presentation/spelling_test_session.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spelling_words_provider.g.dart';

@Riverpod(keepAlive: false)
class SpellingWords extends _$SpellingWords with UiLoggy {
  static const _key = 'little_star.spelling_session';

  @override
  SpellingTestSession build() {
    ref.onDispose(() => loggy.debug('disposing SpellingWords session '));
    const defaultPreferences = SpellingTestSession();
    final prefs = ref.read(sharedPreferencesProvider);

    final rawJson = prefs.getString(_key);
    loggy.debug('raw json is $rawJson');
    if (rawJson != null && rawJson.isNotEmpty) {
      loggy.debug('preferences found - $rawJson');
      try {
        return SpellingTestSession.fromJson(jsonDecode(rawJson))
            .copyWith(testMode: false);
        // when we create a new session we are not in test mode at the beginning
        // regardless of how we left the session and it was disposed
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

  void resetSession() {
    state = const SpellingTestSession();
    _writePreferences();
  }

  void saveWords(List<String> words) {
    final normalized = _normalizeWords(words);
    state = state.copyWith(words: normalized);
    loggy.debug('saving the words $words');
    _writePreferences();
  }

  void addWord(String wordToAdd) {
    final word = wordToAdd.toLowerCase().trim();
    if (wordToAdd.isNotEmpty) {
      state = state.copyWith(words: [...state.words, word]);
      _writePreferences();
    }
  }

  void removeWord(String word) {
    final updatedWords = state.words.where((w) => w != word).toList();
    final updatedSelections =
        state.selectedWords.where((w) => w != word).toList();

    state =
        state.copyWith(words: updatedWords, selectedWords: updatedSelections);
    loggy.debug('removing "$word" words now $state');
    _writePreferences();
  }

  void toggleSelectionStatus(String word) {
    final isSelected = state.selectedWords.contains(word);
    final updatedSelected = isSelected
        ? state.selectedWords.where((found) => found != word).toList()
        : [...state.selectedWords, word];

    state = state.copyWith(selectedWords: updatedSelected);
    _writePreferences();
  }

  bool isSelected(String word) => state.selectedWords.contains(word);

  List<String> _normalizeWords(List<String> words) {
    final normalized = <String>[];

    for (final word in words) {
      final trimmed = word.trim();
      if (trimmed.isEmpty || normalized.contains(trimmed)) {
        continue;
      }
      normalized.add(trimmed);
    }

    return normalized;
  }

  set testMode(bool value) => state = state.copyWith(testMode: value);

  void _writePreferences({SpellingTestSession? session}) {
    loggy.debug('persisting session preferences : ${session ?? state}');
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode((session ?? state).toJson()));
  }
}
