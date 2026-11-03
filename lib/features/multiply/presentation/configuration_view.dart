import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class ConfigurationView extends HookConsumerWidget with UiLoggy {
  const ConfigurationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(child: Text('Configuration View'));
  }
}
