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

  /// All spoken phrases keyed by locale.
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

  Future<void> updateLanguage(String languageName) async {
    final localeCode = _resolveLocale(languageName);
    if (localeCode != _currentLocale) {
      _currentLocale = localeCode;
      await _tts.setLanguage(_currentLocale);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TICK CUE  (3, 2, 1)
  // Does NOT call stop() first — each number is short (~0.3 s) and the
  // 1-second gap between ticks is more than enough for it to finish.
  // Calling stop() here would silence the previous number mid-word.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> speakTick(String number) async {
    if (!_enabled) return;
    try {
      final words = _words[_currentLocale] ?? _words['en-US']!;
      final word = words[number] ?? number;
      await _tts.speak(word);
    } catch (e) {
      debugPrint("TTS tick error '$number': $e");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TRANSITION CUES  (Go / Rest / Congrats)
  // These follow the countdown (≥1 s after "one") so stopping first is safe
  // and ensures a clean start without any residual audio.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _speakCue(String key) async {
    if (!_enabled) return;
    try {
      await _tts.stop();
      final words = _words[_currentLocale] ?? _words['en-US']!;
      final word = words[key] ?? key;
      await _tts.speak(word);
    } catch (e) {
      debugPrint("TTS cue error '$key': $e");
    }
  }

  Future<void> speakGo() => _speakCue('go');
  Future<void> speakRest() => _speakCue('rest');
  Future<void> speakCongrats() => _speakCue('congrats');

  /// Silence any in-progress speech (used by resetTimer).
  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  /// Legacy alias kept for resetTimer's _runStartCountdown.
  Future<void> speakCountdown(String key) => _speakCue(key);

  String _resolveLocale(String languageName) {
    final key = languageName.toLowerCase();
    if (key == 'español') return 'es-ES';
    return _ttsLocaleMap[key] ?? 'en-US';
  }

  void dispose() {
    _tts.stop();
  }
}
