import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/app.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'widgets/celebration_dialog.dart';
import 'widgets/dots_revealed_view.dart';
import 'widgets/number_interval_view.dart';
import 'widgets/parent_zone_modal.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Loggy.initLoggy(logPrinter: const PrettyDeveloperPrinter());

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)]);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
