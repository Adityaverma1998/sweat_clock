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

  late Home homeProvider;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeProvider = Provider.of<Home>(context, listen: true);
    log('homeProvider is accessible: ${homeProvider.isWorkoutPaused}');
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) {
      return;
    }

    log("check start time here ${homeProvider.isWorkoutPaused}");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!homeProvider.isWorkoutPaused) {
        _ticker();
      } else {
        if (player.state == PlayerState.playing) {
          player.stop();
        }
        _timer?.cancel();
        if (_animationController.isAnimating) {
          _animationController.stop();
          _animationController.reset();
        }
      }
    });
  }

  void _ticker() async {
    if (currentSec >= 1) {
      setState(() {
        currentSec--;
      });

      if (currentSec <= 3) {
        if (homeProvider.isWorkComplete || homeProvider.isRestComplete) {
          await player.play(AssetSource('audios/go.mp3'));
        } else if(homeProvider.isRestComplete){
          await player.play(AssetSource('audios/rest.mp3'));
        }
        _animationController.forward();
        _animationController.repeat(reverse: true);
      }
    } else {
      _handleWorkoutCompletion();
    }
  }

  void _handleWorkoutCompletion() {
    if (homeProvider.currentWorkoutStage > homeProvider.totalWorkout) {
      homeProvider.changeAllValues();
    } else {
      if (widget.workoutType == 'Ready') {
        homeProvider.changeIsWorkoutComplete(true);
        homeProvider.changeIsPrepComplete(false);
      } else if (widget.workoutType == 'Work') {
        if (homeProvider.totalWorkout == homeProvider.currentWorkoutStage) {
          homeProvider.changeIsRestComplete(false);
          homeProvider.changeCurrentWorkStage();
        } else {
          homeProvider.changeIsRestComplete(true);
          homeProvider.changeIsWorkoutComplete(false);
          homeProvider.changeCurrentWorkStage();
        }
      } else if (widget.workoutType == 'Rest') {
        homeProvider.changeIsWorkoutComplete(true);
        homeProvider.changeIsRestComplete(false);
      }
    }

    _timer?.cancel();
    if (_animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_animationController.isAnimating) {
      _animationController.stop();
      _animationController.dispose();
    }
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
