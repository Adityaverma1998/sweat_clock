import 'package:flutter/material.dart';

class WorkoutListTile extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback onTap;
  const WorkoutListTile({super.key, required this.title, required this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(2.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        tileColor: Color(0xFF303134),
        onTap: onTap,
        title:  Text(
         title,
          style: const TextStyle(
            fontSize: 18.0,
            color: Color(0xFFDDDDE1),
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        subtitle:  Text(
         time,
          style: const TextStyle(
            fontSize: 16.0,
            color: Color(0xFF81809E),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        isThreeLine: true,
      ),
    );
  }
}
