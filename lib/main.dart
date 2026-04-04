import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:stop_watch/my_app.dart';

// main.dart
void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}
