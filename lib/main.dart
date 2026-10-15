import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/features/user/user_preferences_notifier.dart';
import 'package:little_star_flashcards/providers/shared_preferences_provider.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routing/router.dart';
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
      child: const LittleStarFlashCardsApp(),
    ),
  );
}

class LittleStarFlashCardsApp extends HookConsumerWidget {
  const LittleStarFlashCardsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Little Star Number Flash Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF59E0B),
          brightness: Brightness.light,
        ),
      ),
      themeMode: ref.watch(userPreferencesProvider).useDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: routerConfig,
      themeAnimationDuration: const Duration(milliseconds: 750),
    );
  }
}

class FlashCardsScreen extends HookConsumerWidget {
  const FlashCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final gameNotifier = ref.read(gameControllerProvider.notifier);
    final settings = ref.watch(settingsControllerProvider);
    final currentCard = gameState.currentCard;

    // Confetti Controller managed via useMemoized & useEffect hook
    final confettiController = useMemoized(
      () => ConfettiController(duration: const Duration(seconds: 2)),
    );
    useEffect(() {
      return () => confettiController.dispose();
    }, [confettiController]);

    return Scaffold(
      backgroundColor: const Color(0xFFFEF3C7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Number Cards (1–${settings.upperLimit})',
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF78350F),
              fontSize: 18),
        ),
        actions: [
          const ToggleThemModeButton(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text('${gameState.totalStars}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF78350F)),
            tooltip: 'Parent Zone',
            onPressed: () => _openParentZone(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 50,
            ),
          ),
          if (currentCard != null)
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentCard.isUpperRange)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '⭐ Star Challenge! (Upper 20%)',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),

                      // Main Flash Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                          side: BorderSide(
                              color: Colors.amber.shade300, width: 4),
                        ),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                              maxWidth: 480, minHeight: 460),
                          padding: const EdgeInsets.all(24),
                          child: !gameState.isShowingDots
                              ? NumberIntervalView(
                                  card: currentCard,
                                  intervalSeconds: settings.intervalSeconds,
                                  onIntervalComplete: gameNotifier.revealDots,
                                )
                              : DotsRevealedView(
                                  card: currentCard,
                                  countedDots: gameState.countedDots,
                                  onDotTapped: gameNotifier.tapDot,
                                  onAdvance: () {
                                    final finished = gameNotifier.advanceCard();
                                    if (finished) {
                                      confettiController.play();
                                      _showCelebration(
                                          context, gameState.cardStack.length);
                                    }
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Card ${gameState.currentIndex + 1} of ${gameState.cardStack.length}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF78350F)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCelebration(BuildContext context, int cardCount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CelebrationDialog(cardCount: cardCount),
    );
  }

  void _openParentZone(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => const ParentZoneModal(),
    );
  }
}
