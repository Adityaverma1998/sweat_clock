import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/widgets/custom_button.dart';

void showTimePickerBottomSheet(BuildContext context, String timerType) {
  List<int> minValues = List.generate(61, (index) => index);
  List<int> secValues = List.generate(12, (index) => (index + 1) * 5);

  int selectedMin = minValues[0];
  int selectedSec = secValues[0];
  final home = context.read<Home>();

  if (timerType == "preparation") {
    selectedMin = home.prepMin;
    selectedSec = home.prepSec;
  } else if (timerType == "workout") {
    selectedMin = home.workoutMin;
    selectedSec = home.workoutSec;
  } else if (timerType == "rest") {
    selectedMin = home.restMin;
    selectedSec = home.restSec;
  }

  showModalBottomSheet(
    backgroundColor: const Color(0xFF202023),
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
               ' ${timerType.toUpperCase()} TIME',
                style: const TextStyle(
                    color: Color(0xFFDDDDE1),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Minutes Picker
                  Container(
                    // color: Colors.blue,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: minValues.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          tileColor: selectedMin == minValues[index]
                              ? const Color(0xFF29292D)
                              : Colors.transparent,
                          onTap: () {
                            setState(() {
                              selectedMin = minValues[index];
                            });
                            if (timerType == "preparation") {
                              home.changePrepMin(selectedMin);
                            } else if (timerType == "workout") {
                              home.changeWorkoutMin(selectedMin);
                            } else if (timerType == "rest") {
                              home.changeRestMin(selectedMin);
                            }
                          },
                          title: Text(
                              '${minValues[index]} ${selectedMin == minValues[index] ? "min" : ''}'),
                          titleTextStyle: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFFDDDDE1),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  // Seconds Picker
                  Container(
                    // color: Colors.red,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: secValues.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          tileColor: selectedSec == secValues[index]
                              ? const Color(0xFF29292D)
                              : Colors.transparent,
                          onTap: () {
                            setState(() {
                              selectedSec = secValues[index];
                            });
                            final home = context.read<Home>();
                            if (timerType == "preparation") {
                              home.changePrepSec(selectedSec);
                            } else if (timerType == "workout") {
                              home.changeWorkoutSec(selectedSec);
                            } else if (timerType == "rest") {
                              home.changeRestSec(selectedSec);
                            }
                          },
                          title: Text(
                              '${secValues[index]} ${selectedSec == secValues[index] ? "sec" : ''}'),
                          titleTextStyle: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFFDDDDE1),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                    name: "Set Workout",
                    callback: () {
                      Navigator.pop(context);
                    }),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      );
    },
  );
}
