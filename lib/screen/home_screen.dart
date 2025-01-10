import 'package:flutter/material.dart';
import 'package:stop_watch/widgets/set_time_bottom_sheet.dart';
import 'package:stop_watch/widgets/workout_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Center(
                      child: Text(
                        "Total Workout: 5",
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    Spacer(), // Pushes the icon to the right
                    Icon(Icons.keyboard_arrow_right_rounded),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                WorkoutListTile(
                  title: 'Prep Time',
                  time: '00:10',
                  onTap: () {
                    showTimePickerBottomSheet(context);
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                WorkoutListTile(
                  title: 'Workout Time',
                  time: '00:10',
                  onTap: () {},
                ),
                const SizedBox(
                  height: 8.0,
                ),
                WorkoutListTile(
                  title: 'Rest Time',
                  time: '00:10',
                  onTap: () {},
                ),
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
