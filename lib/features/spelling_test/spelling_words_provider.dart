import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'spelling_words_provider.g.dart';

@Riverpod(keepAlive: true)
class SpellingWords extends _$SpellingWords {
  static const _key = 'little_star_flashcards.spelling_words';

  @override
  List<String> build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final savedWords = prefs.getStringList(_key);

    if (savedWords == null || savedWords.isEmpty) {
      const defaultWords = ['cat', 'sun', 'dog', 'star', 'tree'];
      _save(defaultWords);
      return defaultWords;
    }

    final normalized = _normalizeWords(savedWords);
    if (normalized.isEmpty) {
      const defaultWords = ['cat', 'sun', 'dog', 'star', 'tree'];
      _save(defaultWords);
      return defaultWords;
    }

    return normalized;
  }

  void saveWords(List<String> words) {
    final normalized = _normalizeWords(words);
    state = normalized;
    ref.read(sharedPreferencesProvider).setStringList(_key, normalized);
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
    state = normalized;
    ref.read(sharedPreferencesProvider).setStringList(_key, normalized);
  }
}
