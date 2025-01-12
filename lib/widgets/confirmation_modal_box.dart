import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/home_screen.dart';

void showAlertDialog(BuildContext context) {
  // Access the provider with listen: false to avoid unnecessary rebuilds
  final homeProvider = Provider.of<Home>(context, listen: false);

  // Set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Ok"),
    onPressed: () {
      // Change the state through the provider
      homeProvider.changeIsPrepComplete(true);
      homeProvider.changeIsWorkoutComplete(false);
      homeProvider.changeIsRestComplete(false);

      Navigator.pop(context); // Close the dialog
      Navigator.of(context).pop(); // Go back one screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(), // Push new screen
      ));
    },
  );

  // Set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Confirmation"),
    content: const Text("Are you sure you want to stop your Training?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
