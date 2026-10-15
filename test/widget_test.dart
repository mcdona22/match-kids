import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/main.dart';

void main() {
  testWidgets('App smoke test loads successfully with ProviderScope', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LittleStarFlashCardsApp(),
      ),
    );

    expect(find.textContaining('Number Cards'), findsOneWidget);
  });
}
