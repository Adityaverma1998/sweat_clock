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
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TotalWorkoutTile(),
              const SizedBox(height: 8.0),
              const WorkoutDetails(),
              const Spacer(),
              const FooterSection(),
            ],
          ),
        ),
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

class _TotalWorkoutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final home = Provider.of<Home>(context);

    return GestureDetector(
      onTap: () => totalWorkoutBottomSheet(context),
      child: Row(
        children: [
          Text(
            "Total Workout: ${home.totalWorkout}",
            style: const TextStyle(fontSize: 24.0),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_right_rounded),
        ],
      ),
    );
  }
}

class WorkoutDetails extends StatelessWidget {
  const WorkoutDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<Home>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        WorkoutListTile(
          title: 'Prep Time',
          time: '${home.prepMin} : ${home.prepSec}',
          onTap: () => showTimePickerBottomSheet(context, 'prep'),
        ),
        const SizedBox(height: 8.0),
        WorkoutListTile(
          title: 'Workout Time',
          time: '${home.workoutMin} : ${home.workoutSec}',
          onTap: () => showTimePickerBottomSheet(context, 'workout'),
        ),
        const SizedBox(height: 8.0),
        WorkoutListTile(
          title: 'Rest Time',
          time: '${home.restMin} : ${home.restSec}',
          onTap: () => showTimePickerBottomSheet(context, 'rest'),
        ),
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Provider.of<Home>(context);

    return Column(
      children: [
        Text('Total Second to the Workout :  ${home.totalSec}'),
        SizedBox(height: 8.0,),
        CustomButton(
          name: 'Set Time',
          callback: () {
            home.changeIsPrepComplete(true);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TimerScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
