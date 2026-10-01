import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  bool _enabled = true;
  String _currentLocale = 'en-US';
  String _langCode = 'en';

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

  /// Asset folder code for each language
  static const Map<String, String> _langCodeMap = {
    'english': 'en',
    'en': 'en',
    'español': 'es',
    'spanish': 'es',
    'es': 'es',
    'français': 'fr',
    'french': 'fr',
    'fr': 'fr',
    'deutsch': 'de',
    'german': 'de',
    'de': 'de',
    '日本語': 'ja',
    'japanese': 'ja',
    'ja': 'ja',
    'hindi': 'hi',
    'हिन्दी': 'hi',
    'hi': 'hi',
  };

  /// Fallback spoken phrases for TTS keyed by locale.
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
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setPlayerMode(PlayerMode.lowLatency);
      await AudioPlayer.global.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.duckOthers,
          respectSilence: false,
          stayAwake: false,
        ).build(),
      );
    } catch (e) {
      debugPrint("AudioPlayer init error: $e");
    }

    try {
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.setLanguage(_currentLocale);
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  void updateEnabled(bool enabled) {
    _enabled = enabled;
  }

  Future<void> updateLanguage(String languageName) async {
    final key = languageName.toLowerCase();
    _langCode = _langCodeMap[key] ?? 'en';
    final localeCode = _ttsLocaleMap[key] ?? 'en-US';
    if (localeCode != _currentLocale) {
      _currentLocale = localeCode;
      try {
        await _tts.setLanguage(_currentLocale);
      } catch (e) {
        debugPrint("Error updating TTS language: $e");
      }
    }
  }

  Future<void> _playAsset(String path, {String? ttsKey}) async {
    if (!_enabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(path), mode: PlayerMode.lowLatency);
    } catch (e) {
      debugPrint("Asset play failed for '$path': $e. Falling back to TTS.");
      if (ttsKey != null) {
        await _speakTts(ttsKey);
      }
    }
  }

  Future<void> _speakTts(String key) async {
    if (!_enabled) return;
    try {
      await _tts.stop();
      final words = _words[_currentLocale] ?? _words['en-US']!;
      final word = words[key] ?? key;
      await _tts.speak(word);
    } catch (e) {
      debugPrint("TTS error '$key': $e");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WORKOUT CUES (Discrete per-second and phase transition cues)
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays the countdown cue for a single second (3, 2, or 1) instantly.
  /// Zero-latency trimmed audio with speech onset at ~60ms ensures perfect
  /// synchronization with each second ticking on screen.
  Future<void> playCountdownTick(int second) async {
    if (!_enabled) return;
    final key = second.toString();
    if (_langCode == 'en') {
      await _playAsset('audio/en/$key.mp3', ttsKey: key);
    } else {
      await _speakTts(key);
    }
  }

  /// Plays "Go!" immediately when the Workout phase begins.
  Future<void> playGo() async {
    if (!_enabled) return;
    if (_langCode == 'en') {
      await _playAsset('audios/go_cue.mp3', ttsKey: 'go');
    } else {
      await _speakTts('go');
    }
  }

  /// Plays "Rest!" immediately when the Rest phase begins.
  Future<void> playRest() async {
    if (!_enabled) return;
    if (_langCode == 'en') {
      await _playAsset('audios/rest_cue.mp3', ttsKey: 'rest');
    } else {
      await _speakTts('rest');
    }
  }

  /// Backwards-compatibility aliases
  Future<void> playGoCountdown() => playCountdownTick(3);
  Future<void> playRestCountdown() => playCountdownTick(3);
  Future<void> speakTick(String number) => playCountdownTick(int.tryParse(number) ?? 1);
  Future<void> speakGo() => playGo();
  Future<void> speakRest() => playRest();

  Future<void> speakCongrats() async {
    if (!_enabled) return;
    if (_langCode == 'en') {
      await _playAsset('audios/congrat.mp3', ttsKey: 'congrats');
    } else {
      await _speakTts('congrats');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GENERIC TIMER SOUNDS
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> playTimerComplete() async {
    if (!_enabled) return;
    await _playAsset('audios/congrat.mp3', ttsKey: 'congrats');
  }

  Future<void> playBeep() async {
    if (!_enabled) return;
    if (_langCode == 'en') {
      await _playAsset('audio/en/1.mp3', ttsKey: '1');
    } else {
      await _speakTts('1');
    }
  }

  Future<void> stop() => stopSpeaking();

  Future<void> stopSpeaking() async {
    try {
      await _player.stop();
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> speakCountdown(String key) => speakTick(key);

  void dispose() {
    _player.dispose();
    _tts.stop();
  }
}
