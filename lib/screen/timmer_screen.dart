import 'package:flutter/material.dart';
import 'package:stop_watch/widgets/workout_progress.dart';

class TimmerScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
     return Scaffold(appBar: AppBar(),body: _buildTimmer(context),);
  }


  Widget _buildTimmer(BuildContext context){
        
    return Column(children: [
          Row(children: [],),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: WorkoutProgress(sec: 10, workoutType: 'Ready', color: Colors.yellow,),
            ),

    ]);
  }
}