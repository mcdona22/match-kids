import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/providers/shared_preferences_provider.dart';

mixin StoragePersistenceMixin<T> {
  Ref get ref;

  T get state;

  set state(T newState);

  String get storageKey;

  T get defaultState;

  T Function(Map<String, dynamic> json) get fromJsonFactory;

  Map<String, dynamic> Function(T state) get toJsonFactory;

  T loadState({T Function(T loadedState)? onLoaded}) {
    final prefs = ref.read(sharedPreferencesProvider);
    final rawJson = prefs.getString(storageKey);

    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final decoded = fromJsonFactory(jsonDecode(rawJson));
        return onLoaded != null ? onLoaded(decoded) : decoded;
      } catch (e) {
        saveState(defaultState);
        return defaultState;
      }
    } else {
      // nothing under that key
      saveState(defaultState);
      return defaultState;
    }
  }

  void emitAndSaveState(T newState) {
    state = newState;
    saveState();
  }

  void saveState([T? customState]) {
    final prefs = ref.read(sharedPreferencesProvider);
    final targetState = customState ?? state;
    prefs.setString(storageKey, jsonEncode(targetState));
  }
}
