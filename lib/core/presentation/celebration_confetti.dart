import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CelebrationConfetti extends HookWidget {
  const CelebrationConfetti({
    super.key,
    required this.child,
    required this.controllerNotifier,
  });

  final Widget child;
  final ValueNotifier<void Function()> controllerNotifier;

  @override
  Widget build(BuildContext context) {
    // Encapsulate lifecycle management internally
    final confettiController = useMemoized(
      () => ConfettiController(duration: const Duration(seconds: 2)),
    );

    useEffect(() {
      return confettiController.dispose;
    }, [confettiController]);

    // Bind the play trigger back to the parent's notifier reference
    useEffect(() {
      controllerNotifier.value = () => confettiController.play();
      return null;
    }, [confettiController, controllerNotifier]);

    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 50,
          ),
        ),
      ],
    );
  }
}
