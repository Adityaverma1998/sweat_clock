import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch/my_app.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // Initialize SharedPreferences asynchronously before app startup
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  FlutterNativeSplash.remove();
  runApp(MyApp(sharedPreferences: prefs));
}
