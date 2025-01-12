import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/home_screen.dart';

void showAlertDialog(BuildContext context) {
  final homeProvider = Provider.of<Home>(context, listen: false);

  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Ok"),
    onPressed: () {
      homeProvider.changeIsPrepComplete(true);
      homeProvider.changeIsWorkoutComplete(false);
      homeProvider.changeIsRestComplete(false);

      Navigator.pop(context); 
      Navigator.of(context).pop(); 
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(), 
      ));
    },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: const Color(0xFF202023),
    title: const Text("Confirmation",style: TextStyle(
      fontSize: 20,fontWeight:FontWeight.bold,
      color:Color(0xFFDDDDE1)
    ),),
    content: const Text("Are you sure you want to stop your Training?",
    style: TextStyle(
      fontSize: 20,fontWeight:FontWeight.w400,
      color:Color(0xFFDDDDE1)
    ),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
