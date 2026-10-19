import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';

import '../providers/settings_provider.dart';
import '../providers/game_provider.dart';

class ParentZoneModal extends HookConsumerWidget {
  const ParentZoneModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSettings = ref.watch(settingsControllerProvider);

    // Draft values managed via useState hooks without any stateful widget
    final draftUpper = useState<int>(currentSettings.upperLimit);
    final draftStack = useState<int>(currentSettings.stackSize);
    final draftInterval = useState<int>(currentSettings.intervalSeconds);

    final upper20Count = max(1, (draftStack.value * 0.2).round());
    final found80Count = max(0, draftStack.value - upper20Count);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: UiDimensions.md,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Parent Zone ⚙️',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Text(
              'Upper Threshold (Skill Level): ${draftUpper.value}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Slider(
              value: draftUpper.value.toDouble(),
              min: 3,
              max: 30,
              divisions: 27,
              label: '${draftUpper.value}',
              onChanged: (val) {
                draftUpper.value = val.round();
              },
            ),
            Text(
              'Cards in Stack: ${draftStack.value} cards',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Wrap(
              spacing: 8,
              children: [5, 10, 15, 20].map((count) {
                final selected = draftStack.value == count;
                return ChoiceChip(
                  label: Text('$count Cards'),
                  selected: selected,
                  onSelected: (_) => draftStack.value = count,
                );
              }).toList(),
            ),
            Container(
              padding: const EdgeInsets.all(UiDimensions.md),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Text(
                'Stack Breakdown:\n• $found80Count cards (80%) Foundation range\n• $upper20Count cards (20%) Upper range\nAll cards randomised every round.',
                style: const TextStyle(fontSize: 13, color: Colors.brown),
              ),
            ),
            Text(
              'Flash Interval: ${draftInterval.value == 0 ? "Manual" : "${draftInterval.value}s"}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Wrap(
              spacing: 8,
              children: [2, 3, 5, 8, 0].map((sec) {
                final selected = draftInterval.value == sec;
                return ChoiceChip(
                  label: Text(sec == 0 ? 'Tap Only' : '${sec}s'),
                  selected: selected,
                  onSelected: (_) => draftInterval.value = sec,
                );
              }).toList(),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  final newSettings = currentSettings.copyWith(
                    upperLimit: draftUpper.value,
                    stackSize: draftStack.value,
                    intervalSeconds: draftInterval.value,
                  );
                  ref.read(settingsControllerProvider.notifier).updateSettings(newSettings);
                  ref.read(gameControllerProvider.notifier).generateNewStack();
                  Navigator.pop(context);
                },
                child: const Text('Save & Start New Stack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
