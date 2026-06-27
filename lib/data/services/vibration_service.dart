import 'package:flutter/services.dart';

class VibrationService {
  bool _enabled = true;

  void updateEnabled(bool enabled) {
    _enabled = enabled;
  }

  Future<void> vibrate() async {
    if (!_enabled) return;
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      // Fallback/Silent on unsupported devices
    }
  }

  Future<void> vibrateImpact() async {
    if (!_enabled) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Fallback/Silent on unsupported devices
    }
  }
}
