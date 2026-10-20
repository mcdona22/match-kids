import 'package:freezed_annotation/freezed_annotation.dart';

part 'spelling_test_session.freezed.dart';

@freezed
abstract class SpellingTestSession with _$SpellingTestSession {
  const SpellingTestSession._();

  const factory SpellingTestSession({
    required List<String> words,
    @Default(<String>[]) List<String> selectedWords,
  }) = _SpellingTestSession;
}
