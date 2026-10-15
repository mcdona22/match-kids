import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/game_provider.dart';

class CelebrationDialog extends HookConsumerWidget {
  final int cardCount;

  const CelebrationDialog({
    super.key,
    required this.cardCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: const Text(
        '🎉 Hooray! Stack Complete!',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 72, color: Colors.amber),
          const SizedBox(height: 12),
          Text('You matched all $cardCount cards!', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            '⭐ +$cardCount Stars Awarded!',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            ref.read(gameControllerProvider.notifier).generateNewStack();
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Play Next Stack!'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
