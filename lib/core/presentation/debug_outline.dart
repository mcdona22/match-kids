import 'package:flutter/material.dart';

class DebugOutline extends StatelessWidget {
  const DebugOutline({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        child: child);
  }
}
