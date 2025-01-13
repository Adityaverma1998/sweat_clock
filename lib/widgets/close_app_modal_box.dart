import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/home_screen.dart';
import 'package:flutter/services.dart'; 

Future<bool> closeAppModalBox(BuildContext context) async {
  final homeProvider = Provider.of<Home>(context, listen: false);

  bool result = false;

  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      result = false; 
      Navigator.pop(context);
    },
  );

  // Continue button logic
  Widget continueButton = TextButton(
    child: const Text("Ok"),
    onPressed: () async {
      // Update Home provider's state
      homeProvider.changeIsPrepComplete(true);
      homeProvider.changeIsWorkoutComplete(false);
      homeProvider.changeIsRestComplete(false);

      result = true; 
      Navigator.pop(context); 

      Navigator.of(context).pop();
     

      SystemNavigator.pop(); 
    },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: const Color(0xFF202023),
    title: const Text(
      "Confirmation",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFFDDDDE1),
      ),
    ),
    content: const Text(
      "Are you sure you want to close your SweatClock?",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Color(0xFFDDDDE1),
      ),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return result; 
}