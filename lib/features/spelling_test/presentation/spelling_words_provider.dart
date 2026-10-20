import 'package:little_star_flashcards/features/spelling_test/spelling_test_session.dart';
import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spelling_words_provider.g.dart';

@Riverpod(keepAlive: false)
class SpellingWords extends _$SpellingWords with UiLoggy {
  static const _key = 'little_star_flashcards.spelling_words';

  @override
  SpellingTestSession build() {
    final prefs = ref.read(sharedPreferencesProvider);
    ref.onDispose(() => loggy.debug('disposing SpellingWords provider'));

    final savedWords = prefs.getStringList(_key);

    if (savedWords == null) {
      loggy.debug('saving empty list as default');
      ref.read(sharedPreferencesProvider).setStringList(_key, []);
    }

    final normalized = _normalizeWords(savedWords!);
    final session = SpellingTestSession(words: normalized);
    loggy.debug('Initial session: $session');
    return session;
  }

  void saveWords(List<String> words) {
    final normalized = _normalizeWords(words);
    state = state.copyWith(words: normalized);
    loggy.debug('saving the words $words');
    ref.read(sharedPreferencesProvider).setStringList(_key, normalized);
  }

  void addWord(String wordToAdd) {
    final word = wordToAdd.toLowerCase().trim();
    if (wordToAdd.isNotEmpty) {
      state = state.copyWith(words: [...state.words, word]);
      _save(state.words);
    }
  }

  void removeWord(String word) {
    final updated = state.words.where((w) => w != word).toList();

    state = state.copyWith(words: updated);
    loggy.debug('removing "$word" words now $state');
  }

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

  void _save(List<String> words) {
    final normalized = _normalizeWords(words);
    state = state.copyWith(words: normalized);

    loggy.debug('Saving words list: $state');
    ref.read(sharedPreferencesProvider).setStringList(_key, normalized);
  }
}
