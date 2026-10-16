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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final frameCount = max(1, (count / 10).ceil());

    return Column(
      children: List.generate(frameCount, (fIndex) {
        final frameStart = fIndex * 10;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: colorScheme.primaryFixedDim,
                // color: Colors.amber.shade300,
                width: 1),
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
                    color: hasDot
                        ? colorScheme.primaryContainer
                        : colorScheme.primaryFixedDim.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isCounted ? Colors.transparent : colorScheme.primary,
                      width: isCounted ? 2 : 1,
                    ),
                  ),
                  child: hasDot
                      ? Center(
                          child: isCounted
                              ? Text('$dotNumber',
                                  style: textTheme.displaySmall!
                                      .copyWith(color: colorScheme.onPrimary)
                                  // const TextStyle(
                                  //   fontWeight: FontWeight.bold,
                                  //   // color: Colors.green,
                                  //   fontSize: 14,
                                  // ),
                                  )
                              : Text('⭐', style: textTheme.titleLarge),
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
