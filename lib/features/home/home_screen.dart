import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/routing/router.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/core/ui/screen_names.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/home/kid_appealing_activity_card.dart';
import 'package:little_star_flashcards/providers/game_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final totalStars =
        ref.watch(gameControllerProvider.select((s) => s.totalStars));

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
            const SizedBox(width: 12),
            Text(
              'Little Star',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: const [
          // Container(
          //   margin: const EdgeInsets.symmetric(vertical: 8),
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: colorScheme.secondaryContainer,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     spacing: UiDimensions.xs,
          //     children: [
          //       Icon(
          //         Icons.star_rounded,
          //         color: colorScheme.primary,
          //         size: 20,
          //       ),
          //       Text(
          //         '$totalStars',
          //         style: textTheme.titleMedium?.copyWith(
          //           fontWeight: FontWeight.bold,
          //           color: colorScheme.onSecondaryContainer,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                // Hero Header Banner
                // Container(
                //   padding: const EdgeInsets.all(UiDimensions.xxl),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //         colorScheme.primaryContainer,
                //         colorScheme.surfaceContainerHighest,
                //       ],
                //     ),
                //     borderRadius: BorderRadius.circular(28),
                //     border: Border.all(
                //       color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           spacing: UiDimensions.sm,
                //           children: [
                //             Container(
                //               padding: const EdgeInsets.symmetric(
                //                 horizontal: 10,
                //                 vertical: 4,
                //               ),
                //               decoration: BoxDecoration(
                //                 color:
                //                     colorScheme.primary.withValues(alpha: 0.15),
                //                 borderRadius: BorderRadius.circular(12),
                //               ),
                //               child: Text(
                //                 'Early Learning Playground 🎈',
                //                 style: textTheme.labelMedium?.copyWith(
                //                   color: colorScheme.primary,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //             Text(
                //               'Ready to Learn & Play?',
                //               style: textTheme.headlineSmall?.copyWith(
                //                 fontWeight: FontWeight.w800,
                //                 color: colorScheme.onPrimaryContainer,
                //               ),
                //             ),
                //             Text(
                //               'Choose an activity below to explore numbers, count interactive dots, and collect shiny stars!',
                //               style: textTheme.bodyMedium?.copyWith(
                //                 color: colorScheme.onSurfaceVariant,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(width: UiDimensions.lg),
                //       Container(
                //         width: 72,
                //         height: 72,
                //         decoration: BoxDecoration(
                //           color: colorScheme.primary,
                //           shape: BoxShape.circle,
                //           boxShadow: [
                //             BoxShadow(
                //               color: colorScheme.primary.withValues(alpha: 0.3),
                //               blurRadius: 16,
                //               offset: const Offset(0, 6),
                //             ),
                //           ],
                //         ),
                //         child: Center(
                //           child: Icon(
                //             Icons.school_rounded,
                //             color: colorScheme.onPrimary,
                //             size: 38,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: UiDimensions.xxl),

                // Section Label
                Row(
                  children: [
                    Text(
                      'Learning Activities',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '1 Active • 1 Coming Soon',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UiDimensions.lg),

                // Action 1: Number Flashcards (Active Feature)

                // const SizedBox(height: UiDimensions.xl),

                // Action 2: Pattern & Shape Safari (Stub Feature)

                KidAppealingActivityCard(
                  title: spellingScreenTitle,
                  description:
                      'Working with a list of word challenges show, hide '
                      'and read each word to practice for spelling tests',
                  imagePath: 'assets/images/spelling.webp',
                  buttonLabel: "Let's Go",
                  onPressed: () =>
                      context.pushNamed(AppRoute.spellingTest.name),
                ),

                const KidAppealingActivityCard(
                  title: flashCardScreenTitle,
                  description: 'Flash cards to help with number fluency',
                  imagePath: 'assets/images/numbers.jpg',
                  buttonLabel: "Let's Go",
                  onPressed: null,
                  // onPressed: () =>
                  //     context.pushNamed(AppRoute.numberFlashCard.name),
                ),

                const SizedBox(height: UiDimensions.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
