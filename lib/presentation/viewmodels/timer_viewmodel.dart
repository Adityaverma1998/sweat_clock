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

      // ── Countdown cue: fires at 3, 2, 1 s ────────────────────────────────
      if (_secondsRemaining >= 1 &&
          _secondsRemaining <= 3 &&
          _currentPhase != WorkoutPhase.completed &&
          _lastCuedSecond != _secondsRemaining) {
        _lastCuedSecond = _secondsRemaining;
        audioService.speakTick('$_secondsRemaining');
        if (settingsViewModel.settings.countdownVibration) {
          vibrationService.vibrate();
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
  // Each branch announces what is starting next, then updates state.
  // ─────────────────────────────────────────────────────────────────────────
  void _transitionToNextPhase() {
    _phaseStopwatch.reset();
    _phaseStopwatch.start();
    _lastCuedSecond = -1;

    if (_currentPhase == WorkoutPhase.prep) {
      // Prep → Workout
      audioService.speakGo();
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
        audioService.speakRest();
        vibrationService.vibrateRestStart();
        _currentPhase = WorkoutPhase.rest;
        _phaseDuration = restSeconds;
        _secondsRemaining = _phaseDuration;
        _isTransitioning = false;
        notifyListeners();
      }

    } else if (_currentPhase == WorkoutPhase.rest) {
      // Rest → Workout (next round)
      audioService.speakGo();
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
    _isTransitioning = false;
    _secondsRemaining = 0;
    _isTransitioning = true;
    _transitionToNextPhase();
    startTimer();
  }

  /// Restart entire workout from round 1 with an explicit 3→2→1→Go countdown.
  Future<void> resetTimer() async {
    _timer?.cancel();
    _phaseStopwatch.reset();
    _lastCuedSecond = -1;
    _isTransitioning = false;

    // Silence any leftover speech (e.g. "Rest" from a prior phase)
    await audioService.stopSpeaking();

    // Reset state
    _currentRound = 1;
    _isPaused = false;
    _currentPhase = prepSeconds > 0 ? WorkoutPhase.prep : WorkoutPhase.workout;
    _phaseDuration = prepSeconds > 0 ? prepSeconds : workoutSeconds;
    _secondsRemaining = _phaseDuration;
    notifyListeners();

    // Explicit 3 → 2 → 1 → Go before the timer starts ticking
    await _runResetCountdown();
    startTimer();
  }

  /// Plays 3, 2, 1 (one per second, properly awaited) then "Go!".
  /// Used only by resetTimer so we guarantee the full sequence is heard.
  Future<void> _runResetCountdown() async {
    for (final n in ['3', '2', '1']) {
      await audioService.speakCountdown(n);
      await Future.delayed(const Duration(seconds: 1));
    }
    audioService.speakGo();
    if (settingsViewModel.settings.countdownVibration) {
      vibrationService.vibrateImpact();
    }
    // Small pause so "Go!" finishes before the first tick fires
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phaseStopwatch.stop();
    super.dispose();
  }
}
