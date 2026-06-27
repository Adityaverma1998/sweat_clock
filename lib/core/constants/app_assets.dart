class AppAssets {
  AppAssets._();

  static const String _imagesBase = 'assets/images';
  static const String _lottiesBase = 'assets/lotties';
  static const String _audioLegacyBase = 'assets/audios';

  // Images & SVGs
  static const String sweatLogo = '$_imagesBase/sweat_logo.png';
  static const String svgFire = '$_imagesBase/fire-svgrepo-com.svg';
  static const String svgHourglassNotDone = '$_imagesBase/hourglass-not-done-svgrepo-com.svg';
  static const String svgHourglass = '$_imagesBase/hourglass.svg';
  static const String svgYoga = '$_imagesBase/yoga-svgrepo-com.svg';

  // Lotties
  static const String lottieSuccess = '$_lottiesBase/success.json';
  static const String lottieWinner = '$_lottiesBase/winner.json';

  // Legacy Sound Effects
  static const String soundRest = '$_audioLegacyBase/rest.mp3';
  static const String soundCongrat = '$_audioLegacyBase/congrat.mp3';

  // Localized Sound Effects Helpers
  static String getLocalizedCountdownPath(String langCode, String sound) {
    return 'assets/audio/$langCode/$sound.mp3';
  }
}
