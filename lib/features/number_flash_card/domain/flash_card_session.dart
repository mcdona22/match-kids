import 'package:freezed_annotation/freezed_annotation.dart';

part 'flash_card_session.freezed.dart';

@freezed
abstract class FlashCardSession with _$FlashCardSession {
  const FlashCardSession._();

  const factory FlashCardSession(
      {@Default(10) int cardCount,
      @Default(4000) int timeOut,
      @Default(5) int maxCardValue,
      required List<int> cardValues,
      required int currentIndex}) = _FlashCardSession;
}
