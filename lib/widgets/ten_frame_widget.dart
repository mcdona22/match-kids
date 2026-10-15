import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TenFrameWidget extends HookConsumerWidget {
  final int count;
  final Set<int> countedDots;
  final ValueChanged<int> onDotTapped;

  const TenFrameWidget({
    super.key,
    required this.count,
    required this.countedDots,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frameCount = max(1, (count / 10).ceil());

    return Column(
      children: List.generate(frameCount, (fIndex) {
        final frameStart = fIndex * 10;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.shade300, width: 2),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: 10,
            itemBuilder: (ctx, index) {
              final dotNumber = frameStart + index + 1;
              final hasDot = dotNumber <= count;
              final isCounted = countedDots.contains(dotNumber);

              return GestureDetector(
                onTap: hasDot ? () => onDotTapped(dotNumber) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: hasDot ? Colors.white : Colors.amber.shade100.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCounted ? Colors.green : Colors.amber.shade200,
                      width: isCounted ? 2 : 1,
                    ),
                  ),
                  child: hasDot
                      ? Center(
                          child: isCounted
                              ? Text(
                                  '$dotNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 14,
                                  ),
                                )
                              : const Text('⭐', style: TextStyle(fontSize: 20)),
                        )
                      : null,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
