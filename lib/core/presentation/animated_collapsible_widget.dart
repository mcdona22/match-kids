import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

class AnimatedCollapsibleWidget extends StatelessWidget with UiLoggy {
  const AnimatedCollapsibleWidget({
    required this.child,
    this.isVisible = true,
    this.duration = const Duration(milliseconds: 1200),
    super.key,
  });

  final bool isVisible;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: isVisible ? 1.0 : 0.0),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, childWidget) {
        if (value == 0.0 && !isVisible) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity: value,
          child: ClipRect(
            child: Align(
              alignment: Alignment.bottomCenter,
              heightFactor: value,
              child: childWidget,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
