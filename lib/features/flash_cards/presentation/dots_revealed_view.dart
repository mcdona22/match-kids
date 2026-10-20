import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/application/tts_provider.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';

import '../../../models/flash_card.dart';
import '../../../widgets/ten_frame_widget.dart';

class DotsRevealedView extends HookConsumerWidget {
  final FlashCardItem card;
  final Set<int> countedDots;
  final ValueChanged<int> onDotTapped;
  final VoidCallback onAdvance;

  const DotsRevealedView({
    super.key,
    required this.card,
    required this.countedDots,
    required this.onDotTapped,
    required this.onAdvance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tts = ref.read(ttsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      spacing: UiDimensions.lg,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${card.number}', style: textTheme.displayMedium,
                // style: TextStyle(
                //     fontSize: 22,
                //     fontWeight: FontWeight.bold,
                //     color: colorScheme.primary),
              ),
            ),
            Text('Touch dots to count!', style: textTheme.headlineSmall
                // TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFF78350F)
                // ),
                ),
            IconButton(
              icon: Icon(Icons.volume_up, color: colorScheme.secondary),
              onPressed: () => tts.speak("${card.number}"),
            ),
          ],
        ),
        const Divider(
          height: 24,
          indent: 30.0,
          endIndent: 30.0,
        ),

        // Montessori Ten-Frame Grid
        TenFrameWidget(
          count: card.number,
          countedDots: countedDots,
          onDotTapped: onDotTapped,
        ),

        Text('Counted: ${countedDots.length} / ${card.number}',
            style: textTheme.titleMedium
            // style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: Color(0xFF047857),
            //     fontSize: 14),
            ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onAdvance,
            icon: const Icon(Icons.check_circle),
            label: const Text(
              'It Matches! Next Card   ⭐',
              // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
            style: ElevatedButton.styleFrom(
              // backgroundColor: const Color(0xFF10B981),
              foregroundColor: colorScheme.onSurface,
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
