import 'package:flutter/foundation.dart';

@immutable
class FlashCardItem {
  final String id;
  final int number;
  final bool isUpperRange;

  const FlashCardItem({
    required this.id,
    required this.number,
    required this.isUpperRange,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCardItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          number == other.number &&
          isUpperRange == other.isUpperRange;

  @override
  int get hashCode => id.hashCode ^ number.hashCode ^ isUpperRange.hashCode;
}
