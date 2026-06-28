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
    // Configure initial phase
    _phaseDuration = prepSeconds > 0 ? prepSeconds : workoutSeconds;
    _secondsRemaining = _phaseDuration;
    _currentPhase = prepSeconds > 0 ? WorkoutPhase.prep : WorkoutPhase.workout;

    // Synchronize settings state to services
    audioService.updateEnabled(settingsViewModel.soundEffects);
    audioService.updateLanguage(settingsViewModel.language);
    vibrationService.updateEnabled(settingsViewModel.vibration);
  }

  WorkoutPhase get currentPhase => _currentPhase;
  int get currentRound => _currentRound;
  int get secondsRemaining => _secondsRemaining;
  int get phaseDuration => _phaseDuration;
  bool get isPaused => _isPaused;

  double get progress => _phaseDuration > 0 ? _secondsRemaining / _phaseDuration : 0.0;

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        _tick();
      }
    });
  }

  void _tick() {
    if (_secondsRemaining > 1) {
      _secondsRemaining--;
      _handleCountdownSoundAndVibe(_secondsRemaining);
      notifyListeners();
    } else {
      _secondsRemaining = 0;
      notifyListeners();
      _transitionToNextPhase();
    }
  }

  void _handleCountdownSoundAndVibe(int remaining) {
    // We countdown in the last 3 seconds of Prep or Rest before Workout starts
    if (_currentPhase == WorkoutPhase.prep || _currentPhase == WorkoutPhase.rest) {
      if (remaining <= 3 && remaining >= 1) {
        audioService.speakCountdown('$remaining');
        if (settingsViewModel.settings.countdownVibration) {
          vibrationService.vibrate();
        }
      }
    }
  }

  void _transitionToNextPhase() {
    if (_currentPhase == WorkoutPhase.prep) {
      // Prep finished -> Go to Workout
      _playGo();
      _currentPhase = WorkoutPhase.workout;
      _phaseDuration = workoutSeconds;
      _secondsRemaining = _phaseDuration;
      notifyListeners();
    } else if (_currentPhase == WorkoutPhase.workout) {
      // Workout finished
      if (_currentRound >= totalRounds) {
        // Last round complete -> Workout finished
        _currentPhase = WorkoutPhase.completed;
        _secondsRemaining = 0;
        _phaseDuration = 0;
        audioService.speakCongrats();
        vibrationService.vibrateCongrats();
        _timer?.cancel();
        notifyListeners();
      } else {
        // More rounds remaining -> Go to Rest
        audioService.speakRest();
        vibrationService.vibrateRestStart();
        _currentPhase = WorkoutPhase.rest;
        _phaseDuration = restSeconds;
        _secondsRemaining = _phaseDuration;
        notifyListeners();
      }
    } else if (_currentPhase == WorkoutPhase.rest) {
      // Rest finished -> Go to next round Workout
      _playGo();
      _currentRound++;
      _currentPhase = WorkoutPhase.workout;
      _phaseDuration = workoutSeconds;
      _secondsRemaining = _phaseDuration;
      notifyListeners();
    }
  }

  void _playGo() {
    audioService.speakCountdown('go');
    if (settingsViewModel.settings.countdownVibration) {
      vibrationService.vibrateImpact();
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  void skipPhase() {
    _timer?.cancel();
    _secondsRemaining = 0;
    _transitionToNextPhase();
    // Restart the tick loop after transition
    startTimer();
  }

  /// Restart the entire workout from round 1, prep phase.
  void resetTimer() {
    _timer?.cancel();
    _currentRound = 1;
    _isPaused = false;
    _currentPhase = prepSeconds > 0 ? WorkoutPhase.prep : WorkoutPhase.workout;
    _phaseDuration = prepSeconds > 0 ? prepSeconds : workoutSeconds;
    _secondsRemaining = _phaseDuration;
    notifyListeners();
    startTimer();
    // If we start directly in workout (no prep), announce Go immediately
    if (prepSeconds == 0) {
      _playGo();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
