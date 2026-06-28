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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) _tick();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CORE TICK
  // Decrement → fire countdown cue if ≤ 3 remaining → trigger transition at 0
  // ─────────────────────────────────────────────────────────────────────────
  void _tick() {
    if (_secondsRemaining > 0) {
      _secondsRemaining--;
      notifyListeners();

      // ── Countdown cue: fires during last 3 s of EVERY active phase ──────
      // Condition: remaining is 3, 2, or 1 (i.e. the phase is about to end).
      if (_secondsRemaining >= 1 &&
          _secondsRemaining <= 3 &&
          _currentPhase != WorkoutPhase.completed) {
        audioService.speakTick('$_secondsRemaining');
        if (settingsViewModel.settings.countdownVibration) {
          vibrationService.vibrate();
        }
      }
    }

    // ── Transition: only once per phase end ──────────────────────────────
    if (_secondsRemaining == 0 && !_isTransitioning) {
      _isTransitioning = true;
      _transitionToNextPhase();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PHASE TRANSITIONS
  // Each branch announces what is starting next, then updates state.
  // ─────────────────────────────────────────────────────────────────────────
  void _transitionToNextPhase() {
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
    notifyListeners();
  }

  /// Skip current phase immediately (no countdown — it's a manual action).
  void skipPhase() {
    _timer?.cancel();
    _isTransitioning = false;
    _secondsRemaining = 0;
    _isTransitioning = true;
    _transitionToNextPhase();
    startTimer();
  }

  /// Restart entire workout from round 1 with an explicit 3→2→1→Go countdown.
  Future<void> resetTimer() async {
    _timer?.cancel();
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
    super.dispose();
  }
}
