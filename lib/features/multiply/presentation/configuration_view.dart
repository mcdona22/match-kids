import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/presentation/numeric_text_edit_widget.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/multiply/multiply_screen_controller.dart';
import 'package:loggy/loggy.dart';

class ConfigurationView extends HookConsumerWidget with UiLoggy {
  const ConfigurationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multiplyScreenControllerProvider);
    const textControlWidth = 150.0;
    // TODO - this may be autocalculated or a set of numbers to choose from
    final highestOperandController =
        useTextEditingController(text: '${state.highestOperand}');

    final deckSizeController =
        useTextEditingController(text: '${state.cardCount}');
    final editMode = useState<bool>(false);

    return Column(
      spacing: UiDimensions.md,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: textControlWidth,
              child: NumericTextEditWidget(
                label: 'Largest number',
                controller: highestOperandController,
                enabled: editMode.value,
              ),
            ),
            SizedBox(
              width: textControlWidth,
              child: NumericTextEditWidget(
                label: 'Deck size',
                controller: deckSizeController,
                enabled: editMode.value,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: UiDimensions.md,
            horizontal: UiDimensions.xlGap * 2,
          ),
          child: Column(
            spacing: UiDimensions.blockGap,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  loggy.debug('saving the config');
                  saveSessionEdits(
                      deckSizeController, highestOperandController, ref);
                  editMode.value = !editMode.value;
                },
                icon: const Icon(Icons.edit),
                label: Text(editMode.value ? 'Save Details' : 'Edit Details'),
              ),
              if (!editMode.value)
                FilledButton.icon(
                  onPressed: () {},
                  label: const Text('Start Test'),
                )
            ],
          ),
        )
      ],
    );
  }

  void saveSessionEdits(TextEditingController cardCount,
      TextEditingController maxCardNumber, WidgetRef ref) {
    final state = ref.watch(multiplyScreenControllerProvider);
    final count = int.tryParse(cardCount.text) ?? state.cardCount;
    final maxOperand = int.tryParse(maxCardNumber.text) ?? state.highestOperand;

    ref
        .read(multiplyScreenControllerProvider.notifier)
        .updateSessionConfig(count, maxOperand);
  }
}
