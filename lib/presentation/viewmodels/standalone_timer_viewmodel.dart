import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/services/audio_service.dart';
import '../../data/services/vibration_service.dart';
import 'settings_viewmodel.dart';

enum StandaloneTimerMode {
  countdown,
  stopwatch,
}

enum StandaloneTimerStatus {
  idle,
  running,
  paused,
  completed,
}

/// Accurate timestamp-based timer engine for standalone Countdown and Stopwatch.
class StandaloneTimerViewModel with ChangeNotifier, WidgetsBindingObserver {
  final SettingsViewModel settingsViewModel;
  final AudioService audioService;
  final VibrationService vibrationService;

  StandaloneTimerMode _mode = StandaloneTimerMode.countdown;
  StandaloneTimerStatus _status = StandaloneTimerStatus.idle;

  /// Default countdown duration (10 minutes)
  Duration _configuredDuration = const Duration(minutes: 10);

  /// Timestamp when the current running segment started
  DateTime? _startTimestamp;

  /// Time accumulated in prior running segments before the last pause
  Duration _accumulatedDuration = Duration.zero;

  /// Internal ticker running at 100ms for smooth UI
  Timer? _ticker;

  /// Tracks last cued second for countdown audio/vibration feedback
  int _lastCuedSecond = -1;

  StandaloneTimerViewModel({
    required this.settingsViewModel,
    required this.audioService,
    required this.vibrationService,
  }) {
    WidgetsBinding.instance.addObserver(this);
    _loadPersistedPreferences();
  }

  void _loadPersistedPreferences() {
    final modeStr = settingsViewModel.getTimerMode();
    _mode = modeStr == 'stopwatch' ? StandaloneTimerMode.stopwatch : StandaloneTimerMode.countdown;

    final seconds = settingsViewModel.getCountdownSeconds();
    if (seconds > 0) {
      _configuredDuration = Duration(seconds: seconds);
    }
    notifyListeners();
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  StandaloneTimerMode get mode => _mode;
  StandaloneTimerStatus get status => _status;
  Duration get configuredDuration => _configuredDuration;

  bool get isIdle => _status == StandaloneTimerStatus.idle;
  bool get isRunning => _status == StandaloneTimerStatus.running;
  bool get isPaused => _status == StandaloneTimerStatus.paused;
  bool get isCompleted => _status == StandaloneTimerStatus.completed;

  /// Exact current display duration derived from wall-clock time
  Duration get currentDuration {
    if (_mode == StandaloneTimerMode.stopwatch) {
      return _stopwatchElapsed();
    } else {
      return _countdownRemaining();
    }
  }

  /// Formatted display string: MM:SS or HH:MM:SS
  String get formattedTime {
    final duration = currentDuration;
    final totalSec = duration.inSeconds;
    final hours = totalSec ~/ 3600;
    final minutes = (totalSec % 3600) ~/ 60;
    final seconds = totalSec % 60;

    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final hStr = hours.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    } else {
      return '$mStr:$sStr';
    }
  }

  // ── Timestamp-Based Engine Calculation ───────────────────────────────────

  Duration _stopwatchElapsed() {
    if (_status == StandaloneTimerStatus.running && _startTimestamp != null) {
      return _accumulatedDuration + DateTime.now().difference(_startTimestamp!);
    } else {
      return _accumulatedDuration;
    }
  }

  Duration _countdownRemaining() {
    if (_status == StandaloneTimerStatus.completed) {
      return Duration.zero;
    }

    Duration totalElapsed;
    if (_status == StandaloneTimerStatus.running && _startTimestamp != null) {
      totalElapsed = _accumulatedDuration + DateTime.now().difference(_startTimestamp!);
    } else {
      totalElapsed = _accumulatedDuration;
    }

    final remaining = _configuredDuration - totalElapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void setMode(StandaloneTimerMode newMode) {
    if (_mode == newMode) return;
    reset();
    _mode = newMode;
    settingsViewModel.saveTimerMode(newMode == StandaloneTimerMode.stopwatch ? 'stopwatch' : 'countdown');
    vibrationService.vibrate();
    notifyListeners();
  }

  void setCountdownDuration(Duration duration) {
    if (duration.inSeconds <= 0) return;
    reset();
    _configuredDuration = duration;
    settingsViewModel.saveCountdownSeconds(duration.inSeconds);
    vibrationService.vibrate();
    notifyListeners();
  }

  void start() {
    if (_status == StandaloneTimerStatus.running) return;

    if (_status == StandaloneTimerStatus.completed || _status == StandaloneTimerStatus.idle) {
      _accumulatedDuration = Duration.zero;
      _lastCuedSecond = -1;
    }

    _startTimestamp = DateTime.now();
    _status = StandaloneTimerStatus.running;

    vibrationService.vibrateAction();
    _startTicker();
    notifyListeners();
  }

  void pause() {
    if (_status != StandaloneTimerStatus.running || _startTimestamp == null) return;

    _accumulatedDuration += DateTime.now().difference(_startTimestamp!);
    _startTimestamp = null;
    _status = StandaloneTimerStatus.paused;

    _stopTicker();
    vibrationService.vibrateAction();
    notifyListeners();
  }

  void resume() {
    if (_status != StandaloneTimerStatus.paused) return;

    _startTimestamp = DateTime.now();
    _status = StandaloneTimerStatus.running;

    vibrationService.vibrateAction();
    _startTicker();
    notifyListeners();
  }

  void reset() {
    _stopTicker();
    _startTimestamp = null;
    _accumulatedDuration = Duration.zero;
    _lastCuedSecond = -1;
    _status = StandaloneTimerStatus.idle;
    vibrationService.vibrateAction();
    notifyListeners();
  }

  // ── Internal Accurate Ticker ─────────────────────────────────────────────

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_status != StandaloneTimerStatus.running) return;

      if (_mode == StandaloneTimerMode.countdown) {
        final remaining = _countdownRemaining();
        if (remaining == Duration.zero) {
          _onCountdownComplete();
          return;
        }
        final remSec = remaining.inSeconds;
        if (remSec >= 1 && remSec <= 3 && remSec != _lastCuedSecond) {
          _lastCuedSecond = remSec;
          if (settingsViewModel.soundEffects) {
            audioService.playCountdownTick(remSec);
          }
          if (settingsViewModel.vibration) {
            vibrationService.vibrate();
          }
        }
      }
      notifyListeners();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _onCountdownComplete() {
    _stopTicker();
    _startTimestamp = null;
    _accumulatedDuration = Duration.zero;
    _status = StandaloneTimerStatus.completed;

    if (settingsViewModel.soundEffects) {
      audioService.playTimerComplete();
    }
    if (settingsViewModel.vibration) {
      vibrationService.vibrateTimerComplete();
    }

    notifyListeners();
  }

  // ── App Lifecycle: Background & Foreground Synchronization ────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _status == StandaloneTimerStatus.running) {
      if (_mode == StandaloneTimerMode.countdown) {
        final remaining = _countdownRemaining();
        if (remaining == Duration.zero) {
          _onCountdownComplete();
          return;
        }
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTicker();
    super.dispose();
  }
}
