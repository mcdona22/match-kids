import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:little_star_flashcards/core/presentation/animated_collapsible_widget.dart';
import 'package:little_star_flashcards/core/presentation/centred_constrained_widget.dart';
import 'package:little_star_flashcards/core/presentation/hero_with_graphic_view.dart';
import 'package:little_star_flashcards/core/presentation/screen_title.dart';
import 'package:little_star_flashcards/core/presentation/screen_utils.dart';
import 'package:little_star_flashcards/core/theme/toggle_theme_mode_button.dart';
import 'package:little_star_flashcards/core/ui/screen_names.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';
import 'package:little_star_flashcards/features/multiply/presentation/configuration_view.dart';
import 'package:little_star_flashcards/features/multiply/presentation/performance_view.dart';
import 'package:little_star_flashcards/features/multiply/presentation/practice_session_view.dart';
import 'package:loggy/loggy.dart';

class MultiplyScreen extends HookConsumerWidget with UiLoggy {
  const MultiplyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testMode = useState<bool>(false);
    return Scaffold(
      appBar: ScreenUtils.createAppBar(
        context,
        const ScreenTitle(label: multiplyScreenTitle),
        actions: const [
          ToggleThemModeButton(),
        ],
      ),
      body: CentredConstrainedWidget(
        maxWidth: UiDimensions.centreConstrainedWidth,
        child: Column(
          spacing: UiDimensions.md,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedCollapsibleWidget(
              isVisible: !testMode.value,
              child: const HeroWithGraphicView(
                showGraphic: true,
                graphicPath: 'assets/images/multiply.webp',
                // height: screenHeight * 0.25,
                heroTag: '$multiplyScreenTitle-hero',
              ),
            ),
            AnimatedCollapsibleWidget(
              isVisible: !testMode.value,
              child: const Column(
                children: [
                  ConfigurationView(),
                  PerformanceView(),
                ],
              ),
            ),
            AnimatedCollapsibleWidget(
              isVisible: testMode.value,
              child: const PracticeSessionView(),
            ),
            TextButton(
              onPressed: () => testMode.value = !testMode.value,
              child: Text(testMode.value ? 'Restore' : 'Disappear'),
            )
          ],
        ),
      ),
    );
    return const Center(child: Text('Under Construction'));
  }
}
