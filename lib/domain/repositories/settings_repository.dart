import '../entities/user_settings.dart';

abstract class SettingsRepository {
  Future<UserSettings> getSettings();
  Future<void> saveSettings(UserSettings settings);
  int getCountdownSeconds();
  Future<void> saveCountdownSeconds(int seconds);
  String getTimerMode();
  Future<void> saveTimerMode(String mode);
}
