import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';

class WorkoutProgress extends StatefulWidget {
  final int sec;
  final String workoutType;
  final Color color;

  const WorkoutProgress({
    super.key,
    required this.sec,
    required this.workoutType,
    required this.color,
  });

  @override
  _WorkoutProgressState createState() => _WorkoutProgressState();
}

class _WorkoutProgressState extends State<WorkoutProgress>
    with SingleTickerProviderStateMixin {
  late AudioPlayer player;
  late int currentSec;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    currentSec = widget.sec;
    player = AudioPlayer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (currentSec > 1) {
        setState(() {
          currentSec--;
        });

        if (currentSec <= 3) {
          await player.play(AssetSource('audios/count_down.mp3'));
          _animationController.forward();
          _animationController.repeat(reverse: true);
        }
      } else {
        _handleWorkoutCompletion();
      }
    });
  }

  void _handleWorkoutCompletion() {
    final home = Provider.of<Home>(context, listen: false);
    log("check value ${home.currentWorkoutStage}   ::   ${home.totalWorkout}  :: ${home.currentWorkoutStage != home.totalWorkout} ");
    if (home.currentWorkoutStage > home.totalWorkout) {
      home.changeAllValues();
    } else {
      if (widget.workoutType == 'Ready') {
        home.changeIsWorkoutComplete();
        home.changeIsPrepComplete();
      } else if (widget.workoutType == 'Work') {
        home.changeIsRestComplete();
        home.changeIsWorkoutComplete();
        home.changeCurrentWorkStage();
      } else if (widget.workoutType == 'Rest') {
        home.changeIsWorkoutComplete();
        home.changeIsRestComplete();
      }
    }

    _timer?.cancel();
    _animationController.stop();
    _animationController.reset();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 300,
      width: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
                currentSec > 3 ? widget.color : Colors.red),
            backgroundColor: Colors.white,
            strokeWidth: 12,
            value: currentSec > 0 ? currentSec / widget.sec : 0,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.workoutType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: currentSec <= 3 ? _bounceAnimation.value : 1.0,
                      child: Text(
                        '$currentSec',
                        style: TextStyle(
                          fontSize: 150,
                          fontWeight: FontWeight.bold,
                          color: currentSec > 3 ? Colors.black : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
