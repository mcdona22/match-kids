import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/routing/router.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
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
            Text(
              'Little Star',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: UiDimensions.xs,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                Text(
                  '$totalStars',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: UiDimensions.xxs),
          const ToggleThemModeButton(iconSize: 24),
          const SizedBox(width: UiDimensions.sm),
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
                Container(
                  padding: const EdgeInsets.all(UiDimensions.xxl),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.surfaceContainerHighest,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: UiDimensions.sm,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Early Learning Playground 🎈',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'Ready to Learn & Play?',
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              'Choose an activity below to explore numbers, count interactive dots, and collect shiny stars!',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: UiDimensions.lg),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.school_rounded,
                            color: colorScheme.onPrimary,
                            size: 38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: UiDimensions.xxl),

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
                _ActivityCard(
                  title: 'Eliza Number Fluency',
                  subtitle:
                      'Flash cards with timed reveals, interactive ten-frame dot counting, audio narration, and rewards.',
                  badgeText: 'Active • Montessori',
                  badgeColor: colorScheme.primary,
                  badgeTextColor: colorScheme.onPrimary,
                  icon: Icons.pin_outlined,
                  iconBackgroundColor: colorScheme.primaryContainer,
                  iconColor: colorScheme.onPrimaryContainer,
                  buttonLabel: 'Play Number Cards',
                  buttonIcon: Icons.play_arrow_rounded,
                  onPressed: () =>
                      context.pushNamed(AppRoute.numberRecognition.name),
                  tags: const [
                    '1 to 10+ Range',
                    'Touch to Count',
                    'Ten-Frame Grid'
                  ],
                ),
                const SizedBox(height: UiDimensions.xl),
 
                // Action 2: Pattern & Shape Safari (Stub Feature)
                _ActivityCard(
                  title: 'Olivia Spelling...',
                  subtitle: 'Working with a list of word challenges show, hide '
                      'and read each word to practice for spelling tests',
                  badgeText: 'New',
                  badgeColor: colorScheme.secondaryContainer,
                  badgeTextColor: colorScheme.onSecondaryContainer,
                  icon: Icons.category_outlined,
                  iconBackgroundColor: colorScheme.secondaryContainer,
                  iconColor: colorScheme.onSecondaryContainer,
                  buttonLabel: 'Open Spelling Test',
                  buttonIcon: Icons.play_arrow_rounded,
                  onPressed: () => context.pushNamed(AppRoute.spellingTest.name),
                  tags: const [
                    'Spelling',
                    'Practice, hide, check',
                  ],
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

class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback? onPressed;
  final List<String> tags;

  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onPressed,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEnabled = onPressed != null;

    return Card(
      elevation: isEnabled ? 4 : 0,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
      color: isEnabled
          ? colorScheme.surface
          : colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isEnabled
              ? colorScheme.outlineVariant.withValues(alpha: 0.6)
              : colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: isEnabled ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon + Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: iconColor, size: 30),
                  ),
                  const SizedBox(width: UiDimensions.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                badgeText,
                                style: textTheme.labelSmall?.copyWith(
                                  color: badgeTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          title,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isEnabled
                                ? colorScheme.onSurface
                                : colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: UiDimensions.md),
 
              // Description
              Text(
                subtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: isEnabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: UiDimensions.lg),
 
              // Tags
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5)
                          : colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: textTheme.labelSmall?.copyWith(
                        color: isEnabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: UiDimensions.xl),
 
              // Action Button (with null onPressed for stub)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onPressed,
                  icon: Icon(buttonIcon, size: 20),
                  label: Text(buttonLabel),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: isEnabled ? colorScheme.primary : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
