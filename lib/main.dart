import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/app.dart';
import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
