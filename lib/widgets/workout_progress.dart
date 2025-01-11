import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorkoutProgress extends StatefulWidget {
  final int sec;
  final String workoutType;
  final Color color;
  const WorkoutProgress(
      {super.key,
      required this.sec,
      required this.workoutType,
      required this.color});

   @override
   _WorkoutProgressState createState() => _WorkoutProgressState();
}

 class _WorkoutProgressState extends State<WorkoutProgress>{
  late AudioPlayer player;

  late int currentSec;
  late Timer _timer;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    currentSec = widget.sec; 
        player = AudioPlayer();


    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async{
      if (currentSec > 1) {
        setState(() {
          currentSec--;
        });
        if(currentSec<=3){
          await player.play(AssetSource('audio/count_down.mp3')); 
            // await player.play(UrlSource('https://example.com/my-audio.wav'));

        }
      } else {
        _timer.cancel(); 
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    player.dispose();
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
            valueColor: AlwaysStoppedAnimation(widget.color),
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
                  widget.workoutType,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                SizedBox(height: 8), 
                AnimatedOpacity(
                  opacity: _isBlinking ? 0.0 : 1.0, // Control blinking effect
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    '$currentSec', // Display current seconds
                    style: TextStyle(
                      fontSize: 150,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
