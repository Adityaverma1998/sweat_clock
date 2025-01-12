import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/widgets/custom_button.dart';

void totalWorkoutBottomSheet(BuildContext context) {
  List<int> noOfWorkout = List.generate(20, (index ) => index +1 );

  showModalBottomSheet(
    backgroundColor: const Color(0xFF202023),
    context: context,
    isScrollControlled: true,
    builder: (builder) {
      return Consumer<Home>(
        builder: (context, homeProvider, child) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  "Select Total Workout",
                  style: TextStyle(
                    color: Color(0xFFDDDDE1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: noOfWorkout.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor:
                            homeProvider.totalWorkout == noOfWorkout[index]
                                ? const Color(0xFF29292D)
                                : Colors.transparent,
                        onTap: () {
                          homeProvider.changeTotalWorkout(noOfWorkout[index]);
                        },
                        title: Text(
                          '${noOfWorkout[index]}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFFDDDDE1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  name: 'Set Number Of Workout',
                  callback: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );
    },
  );
}
