import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';

abstract class ScreenUtils {
  ScreenUtils._();

  static PreferredSizeWidget createAppBar(
    BuildContext context,
    Widget? header, {
    double toolbarHeight = UiDimensions.defaultToolbarHeight,
    List<Widget>? actions,
  }) {
    final isHome = GoRouterState.of(context).matchedLocation == '/';
    final canPop = context.canPop();
    return AppBar(
      title: header,

      leading: (canPop || !isHome)
          ? IconButton(
              icon: const Icon(Icons.home),
              // Or Icons.arrow_back_ios for iOS style
              onPressed: () {
                // Cleans up the stack and takes the user back
                if (canPop) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            )
          : null,
      toolbarHeight: toolbarHeight,
      centerTitle: true,
      // elevation: 1.0,
      // primary: true,
      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // actions: actions,
      actions: actions ?? [],
    );
  }
}
