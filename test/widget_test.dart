import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/app.dart';
import 'package:little_star_flashcards/core/routing/router.dart';
import 'package:little_star_flashcards/features/flash_cards/presentation/flash_screen.dart';
import 'package:little_star_flashcards/features/number_flash_card/presentation/number_flash_card_screen.dart';
import 'package:little_star_flashcards/features/spelling_test/spelling_test_screen.dart';
import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test loads successfully with ProviderScope',
      (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Little Star'), findsOneWidget);
    expect(find.text('Play Number Cards'), findsOneWidget);
    expect(find.text('Play Number Flash Card'), findsOneWidget);
    expect(find.text('Open Spelling Test'), findsOneWidget);
  });

  testWidgets('pressing feature buttons routes to the right screens',
      (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();

    routerConfig.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Play Number Cards'));
    await tester.pumpAndSettle();
    expect(find.byType(FlashCardsScreen), findsOneWidget);

    routerConfig.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Play Number Flash Card'),
      100,
    );
    await tester.tap(find.text('Play Number Flash Card'));
    await tester.pumpAndSettle();
    expect(find.byType(NumberFlashCardScreen), findsOneWidget);

    routerConfig.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Open Spelling Test'),
      100,
    );
    await tester.tap(find.text('Open Spelling Test'));
    await tester.pumpAndSettle();
    expect(find.byType(SpellingTestScreen), findsOneWidget);
  });
}
