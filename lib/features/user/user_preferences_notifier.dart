import 'dart:convert';

import 'package:little_star_flashcards/features/user/user_preferences.dart';
import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_notifier.g.dart';

@riverpod
class UserPreferencesNotifier extends _$UserPreferencesNotifier with UiLoggy {
  final _key = 'com.mcdona22.number-match-kds.preferences';

  @override
  UserPreferences build() {
    loggy.info('creating the user preference object');
    final defaultPreferences = UserPreferences(useDarkMode: true);
    final prefs = ref.read(sharedPreferencesProvider);
    final rawJson = prefs.getString(_key);

    if (rawJson != null && rawJson.isNotEmpty) {
      loggy.debug('preferences found: $rawJson');
      try {
        return UserPreferences.fromJson(jsonDecode(rawJson));
      } catch (e) {
        loggy.warning(
            'Something wrong fetching preferences - returning defaults');
        _writePreferences(defaultPreferences);
        return defaultPreferences;
      }
    } else {
      loggy.debug('No preferences saved - using defaults');
      _writePreferences(defaultPreferences, assignState: false);
      return defaultPreferences;
    }
  }

  void toggleDarkMode() =>
      _writePreferences(state.copyWith(useDarkMode: !state.useDarkMode));

  void _writePreferences(UserPreferences preference,
      {bool assignState = true}) {
    loggy.debug('writing preferences', preference);
    if (assignState) state = preference;
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode(preference.toJson()));
  }
}
