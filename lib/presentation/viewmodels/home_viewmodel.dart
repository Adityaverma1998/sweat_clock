import 'package:flutter/material.dart';

enum WorkoutPresetType {
  tabata,
  hiit,
  boxing,
  emom,
  custom,
}

class WorkoutPreset {
  final WorkoutPresetType type;
  final String name;
  final String subtitle;
  final String icon;
  final int prepMinutes;
  final int prepSeconds;
  final int workoutMinutes;
  final int workoutSeconds;
  final int restMinutes;
  final int restSeconds;
  final int rounds;

  const WorkoutPreset({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.prepMinutes,
    required this.prepSeconds,
    required this.workoutMinutes,
    required this.workoutSeconds,
    required this.restMinutes,
    required this.restSeconds,
    required this.rounds,
  });
}

class HomeViewModel with ChangeNotifier {
  static const List<WorkoutPreset> presets = [
    WorkoutPreset(
      type: WorkoutPresetType.tabata,
      name: 'Tabata',
      subtitle: '20s/10s • 8 rds',
      icon: '⚡',
      prepMinutes: 0,
      prepSeconds: 10,
      workoutMinutes: 0,
      workoutSeconds: 20,
      restMinutes: 0,
      restSeconds: 10,
      rounds: 8,
    ),
    WorkoutPreset(
      type: WorkoutPresetType.hiit,
      name: 'HIIT 40/20',
      subtitle: '40s/20s • 5 rds',
      icon: '🔥',
      prepMinutes: 0,
      prepSeconds: 10,
      workoutMinutes: 0,
      workoutSeconds: 40,
      restMinutes: 0,
      restSeconds: 20,
      rounds: 5,
    ),
    WorkoutPreset(
      type: WorkoutPresetType.boxing,
      name: 'Boxing',
      subtitle: '3m/1m • 3 rds',
      icon: '🥊',
      prepMinutes: 0,
      prepSeconds: 10,
      workoutMinutes: 3,
      workoutSeconds: 0,
      restMinutes: 1,
      restSeconds: 0,
      rounds: 3,
    ),
    WorkoutPreset(
      type: WorkoutPresetType.emom,
      name: 'EMOM',
      subtitle: '50s/10s • 10 rds',
      icon: '⏱️',
      prepMinutes: 0,
      prepSeconds: 10,
      workoutMinutes: 0,
      workoutSeconds: 50,
      restMinutes: 0,
      restSeconds: 10,
      rounds: 10,
    ),
  ];

  int _prepMinutes = 0;
  int _prepSeconds = 10;
  int _workoutMinutes = 0;
  int _workoutSeconds = 20;
  int _restMinutes = 0;
  int _restSeconds = 10;
  int _totalRounds = 3;
  WorkoutPresetType _selectedPreset = WorkoutPresetType.custom;

  int get prepMinutes => _prepMinutes;
  int get prepSeconds => _prepSeconds;
  int get workoutMinutes => _workoutMinutes;
  int get workoutSeconds => _workoutSeconds;
  int get restMinutes => _restMinutes;
  int get restSeconds => _restSeconds;
  int get totalRounds => _totalRounds;
  WorkoutPresetType get selectedPreset => _selectedPreset;

  /// Accurate total duration:
  /// Prep + (totalRounds * workout) + ((totalRounds - 1) * rest)
  /// There is NO rest phase after the final round of the workout.
  int get totalSeconds {
    if (_totalRounds <= 0) return 0;
    final workSec = getWorkoutTotalSeconds();
    final restSec = getRestTotalSeconds();
    final prepSec = getPrepTotalSeconds();
    final effectiveRests = _totalRounds > 1 ? _totalRounds - 1 : 0;
    return prepSec + (_totalRounds * workSec) + (effectiveRests * restSec);
  }

  int getPrepTotalSeconds() => _prepMinutes * 60 + _prepSeconds;
  int getWorkoutTotalSeconds() => _workoutMinutes * 60 + _workoutSeconds;
  int getRestTotalSeconds() => _restMinutes * 60 + _restSeconds;

  void applyPreset(WorkoutPreset preset) {
    _prepMinutes = preset.prepMinutes;
    _prepSeconds = preset.prepSeconds;
    _workoutMinutes = preset.workoutMinutes;
    _workoutSeconds = preset.workoutSeconds;
    _restMinutes = preset.restMinutes;
    _restSeconds = preset.restSeconds;
    _totalRounds = preset.rounds;
    _selectedPreset = preset.type;
    notifyListeners();
  }

  void setPrepTime(int minutes, int seconds) {
    _prepMinutes = minutes;
    _prepSeconds = seconds;
    _selectedPreset = WorkoutPresetType.custom;
    notifyListeners();
  }

  void setWorkoutTime(int minutes, int seconds) {
    _workoutMinutes = minutes;
    _workoutSeconds = seconds;
    _selectedPreset = WorkoutPresetType.custom;
    notifyListeners();
  }

  void setRestTime(int minutes, int seconds) {
    _restMinutes = minutes;
    _restSeconds = seconds;
    _selectedPreset = WorkoutPresetType.custom;
    notifyListeners();
  }

  void setTotalRounds(int rounds) {
    _totalRounds = rounds;
    _selectedPreset = WorkoutPresetType.custom;
    notifyListeners();
  }

  void resetConfiguration() {
    _prepMinutes = 0;
    _prepSeconds = 10;
    _workoutMinutes = 0;
    _workoutSeconds = 20;
    _restMinutes = 0;
    _restSeconds = 10;
    _totalRounds = 3;
    _selectedPreset = WorkoutPresetType.custom;
    notifyListeners();
  }
}
