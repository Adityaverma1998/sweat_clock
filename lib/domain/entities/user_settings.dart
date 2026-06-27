class UserSettings {
  final bool soundEffects;
  final bool vibration;
  final bool voiceCues;
  final bool isDarkMode;
  final bool keepScreenOn;
  final bool countdownVibration;
  final String language;

  const UserSettings({
    required this.soundEffects,
    required this.vibration,
    required this.voiceCues,
    required this.isDarkMode,
    required this.keepScreenOn,
    required this.countdownVibration,
    required this.language,
  });

  UserSettings copyWith({
    bool? soundEffects,
    bool? vibration,
    bool? voiceCues,
    bool? isDarkMode,
    bool? keepScreenOn,
    bool? countdownVibration,
    String? language,
  }) {
    return UserSettings(
      soundEffects: soundEffects ?? this.soundEffects,
      vibration: vibration ?? this.vibration,
      voiceCues: voiceCues ?? this.voiceCues,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      countdownVibration: countdownVibration ?? this.countdownVibration,
      language: language ?? this.language,
    );
  }
}
