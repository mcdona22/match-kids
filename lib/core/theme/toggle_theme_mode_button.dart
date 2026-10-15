import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/features/user/user_preferences_notifier.dart';
import 'package:loggy/loggy.dart';

class ToggleThemModeButton extends HookConsumerWidget with UiLoggy {
  const ToggleThemModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(userPreferencesProvider).useDarkMode;

    return IconButton(
      icon: Icon(darkMode ? Icons.light_mode : Icons.dark_mode),
      onPressed: ref.read(userPreferencesProvider.notifier).toggleDarkMode,
    );
  }
}
