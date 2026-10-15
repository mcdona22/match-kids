import 'package:flutter/foundation.dart';

@immutable
class ParentSettings {
  final int upperLimit;
  final int lowerLimit;
  final int stackSize;
  final int intervalSeconds;
  final bool soundEnabled;
  final bool speechEnabled;

  const ParentSettings({
    this.upperLimit = 10,
    this.lowerLimit = 1,
    this.stackSize = 10,
    this.intervalSeconds = 3,
    this.soundEnabled = true,
    this.speechEnabled = true,
  });

  ParentSettings copyWith({
    int? upperLimit,
    int? lowerLimit,
    int? stackSize,
    int? intervalSeconds,
    bool? soundEnabled,
    bool? speechEnabled,
  }) {
    return ParentSettings(
      upperLimit: upperLimit ?? this.upperLimit,
      lowerLimit: lowerLimit ?? this.lowerLimit,
      stackSize: stackSize ?? this.stackSize,
      intervalSeconds: intervalSeconds ?? this.intervalSeconds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      speechEnabled: speechEnabled ?? this.speechEnabled,
    );
  }
}
