import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../models/user_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  static const String _keySoundEffects = 'sound_effects';
  static const String _keyVibration = 'vibration';
  static const String _keyVoiceCues = 'voice_cues';
  static const String _keyIsDarkMode = 'is_dark_mode';
  static const String _keyKeepScreenOn = 'keep_screen_on';
  static const String _keyCountdownVibration = 'countdown_vibration';
  static const String _keyLanguage = 'language';

  @override
  Future<UserSettings> getSettings() async {
    return UserSettingsModel(
      soundEffects: _prefs.getBool(_keySoundEffects) ?? true,
      vibration: _prefs.getBool(_keyVibration) ?? true,
      voiceCues: _prefs.getBool(_keyVoiceCues) ?? true,
      isDarkMode: _prefs.getBool(_keyIsDarkMode) ?? true,
      keepScreenOn: _prefs.getBool(_keyKeepScreenOn) ?? false,
      countdownVibration: _prefs.getBool(_keyCountdownVibration) ?? true,
      language: _prefs.getString(_keyLanguage) ?? 'English',
    );
  }

  @override
  Future<void> saveSettings(UserSettings settings) async {
    await _prefs.setBool(_keySoundEffects, settings.soundEffects);
    await _prefs.setBool(_keyVibration, settings.vibration);
    await _prefs.setBool(_keyVoiceCues, settings.voiceCues);
    await _prefs.setBool(_keyIsDarkMode, settings.isDarkMode);
    await _prefs.setBool(_keyKeepScreenOn, settings.keepScreenOn);
    await _prefs.setBool(_keyCountdownVibration, settings.countdownVibration);
    await _prefs.setString(_keyLanguage, settings.language);
  }
}
