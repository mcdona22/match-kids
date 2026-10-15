import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/parent_settings.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  @override
  ParentSettings build() {
    _loadFromPrefs();
    return const ParentSettings();
  }

  void _loadFromPrefs() {
    final prefs = ref.watch(sharedPreferencesProvider);
    state = ParentSettings(
      upperLimit: prefs.getInt('upperLimit') ?? 10,
      lowerLimit: prefs.getInt('lowerLimit') ?? 1,
      stackSize: prefs.getInt('stackSize') ?? 10,
      intervalSeconds: prefs.getInt('intervalSeconds') ?? 3,
      soundEnabled: prefs.getBool('soundEnabled') ?? true,
      speechEnabled: prefs.getBool('speechEnabled') ?? true,
    );
  }

  void updateSettings(ParentSettings newSettings) {
    state = newSettings;
    final prefs = ref.watch(sharedPreferencesProvider);
    prefs.setInt('upperLimit', newSettings.upperLimit);
    prefs.setInt('lowerLimit', newSettings.lowerLimit);
    prefs.setInt('stackSize', newSettings.stackSize);
    prefs.setInt('intervalSeconds', newSettings.intervalSeconds);
    prefs.setBool('soundEnabled', newSettings.soundEnabled);
    prefs.setBool('speechEnabled', newSettings.speechEnabled);
  }
}
