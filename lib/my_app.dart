import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/home_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
                ChangeNotifierProvider(create: (_) => Home()),

      ],
      child: MaterialApp(
        
        title:'SweatClock',
        home: HomeScreen(),
      ),
    );
  }
  
}