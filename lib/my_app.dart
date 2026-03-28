import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/core/theme/app_theme.dart';
import 'package:stop_watch/core/theme/theme_ext.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/screen/home_screen.dart';
import 'package:upgrader/upgrader.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Home()),
      ],
      child: UpgradeAlert(
        barrierDismissible: false,
        dialogStyle: UpgradeDialogStyle.cupertino,
        showReleaseNotes: true,
        child: MaterialApp(
          color: context.bgBase,
          debugShowCheckedModeBanner: false,
          title: 'SweatClock',
          // theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          // themeMode: ThemeMode.system,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
