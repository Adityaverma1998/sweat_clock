import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/models/user_settings_model.dart';

class SettingsViewModel with ChangeNotifier {
  final SettingsRepository _repository;
  UserSettings _settings = UserSettingsModel.defaultSettings();
  bool _isInitialized = false;

  SettingsViewModel(this._repository) {
    _loadSettings();
  }

  bool get isInitialized => _isInitialized;
  UserSettings get settings => _settings;

  bool get soundEffects => _settings.soundEffects;
  bool get vibration => _settings.vibration;
  bool get voiceCues => _settings.voiceCues;
  bool get isDarkMode => _settings.isDarkMode;
  bool get keepScreenOn => _settings.keepScreenOn;
  bool get countdownVibration => _settings.countdownVibration;
  String get language => _settings.language;

  Future<void> _loadSettings() async {
    _settings = await _repository.getSettings();
    _applyWakelock(_settings.keepScreenOn);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    _settings = newSettings;
    await _repository.saveSettings(_settings);
    _applyWakelock(_settings.keepScreenOn);
    notifyListeners();
  }

  void toggleSoundEffects(bool value) {
    updateSettings(_settings.copyWith(soundEffects: value));
  }

  void toggleVibration(bool value) {
    updateSettings(_settings.copyWith(vibration: value));
  }

  void toggleVoiceCues(bool value) {
    updateSettings(_settings.copyWith(voiceCues: value));
  }

  void toggleDarkMode(bool value) {
    updateSettings(_settings.copyWith(isDarkMode: value));
  }

  void toggleKeepScreenOn(bool value) {
    updateSettings(_settings.copyWith(keepScreenOn: value));
  }

  void toggleCountdownVibration(bool value) {
    updateSettings(_settings.copyWith(countdownVibration: value));
  }

  void changeLanguage(String value) {
    updateSettings(_settings.copyWith(language: value));
  }

  void _applyWakelock(bool enable) {
    try {
      WakelockPlus.toggle(enable: enable);
    } catch (e) {
      debugPrint("Wakelock error setting state: $e");
    }
  }
}
