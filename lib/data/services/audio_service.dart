import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
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

  /// Localized words for countdown numbers, "Go", "Rest" and "Congratulations".
  static const Map<String, Map<String, String>> _words = {
    'en-US': {
      '3': 'three',
      '2': 'two',
      '1': 'one',
      'go': 'Go!',
      'rest': 'Rest',
      'congrats': 'Congratulations! Workout complete!',
    },
    'es-ES': {
      '3': 'tres',
      '2': 'dos',
      '1': 'uno',
      'go': '¡Ya!',
      'rest': 'Descanso',
      'congrats': '¡Felicidades! ¡Entrenamiento completado!',
    },
    'fr-FR': {
      '3': 'trois',
      '2': 'deux',
      '1': 'un',
      'go': 'Partez!',
      'rest': 'Repos',
      'congrats': 'Félicitations! Entraînement terminé!',
    },
    'de-DE': {
      '3': 'drei',
      '2': 'zwei',
      '1': 'eins',
      'go': 'Los!',
      'rest': 'Pause',
      'congrats': 'Glückwunsch! Training abgeschlossen!',
    },
    'ja-JP': {
      '3': 'さん',
      '2': 'に',
      '1': 'いち',
      'go': 'スタート！',
      'rest': '休憩',
      'congrats': 'おめでとう！トレーニング完了！',
    },
    'hi-IN': {
      '3': 'तीन',
      '2': 'दो',
      '1': 'एक',
      'go': 'चलो!',
      'rest': 'आराम',
      'congrats': 'बधाई हो! वर्कआउट पूरा हुआ!',
    },
  };

  AudioService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setSpeechRate(0.5);
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

  /// Speak a keyed phrase in the current locale.
  Future<void> _speak(String key) async {
    if (!_enabled) return;
    try {
      await _tts.stop();
      final words = _words[_currentLocale] ?? _words['en-US']!;
      final word = words[key] ?? key;
      await _tts.speak(word);
    } catch (e) {
      debugPrint("TTS error speaking '$key': $e");
    }
  }

  /// Speak the countdown number (3, 2, 1) or "Go".
  Future<void> speakCountdown(String soundName) => _speak(soundName);

  /// Announce "Rest" when entering the rest phase.
  Future<void> speakRest() => _speak('rest');

  /// Announce congratulations when the workout is complete.
  Future<void> speakCongrats() => _speak('congrats');

  String _resolveLocale(String languageName) {
    final key = languageName.toLowerCase();
    if (key == 'español') return 'es-ES';
    return _ttsLocaleMap[key] ?? 'en-US';
  }

  void dispose() {
    _tts.stop();
  }
}
