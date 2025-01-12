import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/widgets/custom_button.dart';

void showTimePickerBottomSheet(BuildContext context, String timerType) {
  List<int> minValues = List.generate(61, (index) => index);
  List<int> secValues = List.generate(13, (index) => index * 5);

  int selectedMin = minValues[0];
  int selectedSec = secValues[0];
  final home = context.read<Home>();

  if (timerType == "prep") {
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
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '$timerType Time',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Minutes Picker
                    Container(
                      // color: Colors.blue,
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: minValues.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: selectedMin == minValues[index]
                                ? Colors.grey[300]
                                : Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedMin = minValues[index];
                              });
                              if (timerType == "prep") {
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
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    // Seconds Picker
                    Container(
                      // color: Colors.red,
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: secValues.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: selectedSec == secValues[index]
                                ? Colors.grey[300]
                                : Colors.transparent,
                            onTap: () {
                              setState(() {
                                selectedSec = secValues[index];
                              });
                              final home = context.read<Home>();
                              if (timerType == "prep") {
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
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                CustomButton(name: "Set Workout", callback: (){
                    Navigator.pop(context);
                })
              ],
            ),
          );
        },
      );
    },
  );
}
