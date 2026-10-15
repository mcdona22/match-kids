import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:little_star_flashcards/features/flash_cards/flash_screen.dart';
import 'package:little_star_flashcards/main.dart';

enum AppRoute { home, numberRecognition }

GoRouter routerConfig = GoRouter(
  initialLocation: AppRoute.numberRecognition.name,
  debugLogDiagnostics: true,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
        path: '/${AppRoute.numberRecognition.name}',
        name: AppRoute.numberRecognition.name,
        pageBuilder: (_, state) =>
            MaterialPage(child: FlashCardsScreen(), key: state.pageKey))
  ],
);
