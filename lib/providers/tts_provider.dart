import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tts_provider.g.dart';

@riverpod
FlutterTts tts(Ref ref) {
  final tts = FlutterTts();
  tts.setLanguage("en-GB");
  tts.setSpeechRate(0.4);
  tts.setPitch(1.15);
  tts.setVoice(voice)
  return tts;
}
