import 'package:flutter/material.dart';
import 'package:little_star_flashcards/features/number_flash_card/presentation/widgets/number_speak_tile.dart';

class NumberAnswerCard extends StatelessWidget {
  const NumberAnswerCard({
    required this.number,
    required this.correctCount,
    required this.incorrectCount,
    required this.onSpeak,
    required this.onRight,
    required this.onWrong,
    super.key,
  });

  final int number;
  final int correctCount;
  final int incorrectCount;
  final ValueChanged<int> onSpeak;
  final VoidCallback onRight;
  final VoidCallback onWrong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tiles = List<Widget>.generate(10, (index) {
      final value = index + 1;
      if (value > number) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
          ),
        );
      }

      return NumberSpeakTile(
        value: value,
      );
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => onSpeak(number),
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 132,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tap the big number or the tiles to hear it again.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: tiles,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onRight,
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    label: const Text('Right'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onWrong,
                    icon: const Icon(Icons.thumb_down_alt_outlined),
                    label: const Text('Wrong'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 18),
                const SizedBox(width: 6),
                Text('$correctCount'),
                const SizedBox(width: 18),
                const Icon(Icons.cancel, size: 18),
                const SizedBox(width: 6),
                Text('$incorrectCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
