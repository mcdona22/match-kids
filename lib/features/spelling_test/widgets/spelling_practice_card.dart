import 'package:flutter/material.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';

class SpellingPracticeCard extends StatelessWidget {
  const SpellingPracticeCard({
    required this.sessionWords,
    required this.hideWords,
    required this.reviewMode,
    required this.displayedWord,
    required this.onToggleHide,
    required this.onRead,
    required this.onNext,
    required this.onPracticeAgain,
    super.key,
  });

  final List<String> sessionWords;
  final bool hideWords;
  final bool reviewMode;
  final String? displayedWord;
  final VoidCallback onToggleHide;
  final VoidCallback onRead;
  final VoidCallback onNext;
  final VoidCallback onPracticeAgain;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(UiDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SpellingPracticeHeader(
              hideWords: hideWords,
              onToggleHide: onToggleHide,
            ),
            const SizedBox(height: UiDimensions.md),
            if (sessionWords.isEmpty)
              _SpellingPracticeEmptyState()
            else if (reviewMode)
              _SpellingPracticeReviewView(
                sessionWords: sessionWords,
                onPracticeAgain: onPracticeAgain,
              )
            else
              _SpellingPracticeWordView(
                displayedWord: displayedWord,
                onRead: onRead,
                onNext: onNext,
              ),
          ],
        ),
      ),
    );
  }
}

class _SpellingPracticeHeader extends StatelessWidget {
  const _SpellingPracticeHeader({
    required this.hideWords,
    required this.onToggleHide,
  });

  final bool hideWords;
  final VoidCallback onToggleHide;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Practice session',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        FilledButton.tonalIcon(
          onPressed: onToggleHide,
          icon: Icon(hideWords ? Icons.visibility : Icons.visibility_off),
          label: Text(hideWords ? 'Show words' : 'Hide words'),
        ),
      ],
    );
  }
}

class _SpellingPracticeEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UiDimensions.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(UiDimensions.md),
      ),      child: Text(
        'Select one or more words to begin the spelling test.',
        style: textTheme.bodyLarge,
      ),
    );
  }
}

class _SpellingPracticeReviewView extends StatelessWidget {
  const _SpellingPracticeReviewView({
    required this.sessionWords,
    required this.onPracticeAgain,
  });

  final List<String> sessionWords;
  final VoidCallback onPracticeAgain;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Check your spelling',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: UiDimensions.md),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sessionWords.map((word) => Chip(label: Text(word))).toList(),
        ),
        const SizedBox(height: UiDimensions.md),
        FilledButton.icon(
          onPressed: onPracticeAgain,
          icon: const Icon(Icons.refresh),
          label: const Text('Practice again'),
        ),
      ],
    );
  }
}

class _SpellingPracticeWordView extends StatelessWidget {
  const _SpellingPracticeWordView({
    required this.displayedWord,
    required this.onRead,
    required this.onNext,
  });

  final String? displayedWord;
  final VoidCallback onRead;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              displayedWord ?? '••••',
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: UiDimensions.xl),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onRead,
                child: const Text('Read'),
              ),
            ),
            const SizedBox(width: UiDimensions.md),
            Expanded(
              child: FilledButton(
                onPressed: onNext,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
