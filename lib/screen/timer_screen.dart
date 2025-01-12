import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/congratulation_screen.dart';
import 'package:stop_watch/widgets/confirmation_modal_box.dart';
import 'package:stop_watch/widgets/total_current_workout.dart';
import 'package:stop_watch/widgets/workout_progress.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
          backgroundColor: const Color(0xFF151515),
       title: const Text("SweatClock",
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 32,
              fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Color(0xFFDDDDE1),),
          onPressed: () {
            showAlertDialog(context);
          },
          tooltip: 'Go Back',
        ),
      ),
      body: _buildTimer(context),
    );
  }

  Widget _buildTimer(BuildContext context) {
    final home = Provider.of<Home>(context);

    // Navigate to CongratulationScreen if conditions are met
    if (!home.isPrepComplete && !home.isRestComplete && !home.isWorkComplete) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CongratulationScreen(),
        ));
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 12.0),
       
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
           TotalCurrentWorkout()
        ]),
         Spacer(),
        _buildWorkoutProgress(home),
        Spacer(),
        _buildPauseAndResume(context),
        SizedBox(height: 24.0),
      ],
    );
  }

  // Helper function for handling workout progress
  Widget _buildWorkoutProgress(Home home) {
    if (home.isPrepComplete) {
      return WorkoutProgress(
        key: const ValueKey('Ready'),
        sec: home.prepMin * 60 + home.prepSec,
        workoutType: 'Ready',
        color: Colors.yellow,
      );
    } else if (home.isRestComplete) {
      return WorkoutProgress(
        key: const ValueKey('Rest'),
        sec: home.restMin * 60 + home.restSec,
        workoutType: 'Rest',
        color: Colors.blue,
      );
    } else if (home.isWorkComplete) {
      return WorkoutProgress(
        key: const ValueKey('Work'),
        sec: home.workoutMin * 60 + home.workoutSec,
        workoutType: 'Work',
        color: const Color(0xFF7C4DFF),
      );
    } else {
      return const Text(
        'Prepare',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<Home>(
      builder: (context, homeProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Workout Count: ${homeProvider.totalWorkout}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings button press here
                // Example: Navigate to settings page
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPauseAndResume(BuildContext context) {
    return Consumer<Home>(
      builder: (context, homeProvider, child) {
        // Checking if the workout is paused
        bool isPaused = homeProvider.isWorkoutPaused;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF7C4DFF),
              ),
              child: IconButton(
                onPressed: () {
                  homeProvider.changeIsWorkoutPaused(!isPaused);
                },
                icon: isPaused
                    ? const Icon(Icons.play_arrow)
                    : const Icon(Icons.pause),
                iconSize: 50,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
