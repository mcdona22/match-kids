import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/flash_card.dart';
import '../providers/tts_provider.dart';
import 'ten_frame_widget.dart';

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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade500,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${card.number}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const Text(
              'Touch dots to count!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.amber),
              onPressed: () => tts.speak("${card.number}"),
            ),
          ],
        ),
        const Divider(height: 24),

        // Montessori Ten-Frame Grid
        TenFrameWidget(
          count: card.number,
          countedDots: countedDots,
          onDotTapped: onDotTapped,
        ),

        const SizedBox(height: 12),
        Text(
          'Counted: ${countedDots.length} / ${card.number}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF047857), fontSize: 14),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onAdvance,
            icon: const Icon(Icons.check_circle),
            label: const Text('It Matches! Next Card ⭐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
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
