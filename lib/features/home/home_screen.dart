import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/routing/router.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/core/ui/screen_names.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/home/kid_appealing_activity_card.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final activityCards = [
      KidAppealingActivityCard(
        key: const ValueKey('spelling-card'),
        title: spellingScreenTitle,
        description:
            'Practice a growing word list, hide the words, read them aloud, and review your spelling.',
        imagePath: 'assets/images/spelling.webp',
        buttonLabel: 'Little Star Spelling',
        buttonKey: const ValueKey('spelling-card-button'),
        onPressed: () => context.pushNamed(AppRoute.spellingTest.name),
      ),
      const KidAppealingActivityCard(
        key: const ValueKey('number-card'),
        title: flashCardScreenTitle,
        description:
            'Flip through a paced set of number cards and build confidence with each round.',
        imagePath: 'assets/images/numbers.jpg',
        buttonLabel: 'Little Star Number Cards',
        buttonKey: const ValueKey('number-card-button'),
        onPressed: null,

        // onPressed: () => context.pushNamed(AppRoute.numberFlashCard.name),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Row(
          spacing: UiDimensions.md,
          children: [
            Container(
              padding: const EdgeInsets.all(UiDimensions.sm),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: colorScheme.onPrimaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(width: UiDimensions.sm),
            Text(
              'Little Star',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: const [
          SizedBox(width: UiDimensions.xxs),
          ToggleThemModeButton(iconSize: 24),
          SizedBox(width: UiDimensions.sm),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                const SizedBox(height: UiDimensions.lg),
                ...activityCards,
                const SizedBox(height: UiDimensions.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
