import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/routing/router.dart';
import 'core/theme/themes.dart';
import 'features/user/user_preferences_notifier.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Little Star',
      debugShowCheckedModeBanner: true,
      // theme: ThemeData(
      //   useMaterial3: true,
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: const Color(0xFFF59E0B),
      //     brightness: Brightness.light,
      //   ),
      // ),
      theme: ThemeData.from(colorScheme: lightColorScheme),
      darkTheme: ThemeData.from(colorScheme: darkColorScheme),
      themeMode: ref.watch(userPreferencesProvider).useDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: routerConfig,
      themeAnimationDuration: const Duration(milliseconds: 750),
    );
  }
}
