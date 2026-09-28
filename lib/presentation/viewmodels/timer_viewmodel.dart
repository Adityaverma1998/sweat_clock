import 'package:flutter/material.dart';
import 'dart:async';
import '../../data/services/audio_service.dart';
import '../../data/services/vibration_service.dart';
import 'settings_viewmodel.dart';

enum WorkoutPhase { prep, workout, rest, completed }

class TimerViewModel with ChangeNotifier {
  final int prepSeconds;
  final int workoutSeconds;
  final int restSeconds;
  final int totalRounds;

  final SettingsViewModel settingsViewModel;
  final AudioService audioService;
  final VibrationService vibrationService;

  WorkoutPhase _currentPhase = WorkoutPhase.prep;
  int _currentRound = 1;
  int _secondsRemaining = 0;
  int _phaseDuration = 0;
  bool _isPaused = false;

  /// Prevents the same phase-end from triggering a transition more than once.
  bool _isTransitioning = false;

  /// Monotonic stopwatch to eliminate any clock drift across ticks and frame drops.
  final Stopwatch _phaseStopwatch = Stopwatch();

  /// Tracks which second was cued to prevent duplicate audio/haptic calls.
  int _lastCuedSecond = -1;

  /// Tracks whether the 3-second countdown audio cue was triggered for this phase.
  bool _countdownAudioTriggered = false;

  Timer? _timer;

  TimerViewModel({
    required this.prepSeconds,
    required this.workoutSeconds,
    required this.restSeconds,
    required this.totalRounds,
    required this.settingsViewModel,
    required this.audioService,
    required this.vibrationService,
  }) {
    _phaseDuration = prepSeconds > 0 ? prepSeconds : workoutSeconds;
    _secondsRemaining = _phaseDuration;
    _currentPhase = prepSeconds > 0 ? WorkoutPhase.prep : WorkoutPhase.workout;

    audioService.updateEnabled(settingsViewModel.soundEffects);
    audioService.updateLanguage(settingsViewModel.language);
    vibrationService.updateEnabled(settingsViewModel.vibration);
  }

  WorkoutPhase get currentPhase => _currentPhase;
  int get currentRound => _currentRound;
  int get secondsRemaining => _secondsRemaining;
  int get phaseDuration => _phaseDuration;
  bool get isPaused => _isPaused;

  double get progress =>
      _phaseDuration > 0 ? _secondsRemaining / _phaseDuration : 0.0;

