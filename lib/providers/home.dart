import 'dart:developer';

import 'package:flutter/material.dart';

class Home with ChangeNotifier {
  int workoutSec = 20;
  int workoutMin = 0;
  int prepSec = 10;
  int prepMin = 0;
  int restSec = 10;
  int restMin = 0;
  int totalSec = 100;
  int totalWorkout = 3;
  int currentWorkoutStage = 1;

  bool isWorkoutPaused = false;
  bool isRestComplete = false;
  bool isPrepComplete = true;
  bool isWorkComplete = false;

  void changeIsWorkoutPaused(bool value) {
    isWorkoutPaused = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeAllValues() {
    isRestComplete = false;
    isPrepComplete = false;
    isWorkComplete = false;
    currentWorkoutStage = 1;
    updateTotalSec();
    notifyListeners();
  }

  void changeIsRestComplete(bool value) {
    isRestComplete = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeIsPrepComplete(bool value) {
    isPrepComplete = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeIsWorkoutComplete(bool value) {
    isWorkComplete = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeCurrentWorkStage() {
    currentWorkoutStage++;
    updateTotalSec();
    notifyListeners();
  }

  void changeWorkoutSec(int value) {
    workoutSec = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeTotalWorkout(int value) {
    totalWorkout = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeWorkoutMin(int value) {
    workoutMin = value;
    updateTotalSec();
    notifyListeners();
  }

  void changePrepSec(int value) {
    prepSec = value;
    updateTotalSec();
    notifyListeners();
  }

  void changePrepMin(int value) {
    prepMin = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeRestSec(int value) {
    restSec = value;
    updateTotalSec();
    notifyListeners();
  }

  void changeRestMin(int value) {
    restMin = value;
    updateTotalSec();
    notifyListeners();
  }

  void updateTotalSec() {
    totalSec = totalWorkout *
            (workoutSec + (workoutMin * 60) + restSec + (restMin * 60)) +
        prepSec +
        (prepMin * 60);

    notifyListeners();
  }

  void resetValues() {
    workoutSec = 0;
    workoutMin = 0;
    prepSec = 0;
    prepMin = 0;
    restSec = 0;
    restMin = 0;
    updateTotalSec();
    notifyListeners();
  }
}
