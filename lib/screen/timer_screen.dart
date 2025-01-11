import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/congratulation_screen.dart';
import 'package:stop_watch/widgets/workout_progress.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildTimer(context),
    );
  }

  Widget _buildTimer(BuildContext context) {
    final home = Provider.of<Home>(context);

    if (home.isPrepComplete == false && home.isRestComplete == false && home.isWorkComplete == false) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>  CongratulationScreen(),
        ));
      });
    }

    return Column(
      children: [
        Row(
          children: [
            // Add any widgets you need in this Row, e.g., a timer label or icons
          ],
        ),
        if (home.isPrepComplete)
          WorkoutProgress(
            key: ValueKey('Ready'),
            sec: 10,
            workoutType: 'Ready',
            color: Colors.yellow,
          )
        else if (home.isRestComplete)
          WorkoutProgress(
            key: ValueKey('Rest'),
            sec: 10,
            workoutType: 'Rest',
            color: Colors.blue,
          )
        else if (home.isWorkComplete)
          WorkoutProgress(
            key: ValueKey('Work'),
            sec: 10,
            workoutType: 'Work',
            color: Colors.green,
          )
        else
          const Text(
            'Prepare',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
