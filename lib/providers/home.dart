import 'package:flutter/material.dart';

class Home with ChangeNotifier {
  int workoutSec = 0;
  int workoutMin = 0;
  int prepSec = 0;
  int prepMin = 0;
  int restSec = 0;
  int restMin = 0;
  int totalSec = 0;

  // Update workout seconds
  void changeWorkoutSec(int value) {
    workoutSec = value;
    _updateTotalSec();
  }

  // Update workout minutes
  void changeWorkoutMin(int value) {
    workoutMin = value;
    _updateTotalSec();
  }

  // Update preparation seconds
  void changePrepSec(int value) {
    prepSec = value;
    _updateTotalSec();
  }

  // Update preparation minutes
  void changePrepMin(int value) {
    prepMin = value;
    _updateTotalSec();
  }

  // Update rest seconds
  void changeRestSec(int value) {
    restSec = value;
    _updateTotalSec();
  }

  // Update rest minutes
  void changeRestMin(int value) {
    restMin = value;
    _updateTotalSec();
  }

  // Recalculate total seconds
  void _updateTotalSec() {
    totalSec = workoutSec +
        (workoutMin * 60) +
        prepSec +
        (prepMin * 60) +
        restSec +
        (restMin * 60);
    notifyListeners(); // Notify listeners after recalculation
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
