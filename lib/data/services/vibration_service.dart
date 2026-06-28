import 'package:flutter/services.dart';

class VibrationService {
  bool _enabled = true;

  void updateEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Short tap — used for countdown ticks (3, 2, 1).
  Future<void> vibrate() async {
    if (!_enabled) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium impact — used for "Go!" when workout starts.
  Future<void> vibrateImpact() async {
    if (!_enabled) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Strong double-pulse — used when rest phase begins.
  Future<void> vibrateRestStart() async {
    if (!_enabled) return;
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 120));
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Triple celebratory pulse — used when the full workout is complete.
  Future<void> vibrateCongrats() async {
    if (!_enabled) return;
    try {
      for (int i = 0; i < 3; i++) {
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 150));
      }
    } catch (_) {}
  }
}
