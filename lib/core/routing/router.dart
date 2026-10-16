import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:little_star_flashcards/features/flash_cards/presentation/flash_screen.dart';
import 'package:little_star_flashcards/features/home/home_screen.dart';
import 'package:little_star_flashcards/features/spelling_test/spelling_test_screen.dart';
import 'package:little_star_flashcards/main.dart';

enum AppRoute { home, numberRecognition, spellingTest }

GoRouter routerConfig = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/${AppRoute.numberRecognition.name}',
      name: AppRoute.numberRecognition.name,
      pageBuilder: (_, state) =>
          MaterialPage(child: const FlashCardsScreen(), key: state.pageKey),
    ),
    GoRoute(
      path: '/${AppRoute.spellingTest.name}',
      name: AppRoute.spellingTest.name,
      pageBuilder: (_, state) =>
          MaterialPage(child: const SpellingTestScreen(), key: state.pageKey),
    ),
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      pageBuilder: (_, state) =>
          MaterialPage(child: const HomeScreen(), key: state.pageKey),
    ),
  ],
);
