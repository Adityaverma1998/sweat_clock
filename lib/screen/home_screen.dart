import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/timer_screen.dart';
import 'package:stop_watch/widgets/custom_button.dart';
import 'package:stop_watch/widgets/set_time_bottom_sheet.dart';
import 'package:stop_watch/widgets/total_workout_bottom_sheet.dart';
import 'package:stop_watch/widgets/workout_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<Home>(context);

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    totalWorkoutBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      Center(
                        child: Text(
                          "Total Workout: ${home.totalWorkout}",
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                      Spacer(), // Pushes the icon to the right
                      Icon(Icons.keyboard_arrow_right_rounded),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                WorkoutListTile(
                  title: 'Prep Time',
                  time: '${home.prepMin} : ${home.prepSec} ',
                  onTap: () {
                    showTimePickerBottomSheet(context, 'prep');
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                WorkoutListTile(
                  title: 'Workout Time',
                  time: '${home.workoutMin} : ${home.workoutSec} ',
                  onTap: () {
                    showTimePickerBottomSheet(context, 'workout');
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                WorkoutListTile(
                  title: 'Rest Time',
                  time: '${home.restMin} : ${home.restSec} ',
                  onTap: () {
                    showTimePickerBottomSheet(context, 'rest');
                  },
                ),
                Column(
                  children: [
                    Text('${home.totalSec}'),
                    CustomButton(
                      name: 'Set Time',
                      callback: () {
                        home.changeIsPrepComplete(true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TimerScreen()));
                      },
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: const Text("SweatClock"),
    );
  }
}
