import 'package:freezed_annotation/freezed_annotation.dart';

part 'multiply_screen_state.freezed.dart';
part 'multiply_screen_state.g.dart';

@freezed
abstract class MultiplyScreenState with _$MultiplyScreenState {
  const MultiplyScreenState._();

  const factory MultiplyScreenState({
    required int cardCount,
    required int highestOperand,
  }) = _MultiplyScreenState;

  factory MultiplyScreenState.fromJson(Map<String, dynamic> json) =>
      _$MultiplyScreenStateFromJson(json);
}
