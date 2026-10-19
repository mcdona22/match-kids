import 'dart:convert';

import 'package:little_star_flashcards/features/number_flash_card/domain/number_flash_card_preferences.dart';
import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'number_flash_card_preferences_provider.g.dart';

const _numberFlashCardPrefsKey = 'number_flash_card_preferences';

@Riverpod(keepAlive: true)
class NumberFlashCardPreferencesController
    extends _$NumberFlashCardPreferencesController {
  @override
  NumberFlashCardPreferences build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_numberFlashCardPrefsKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        return NumberFlashCardPreferences.fromJson(json);
      } catch (_) {
        const fallback = NumberFlashCardPreferences();
        _persist(fallback, assignState: false);
        return fallback;
      }
    }

    const fallback = NumberFlashCardPreferences();
    _persist(fallback, assignState: false);
    return fallback;
  }

  void updateSessionSettings({int? cardCount, int? timeout}) {
    _persist(state.copyWith(
      cardCount: cardCount ?? state.cardCount,
      timeout: timeout ?? state.timeout,
    ));
  }

  void _persist(NumberFlashCardPreferences preferences,
      {bool assignState = true}) {
    if (assignState) {
      state = preferences;
    }

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_numberFlashCardPrefsKey, jsonEncode(preferences.toJson()));
  }
}
