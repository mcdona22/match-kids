import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/flash_card_state.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/flash_screen_controller.dart';
import 'package:loggy/loggy.dart';

class SessionSummary extends HookConsumerWidget with UiLoggy {
  const SessionSummary({required this.state, super.key});

  final FlashCardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final editMode = useState<bool>(false);
    final countController =
        useTextEditingController(text: '${state.cardCount}');
    final maxNumberController =
        useTextEditingController(text: '${state.highestInt}');

    return Column(
      spacing: UiDimensions.largeGap,
      children: [
        TextEditWidget(
            label: 'Cards in a deck',
            controller: countController,
            enabled: editMode.value),
        TextEditWidget(
            label: 'Largest number',
            controller: maxNumberController,
            enabled: editMode.value),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: UiDimensions.xl, horizontal: UiDimensions.xlGap * 2),
          child: Column(
            spacing: UiDimensions.blockGap,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                onPressed: editMode.value
                    ? () {
                        editMode.value = false;
                        saveSessionEdits(
                            countController, maxNumberController, ref);
                      }
                    : () => editMode.value = true,
                icon: Icon(editMode.value ? Icons.save : Icons.edit),
                label: Text(editMode.value ? 'Save Details' : 'Edit Details'),
              ),
              SizedBox(
                height: 60.0,
                child: FilledButton.icon(
                  onPressed: ref
                      .read(flashScreenControllerProvider.notifier)
                      .startTest,
                  label: const Text('Start Test'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void saveSessionEdits(TextEditingController cardCount,
      TextEditingController maxCardNumber, WidgetRef ref) {
    final state = ref.watch(flashScreenControllerProvider);

    final count = int.tryParse(cardCount.text) ?? state.cardCount;
    final maxCard = int.tryParse(maxCardNumber.text) ?? state.highestInt;
    ref
        .read(flashScreenControllerProvider.notifier)
        .updateSessionConfig(count, maxCard);
  }
}

class TextEditWidget extends StatelessWidget {
  const TextEditWidget(
      {required this.label,
      required this.controller,
      this.enabled = false,
      super.key});

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextField(
      style: textTheme.headlineLarge,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      enabled: enabled,
      decoration: InputDecoration(
          labelText: label, labelStyle: textTheme.headlineSmall),
    );
  }
}
