import '../../domain/entities/user_settings.dart';

class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    required super.soundEffects,
    required super.vibration,
    required super.voiceCues,
    required super.isDarkMode,
    required super.keepScreenOn,
    required super.countdownVibration,
    required super.language,
  });

  factory UserSettingsModel.defaultSettings() {
    return const UserSettingsModel(
      soundEffects: true,
      vibration: true,
      voiceCues: true,
      isDarkMode: true,
      keepScreenOn: false,
      countdownVibration: true,
      language: 'English',
    );
  }

  factory UserSettingsModel.fromMap(Map<String, dynamic> map) {
    return UserSettingsModel(
      soundEffects: map['soundEffects'] as bool? ?? true,
      vibration: map['vibration'] as bool? ?? true,
      voiceCues: map['voiceCues'] as bool? ?? true,
      isDarkMode: map['isDarkMode'] as bool? ?? true,
      keepScreenOn: map['keepScreenOn'] as bool? ?? false,
      countdownVibration: map['countdownVibration'] as bool? ?? true,
      language: map['language'] as String? ?? 'English',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'soundEffects': soundEffects,
      'vibration': vibration,
      'voiceCues': voiceCues,
      'isDarkMode': isDarkMode,
      'keepScreenOn': keepScreenOn,
      'countdownVibration': countdownVibration,
      'language': language,
    };
  }
}
