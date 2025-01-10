import 'package:flutter/material.dart';

class WorkoutListTile extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback onTap;
  const WorkoutListTile({super.key, required this.title, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(2.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      tileColor: Colors.black,
      onTap: onTap,
      title:  Text(
       title,
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      subtitle:  Text(
       time,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      isThreeLine: true,
    );
  }
}
