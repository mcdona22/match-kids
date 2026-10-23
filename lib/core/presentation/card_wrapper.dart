import 'package:flutter/material.dart';
import 'package:little_star_flashcards/core/ui/ui_dimensions.dart';

class CardWrapper extends StatelessWidget {
  const CardWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(UiDimensions.cardPadding),
      child: child,
    ));
  }
}
