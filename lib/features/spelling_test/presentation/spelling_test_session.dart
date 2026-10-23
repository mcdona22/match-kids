import 'package:freezed_annotation/freezed_annotation.dart';

part 'spelling_test_session.freezed.dart';
part 'spelling_test_session.g.dart';

@freezed
abstract class SpellingTestSession with _$SpellingTestSession {
  const SpellingTestSession._();

  const factory SpellingTestSession({
    @Default(<String>[]) List<String> words,
    @Default(<String>[]) List<String> selectedWords,
    @Default(false) bool testMode,
  }) = _SpellingTestSession;

  factory SpellingTestSession.fromJson(Map<String, dynamic> json) =>
      _$SpellingTestSessionFromJson(json);
}
