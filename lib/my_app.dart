import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch/core/theme/app_theme.dart';
import 'package:stop_watch/providers/home.dart';
import 'package:stop_watch/providers/settings_provider.dart';
import 'package:stop_watch/screen/home_screen.dart';
import 'package:upgrader/upgrader.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Home()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844), // your design frame size (iPhone 14)

        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SweatClock',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              builder: (context, child) => UpgradeAlert(
                barrierDismissible: false,
                dialogStyle: UpgradeDialogStyle.cupertino,
                showReleaseNotes: true,
                child: child!,
              ),
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
