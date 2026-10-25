import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/presentation/centred_constrained_widget.dart';
import 'package:little_star_flashcards/core/presentation/hero_with_graphic_view.dart';
import 'package:little_star_flashcards/core/presentation/screen_subheading.dart';
import 'package:little_star_flashcards/core/presentation/screen_title.dart';
import 'package:little_star_flashcards/core/presentation/screen_utils.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/core/ui/screen_names.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/active_session_view.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/flash_screen_controller.dart';
import 'package:little_star_flashcards/features/simple-flash-cards/presentation/session_summary.dart';
import 'package:loggy/loggy.dart';

class FlashCardsScreen extends HookConsumerWidget with UiLoggy {
  const FlashCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showGraphic =
        MediaQuery.sizeOf(context).height >= UiDimensions.smallHeight;
    final state = ref.watch(flashScreenControllerProvider);
    loggy.debug('Current flash card session state: $state');

    return Scaffold(
      appBar: ScreenUtils.createAppBar(
        context,
        const ScreenTitle(label: flashCardScreenTitle),
        actions: const [
          ToggleThemModeButton(),
        ],
      ),
      body: CentredConstrainedWidget(
        maxWidth: 800.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            spacing: UiDimensions.lg,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeroWithGraphicView(
                showGraphic: showGraphic,
                graphicPath: 'assets/images/numbers.jpg',
                heroTag: '$flashCardScreenTitle-hero',
              ),
              if (state.testMode)
                Expanded(child: const ActiveSessionView())
              else
                Column(
                  spacing: UiDimensions.lg,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenSubheading(subtitle: 'Session Details'),
                    SessionSummary(state: state)
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashCardActiveSessionControls extends HookConsumerWidget with UiLoggy {
  const FlashCardActiveSessionControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(flashScreenControllerProvider.notifier);
    final session = ref.watch(flashScreenControllerProvider);
    return Row(
      spacing: UiDimensions.largeGap,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed:
              session.currentCardIndex > 0 ? controller.decrementIndex : null,
          icon: const Icon(
            Icons.fast_rewind,
            size: UiDimensions.iconButtonSize,
          ),
        ),
        Expanded(
          child: SizedBox(
              height: UiDimensions.buttonHeight,
              child: FilledButton(
                  onPressed: controller.stopTest, child: const Text('Finish'))),
        ),
        IconButton(
          onPressed: session.currentCardIndex < session.cardCount - 1
              ? controller.incrementIndex
              : null,
          icon: const Icon(
            Icons.fast_forward,
            size: UiDimensions.iconButtonSize,
          ),
        ),
      ],
    );
  }
}
