import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  int _prepMinutes = 0;
  int _prepSeconds = 10;
  int _workoutMinutes = 0;
  int _workoutSeconds = 20;
  int _restMinutes = 0;
  int _restSeconds = 10;
  int _totalRounds = 3;

  int get prepMinutes => _prepMinutes;
  int get prepSeconds => _prepSeconds;
  int get workoutMinutes => _workoutMinutes;
  int get workoutSeconds => _workoutSeconds;
  int get restMinutes => _restMinutes;
  int get restSeconds => _restSeconds;
  int get totalRounds => _totalRounds;

  int get totalSeconds =>
      _totalRounds * (getWorkoutTotalSeconds() + getRestTotalSeconds()) + getPrepTotalSeconds();

  int getPrepTotalSeconds() => _prepMinutes * 60 + _prepSeconds;
  int getWorkoutTotalSeconds() => _workoutMinutes * 60 + _workoutSeconds;
  int getRestTotalSeconds() => _restMinutes * 60 + _restSeconds;

  void setPrepTime(int minutes, int seconds) {
    _prepMinutes = minutes;
    _prepSeconds = seconds;
    notifyListeners();
  }

  void setWorkoutTime(int minutes, int seconds) {
    _workoutMinutes = minutes;
    _workoutSeconds = seconds;
    notifyListeners();
  }

  void setRestTime(int minutes, int seconds) {
    _restMinutes = minutes;
    _restSeconds = seconds;
    notifyListeners();
  }

  void setTotalRounds(int rounds) {
    _totalRounds = rounds;
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
    notifyListeners();
  }
}