  void startTimer() {
    _timer?.cancel();
    if (!_phaseStopwatch.isRunning && !_isPaused) {
      _phaseStopwatch.start();
    }
    // High-resolution check: 100ms interval for perfect precision without battery drain
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_isPaused) _tick();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CORE TICK
  // Uses Stopwatch elapsed monotonic time for zero drift.
  // ─────────────────────────────────────────────────────────────────────────
  void _tick() {
    final elapsedSec = _phaseStopwatch.elapsed.inSeconds;
    final remaining = (_phaseDuration - elapsedSec).clamp(0, _phaseDuration);

    if (remaining != _secondsRemaining) {
      _secondsRemaining = remaining;
      notifyListeners();
    }

    // ── Countdown cue: fires when last 3 seconds remain (3, 2, 1) ────────
    if (_secondsRemaining >= 1 &&
        _secondsRemaining <= 3 &&
        _currentPhase != WorkoutPhase.completed) {

      // 1. Trigger the continuous "3, 2, 1, Go!" or "3, 2, 1, Rest!" audio cue once
      if (!_countdownAudioTriggered && _phaseDuration >= 3) {
        _countdownAudioTriggered = true;
        if (_currentPhase == WorkoutPhase.prep || _currentPhase == WorkoutPhase.rest) {
          // Transitioning to Workout → plays "3, 2, 1, Go!"
          audioService.playGoCountdown();
        } else if (_currentPhase == WorkoutPhase.workout) {
          if (_currentRound < totalRounds) {
            // Transitioning to Rest → plays "3, 2, 1, Rest!"
            audioService.playRestCountdown();
          } else {
            // Final round ending → next is congrats
            audioService.speakTick('$_secondsRemaining');
          }
        }
      }

      // 2. Fire haptic tick on each countdown second (3, 2, 1)
      if (_lastCuedSecond != _secondsRemaining) {
        _lastCuedSecond = _secondsRemaining;
        if (settingsViewModel.settings.countdownVibration) {
          vibrationService.vibrate();
        }
        // In final workout round, speak tick for 2 and 1 as well
        if (_currentPhase == WorkoutPhase.workout &&
            _currentRound >= totalRounds &&
            _secondsRemaining < 3) {
          audioService.speakTick('$_secondsRemaining');
        }
      }
    }

    // ── Transition: only once per phase end ──────────────────────────────
    if (remaining == 0 && !_isTransitioning) {
      _isTransitioning = true;
      _transitionToNextPhase();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PHASE TRANSITIONS
  // ─────────────────────────────────────────────────────────────────────────
  void _transitionToNextPhase() {
    _phaseStopwatch.reset();
    _phaseStopwatch.start();
    _lastCuedSecond = -1;
    _countdownAudioTriggered = false;

    if (_currentPhase == WorkoutPhase.prep) {
      // Prep → Workout
      // If prep was shorter than 3s, playGoCountdown wasn't triggered, so speakGo now
      if (prepSeconds < 3) {
        audioService.speakGo();
      }
      if (settingsViewModel.settings.countdownVibration) {
        vibrationService.vibrateImpact();
      }
      _currentPhase = WorkoutPhase.workout;
      _phaseDuration = workoutSeconds;
      _secondsRemaining = _phaseDuration;
      _isTransitioning = false;
      notifyListeners();

    } else if (_currentPhase == WorkoutPhase.workout) {
      if (_currentRound >= totalRounds) {
        // Last round → Completed
        _currentPhase = WorkoutPhase.completed;
        _secondsRemaining = 0;
        _phaseDuration = 0;
        _phaseStopwatch.stop();
        audioService.speakCongrats();
        vibrationService.vibrateCongrats();
        _timer?.cancel();
        _isTransitioning = false;
        notifyListeners();
      } else {
        // More rounds → Rest
        if (workoutSeconds < 3) {
          audioService.speakRest();
        }
        vibrationService.vibrateRestStart();
        _currentPhase = WorkoutPhase.rest;
        _phaseDuration = restSeconds;
        _secondsRemaining = _phaseDuration;
        _isTransitioning = false;
        notifyListeners();
      }

    } else if (_currentPhase == WorkoutPhase.rest) {
      // Rest → Workout (next round)
      if (restSeconds < 3) {
        audioService.speakGo();
      }
      if (settingsViewModel.settings.countdownVibration) {
        vibrationService.vibrateImpact();
      }
      _currentRound++;
      _currentPhase = WorkoutPhase.workout;
      _phaseDuration = workoutSeconds;
      _secondsRemaining = _phaseDuration;
      _isTransitioning = false;
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CONTROLS
  // ─────────────────────────────────────────────────────────────────────────
  void togglePause() {
    _isPaused = !_isPaused;
    if (_isPaused) {
      _phaseStopwatch.stop();
      audioService.stopSpeaking();
    } else {
      _phaseStopwatch.start();
    }
    notifyListeners();
  }

  /// Skip current phase immediately (no countdown — it's a manual action).
  void skipPhase() {
    _timer?.cancel();
    _phaseStopwatch.reset();
    _lastCuedSecond = -1;
    _countdownAudioTriggered = false;
    audioService.stopSpeaking();
    _isTransitioning = false;
    _secondsRemaining = 0;
    _isTransitioning = true;
    _transitionToNextPhase();
    startTimer();
  }

  /// Restart entire workout from round 1.
  Future<void> resetTimer() async {
    _timer?.cancel();
    _phaseStopwatch.reset();
    _lastCuedSecond = -1;
    _countdownAudioTriggered = false;
    _isTransitioning = false;

    // Silence any leftover speech or audio
    await audioService.stopSpeaking();

    // Reset state
    _currentRound = 1;
    _isPaused = false;
    _currentPhase = prepSeconds > 0 ? WorkoutPhase.prep : WorkoutPhase.workout;
    _phaseDuration = prepSeconds > 0 ? prepSeconds : workoutSeconds;
    _secondsRemaining = _phaseDuration;
    notifyListeners();

    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phaseStopwatch.stop();
    super.dispose();
  }
}
