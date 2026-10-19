import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';

import '../../../models/flash_card.dart';
class NumberIntervalView extends HookConsumerWidget {
  final FlashCardItem card;
  final int intervalSeconds;
  final VoidCallback onIntervalComplete;

  const NumberIntervalView({
    super.key,
    required this.card,
    required this.intervalSeconds,
    required this.onIntervalComplete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local countdown timer state managed using useState hook
    final secondsRemaining = useState<double>(intervalSeconds.toDouble());

    // Timer lifecycle managed using useEffect hook
    useEffect(() {
      secondsRemaining.value = intervalSeconds.toDouble();
      if (intervalSeconds <= 0) return null;

      const stepMs = 100;
      final timer = Timer.periodic(const Duration(milliseconds: stepMs), (t) {
        secondsRemaining.value =
            max(0.0, secondsRemaining.value - (stepMs / 1000.0));
        if (secondsRemaining.value <= 0.05) {
          t.cancel();
          onIntervalComplete();
        }
      });

      return () => timer.cancel();
    }, [card.id, intervalSeconds]);

    final progress = intervalSeconds > 0
        ? (secondsRemaining.value / intervalSeconds).clamp(0.0, 1.0)
        : 0.0;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: UiDimensions.xxl,
      children: [
        Text('What number is this?', style: textTheme.displaySmall
            // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF451A03)),
            ),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                // colors: [Color(0xFFFDE68A), Color(0xFFF472B6)]
                colors: [
                  colorScheme.primaryFixed,
                  colorScheme.secondaryFixedDim
                ]),
            boxShadow: [
              BoxShadow(
                  color: colorScheme.secondaryFixedDim,
                  // color: Colors.amber.shade200,
                  blurRadius: 20,
                  spreadRadius: 4),
            ],
          ),
          child: Center(
            child: Container(
              width: 176,
              height: 176,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.white
              ),
              child: Center(
                child: Text('${card.number}',
                    style: textTheme.displayLarge!
                        .copyWith(fontSize: 140.0, fontWeight: FontWeight.w600)
                    // const TextStyle(
                    //     fontSize: 96,
                    //     fontWeight: FontWeight.w900,
                    //     color: Color(0xFF1E293B)
                    // ),
                    ),
              ),
            ),
          ),
        ),
        if (intervalSeconds > 0)
          Column(
            spacing: UiDimensions.xs,
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.secondary,
                color: colorScheme.secondaryFixedDim,
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
              ),
              Text(
                'Showing dots in ${secondsRemaining.value.toStringAsFixed(1)}s',
                style: textTheme.titleMedium,
              ),
            ],
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onIntervalComplete,
            icon: const Icon(Icons.visibility),
            label:
                Text('I Know It! Show Dots 👉', style: textTheme.titleMedium),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
      ],
    );
  }
}
