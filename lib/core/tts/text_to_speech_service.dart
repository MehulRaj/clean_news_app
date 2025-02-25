import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts;
  bool _isPlaying = false;

  TextToSpeechService() : _flutterTts = FlutterTts() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
    });
  }

  bool get isPlaying => _isPlaying;

  Future<void> speak(String text) async {
    if (_isPlaying) {
      await stop();
      return;
    }

    _isPlaying = true;
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    _isPlaying = false;
    await _flutterTts.pause();
  }

  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  Future<void> setSpeed(double speed) async {
    await _flutterTts.setSpeechRate(speed);
  }

  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  void dispose() {
    _flutterTts.stop();
  }
}
