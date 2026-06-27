import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _enabled = true;

  AudioService() {
    // Prevent latency by loading source early if needed
  }

  void updateEnabled(bool enabled) {
    _enabled = enabled;
  }

  Future<void> playAsset(String relativePath) async {
    if (!_enabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(relativePath));
    } catch (e) {
      debugPrint("AudioPlayer error playing $relativePath: $e");
    }
  }

  Future<void> playCountdown(String languageName, String soundName) async {
    final langDir = _getLangDir(languageName);
    await playAsset('audio/$langDir/$soundName.mp3');
  }

  Future<void> playRestSound() async {
    await playAsset('audios/rest.mp3');
  }

  Future<void> playCongratSound() async {
    await playAsset('audios/congrat.mp3');
  }

  String _getLangDir(String languageName) {
    switch (languageName.toLowerCase()) {
      case 'español':
      case 'spanish':
        return 'es';
      case 'français':
      case 'french':
        return 'fr';
      case 'deutsch':
      case 'german':
        return 'de';
      case '日本語':
      case 'japanese':
        return 'ja';
      case 'hindi':
      case 'हिन्दी':
        return 'hi';
      case 'english':
      default:
        return 'en';
    }
  }

  void dispose() {
    _player.dispose();
  }
}
