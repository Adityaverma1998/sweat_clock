import 'dart:developer';

import 'package:flutter/material.dart';

class Home with ChangeNotifier {
  int workoutSec = 20;
  int workoutMin = 0;
  int prepSec = 10;
  int prepMin = 0;
  int restSec = 10;
  int restMin = 0;
  int totalSec = 10;
  int totalWorkout = 3;
  int currentWorkoutStage = 1;
   
   bool isWorkoutPaused = false;

  bool isRestComplete = false;
  bool isPrepComplete = true;
  bool isWorkComplete = false;
   
  void changeIsWorkoutPaused(bool value) {
    isWorkoutPaused =value;
    notifyListeners();
  }

  void changeAllValues() {
    isRestComplete = false;
    isPrepComplete = false;
    isWorkComplete = false;
    currentWorkoutStage =1;
    notifyListeners();
  }

  void changeIsRestComplete(bool value) {
    isRestComplete =value;
    notifyListeners();
  }

  void changeIsPrepComplete(bool value) {
    isPrepComplete = value;
    notifyListeners();
  }

  void changeIsWorkoutComplete(bool value) {
    isWorkComplete =value;

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
    log("check it changeTotalWorkout call or not ${value}");
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
