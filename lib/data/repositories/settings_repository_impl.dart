import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/user_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  static const String _keySoundEffects = 'sound_effects';
  static const String _keyVibration = 'vibration';
  static const String _keyIsDarkMode = 'is_dark_mode';
  static const String _keyKeepScreenOn = 'keep_screen_on';
  static const String _keyLanguage = 'language';
  static const String _keyCountdownSeconds = 'last_countdown_seconds';
  static const String _keyTimerMode = 'last_timer_mode';

  @override
  Future<UserSettings> getSettings() async {
    return UserSettingsModel(
      soundEffects: _prefs.getBool(_keySoundEffects) ?? true,
      vibration: _prefs.getBool(_keyVibration) ?? true,
      isDarkMode: _prefs.getBool(_keyIsDarkMode) ?? true,
      keepScreenOn: _prefs.getBool(_keyKeepScreenOn) ?? false,
      language: _prefs.getString(_keyLanguage) ?? 'English',
    );
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    await _prefs.setBool(_keySoundEffects, settings.soundEffects);
    await _prefs.setBool(_keyVibration, settings.vibration);
    await _prefs.setBool(_keyIsDarkMode, settings.isDarkMode);
    await _prefs.setBool(_keyKeepScreenOn, settings.keepScreenOn);
    await _prefs.setString(_keyLanguage, settings.language);
  }

  @override
  int getCountdownSeconds() {
    return _prefs.getInt(_keyCountdownSeconds) ?? 600; // default 10 minutes
  }

  @override
  Future<void> saveCountdownSeconds(int seconds) async {
    await _prefs.setInt(_keyCountdownSeconds, seconds);
  }

  @override
  String getTimerMode() {
    return _prefs.getString(_keyTimerMode) ?? 'countdown';
  }

  @override
  Future<void> saveTimerMode(String mode) async {
    await _prefs.setString(_keyTimerMode, mode);
  }
}
