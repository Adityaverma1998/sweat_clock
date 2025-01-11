import 'package:flutter/material.dart';

class Home with ChangeNotifier {
  int workoutSec = 0;
  int workoutMin = 0;
  int prepSec = 0;
  int prepMin = 0;
  int restSec = 0;
  int restMin = 0;
  int totalSec = 0;
  int totalWorkout = 1;
  int currentWorkoutStage = 1;

  bool isRestComplete = false;
  bool isPrepComplete = true;
  bool isWorkComplete = false;

  void changeAllValues() {
    isRestComplete = false;
    isPrepComplete = false;
    isWorkComplete = false;
    notifyListeners();
  }

  void changeIsRestComplete() {
    isRestComplete = !isRestComplete;
    notifyListeners();
  }

  void changeIsPrepComplete() {
    isPrepComplete = !isPrepComplete;
    notifyListeners();
  }

  void changeIsWorkoutComplete() {
    isWorkComplete = !isWorkComplete;

    notifyListeners();
  }

  void changeCurrentWorkStage() {
    currentWorkoutStage++;
    notifyListeners();
  }

  void changeWorkoutSec(int value) {
    workoutSec = value;
    _updateTotalSec();
    notifyListeners();
  }

  void changeTotalWorkout(int value) {
    totalWorkout = value;

    notifyListeners();
  }

  void changeWorkoutMin(int value) {
    workoutMin = value;
    _updateTotalSec();
    notifyListeners();
  }

  void changePrepSec(int value) {
    prepSec = value;
    _updateTotalSec();
    notifyListeners();
  }

  void changePrepMin(int value) {
    prepMin = value;
    _updateTotalSec();
    notifyListeners();
  }

  void changeRestSec(int value) {
    restSec = value;
    _updateTotalSec();
    notifyListeners();
  }

  void changeRestMin(int value) {
    restMin = value;
    _updateTotalSec();
    notifyListeners();
  }

  void _updateTotalSec() {
    totalSec = workoutSec +
        (workoutMin * 60) +
        prepSec +
        (prepMin * 60) +
        restSec +
        (restMin * 60);
    notifyListeners();
  }

  // Reset all values
  void resetValues() {
    workoutSec = 0;
    workoutMin = 0;
    prepSec = 0;
    prepMin = 0;
    restSec = 0;
    restMin = 0;
    _updateTotalSec();
  }
}
