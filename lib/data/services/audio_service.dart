import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  bool _enabled = true;
  String _currentLocale = 'en-US';

  /// TTS locale codes for each supported language name.
  static const Map<String, String> _ttsLocaleMap = {
    'english': 'en-US',
    'español': 'es-ES',
    'spanish': 'es-ES',
    'français': 'fr-FR',
    'french': 'fr-FR',
    'deutsch': 'de-DE',
    'german': 'de-DE',
    '日本語': 'ja-JP',
    'japanese': 'ja-JP',
    'hindi': 'hi-IN',
    'हिन्दी': 'hi-IN',
  };

  /// Localized words for countdown numbers and "Go".
  static const Map<String, Map<String, String>> _countdownWords = {
    'en-US': {'3': 'three', '2': 'two', '1': 'one', 'go': 'go'},
    'es-ES': {'3': 'tres', '2': 'dos', '1': 'uno', 'go': 'ya'},
    'fr-FR': {'3': 'trois', '2': 'deux', '1': 'un', 'go': 'partez'},
    'de-DE': {'3': 'drei', '2': 'zwei', '1': 'eins', 'go': 'los'},
    'ja-JP': {'3': 'さん', '2': 'に', '1': 'いち', 'go': 'スタート'},
    'hi-IN': {'3': 'तीन', '2': 'दो', '1': 'एक', 'go': 'चलो'},
  };

  AudioService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setSpeechRate(0.5); // Slightly slower for clarity
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setLanguage(_currentLocale);
  }

  void updateEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Call this when the user changes language in settings.
  Future<void> updateLanguage(String languageName) async {
    final localeCode = _resolveLocale(languageName);
    if (localeCode != _currentLocale) {
      _currentLocale = localeCode;
      await _tts.setLanguage(_currentLocale);
    }
  }

  /// Speak the countdown number (3, 2, 1) or "Go" using TTS
  /// in the current app language.
  Future<void> speakCountdown(String soundName) async {
    if (!_enabled) return;
    try {
      // Stop any in-progress speech first
      await _tts.stop();

      final words = _countdownWords[_currentLocale] ?? _countdownWords['en-US']!;
      final word = words[soundName] ?? soundName;

      await _tts.speak(word);
    } catch (e) {
      debugPrint("TTS error speaking countdown '$soundName': $e");
    }
  }

  /// Play a regular audio asset file (for phase transitions, congrats, etc.)
  Future<void> playAsset(String relativePath) async {
    if (!_enabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(relativePath));
    } catch (e) {
      debugPrint("AudioPlayer error playing $relativePath: $e");
    }
  }

  Future<void> playRestSound() async {
    await playAsset('audios/rest.mp3');
  }

  Future<void> playCongratSound() async {
    await playAsset('audios/congrat.mp3');
  }

  String _resolveLocale(String languageName) {
    final key = languageName.toLowerCase();
    // Special case for Español (the map literal key is lowercase)
    if (key == 'español') return 'es-ES';
    return _ttsLocaleMap[key] ?? 'en-US';
  }

  void dispose() {
    _tts.stop();
    _player.dispose();
  }
}
