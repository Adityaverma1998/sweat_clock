import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _soundEffects = true;
  bool _vibration = true;
  bool _voiceCues = true;
  bool _isDarkMode = true; // default dark mode since SweatClock defaults dark/cool dark look
  bool _keepScreenOn = false;
  String _language = 'English';

  bool get soundEffects => _soundEffects;
  bool get vibration => _vibration;
  bool get voiceCues => _voiceCues;
  bool get isDarkMode => _isDarkMode;
  bool get keepScreenOn => _keepScreenOn;
  String get language => _language;

  void toggleSoundEffects(bool value) {
    _soundEffects = value;
    notifyListeners();
  }

  void toggleVibration(bool value) {
    _vibration = value;
    notifyListeners();
  }

  void toggleVoiceCues(bool value) {
    _voiceCues = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleKeepScreenOn(bool value) {
    _keepScreenOn = value;
    notifyListeners();
  }

  void changeLanguage(String value) {
    _language = value;
    notifyListeners();
  }
}
