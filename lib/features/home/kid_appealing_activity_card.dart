import 'package:flutter/material.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:loggy/loggy.dart';

class KidAppealingActivityCard extends StatelessWidget with UiLoggy {
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final Key? buttonKey;
  final String? imagePath;
  final Color? containerColor;
  final bool isNew;

  const KidAppealingActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
    this.buttonKey,
    this.imagePath,
    this.containerColor,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEnabled = onPressed != null;

    final cardBackgroundColor = isEnabled
        ? (containerColor ?? colorScheme.surfaceContainerHigh)
        : colorScheme.surfaceContainerLow.withValues(alpha: 0.5);

    return Card(
      elevation: isEnabled ? 4 : 0,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(
          color: colorScheme.outlineVariant
              .withValues(alpha: isEnabled ? 0.6 : 0.3),
          width: isEnabled ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header + Badge Stack
              if (imagePath != null) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Hero(
                          tag: '$title-hero',
                          child: Image.asset(
                            imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              loggy.error(error);
                              return Container(
                                color: colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.image_not_supported_rounded,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    if (isNew || !isEnabled)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: !isEnabled
                                ? colorScheme.surfaceContainerHighest
                                : colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    colorScheme.shadow.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            !isEnabled ? 'Coming Soon' : 'New!',
                            style: textTheme.labelMedium?.copyWith(
                              color: !isEnabled
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: UiDimensions.lg),
              ],

              // Kid-friendly Title
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isEnabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: UiDimensions.xs),

              // Description
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: UiDimensions.xl),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: buttonKey,
                  onPressed: onPressed,
                  icon: const Icon(Icons.play_arrow_rounded, size: 24),
                  label: Text(buttonLabel),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: isEnabled
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    foregroundColor: isEnabled
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    elevation: isEnabled ? 2 : 0,
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
