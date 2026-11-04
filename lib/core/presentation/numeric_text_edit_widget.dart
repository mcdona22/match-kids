import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericTextEditWidget extends StatelessWidget {
  const NumericTextEditWidget({
    required this.label,
    required this.controller,
    this.enabled = false,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextField(
      style: textTheme.headlineSmall,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: textTheme.titleLarge,
      ),
    );
  }
}
