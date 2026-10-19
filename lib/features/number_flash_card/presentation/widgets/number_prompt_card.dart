import 'package:flutter/material.dart';

class NumberPromptCard extends StatelessWidget {
  const NumberPromptCard({
    required this.number,
    required this.timerSeconds,
    required this.onKnowIt,
    super.key,
  });

  final int number;
  final int timerSeconds;
  final VoidCallback onKnowIt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'What number is this?',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primaryContainer,
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
            const SizedBox(height: 24),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: timerSeconds > 0 ? timerSeconds / 5 : 0,
              minHeight: 12,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Time left: $timerSeconds s',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onKnowIt,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('I know this'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
