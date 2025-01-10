import 'package:flutter/material.dart';
import 'package:stop_watch/screen/home_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'SweatClock',
      home: HomeScreen(),
    );
  }
  
}