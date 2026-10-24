import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/app.dart';
import 'package:little_star_flashcards/core/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App loads and shows the Little Star home page',
      (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Little Star'), findsWidgets);
    expect(find.text('Little Star Spelling'), findsWidgets);
  });
}
