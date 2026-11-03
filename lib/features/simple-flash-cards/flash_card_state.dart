import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_card_state.freezed.dart';
part 'flash_card_state.g.dart';

@freezed
abstract class FlashCardState with _$FlashCardState {
  const FlashCardState._();

  const factory FlashCardState({
    required int cardCount,
    required int highestInt,
    @Default(false) bool testMode,
    @Default(0) int currentCardIndex,
    @Default([]) List<int> cardDeck,
  }) = _FlashCardState;

  factory FlashCardState.fromJson(Map<String, dynamic> json) =>
      _$FlashCardStateFromJson(json);
}
