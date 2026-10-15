import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/flash_card.dart';

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
        secondsRemaining.value = max(0.0, secondsRemaining.value - (stepMs / 1000.0));
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'What number is this?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF451A03)),
        ),
        const SizedBox(height: 24),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Color(0xFFFDE68A), Color(0xFFF472B6)]),
            boxShadow: [
              BoxShadow(color: Colors.amber.shade200, blurRadius: 20, spreadRadius: 4),
            ],
          ),
          child: Center(
            child: Container(
              width: 176,
              height: 176,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Center(
                child: Text(
                  '${card.number}',
                  style: const TextStyle(fontSize: 96, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (intervalSeconds > 0)
          Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.amber.shade100,
                color: Colors.amber.shade600,
                minHeight: 10,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 6),
              Text(
                'Showing dots in ${secondsRemaining.value.toStringAsFixed(1)}s',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF78350F)),
              ),
            ],
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onIntervalComplete,
            icon: const Icon(Icons.visibility),
            label: const Text('I Know It! Show Dots 👉', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
      ],
    );
  }
}
