import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class PracticeSessionView extends HookConsumerWidget with UiLoggy {
  const PracticeSessionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(child: Text('Practice Session View'));
  }
}
