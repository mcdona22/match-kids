import 'package:flutter/material.dart';

class HeroWithGraphicView extends StatelessWidget {
  const HeroWithGraphicView({
    required this.graphicPath,
    required this.showGraphic,
    this.heroTag,
    super.key,
  });

  final String graphicPath;
  final String? heroTag;

  final bool showGraphic;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag ?? '',
      // tag: '$spellingScreenTitle-hero',
      child: showGraphic
          ? SizedBox(
              height: 300.0,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/numbers.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
