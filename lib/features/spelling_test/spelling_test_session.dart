import 'package:freezed_annotation/freezed_annotation.dart';

part 'spelling_test_sesson.freezed.dart';

@freezed
abstract class SpellingTestSession with _$SpellingTestSession {
  const SpellingTestSession._();

  const factory SpellingTestSession({
    required List<String> words,
    @Default([]) List<String> selectedWords,
  }) = _SpellingTestSession;
}
