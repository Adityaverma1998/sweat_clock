import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/services/audio_service.dart';
import 'data/services/vibration_service.dart';
import 'domain/repositories/settings_repository.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/views/home/home_screen.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioService>(
          create: (_) => AudioService(),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<VibrationService>(
          create: (_) => VibrationService(),
        ),
        Provider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(sharedPreferences),
        ),
        ChangeNotifierProvider<SettingsViewModel>(
          create: (context) => SettingsViewModel(
            context.read<SettingsRepository>(),
          ),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        child: Consumer<SettingsViewModel>(
          builder: (context, settingsViewModel, child) {
            if (!settingsViewModel.isInitialized) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SweatClock',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: settingsViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              locale: _getLocale(settingsViewModel.language),
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
                Locale('fr'),
                Locale('de'),
                Locale('ja'),
                Locale('hi'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
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

  Locale _getLocale(String languageName) {
    switch (languageName.toLowerCase()) {
      case 'español':
      case 'spanish':
        return const Locale('es');
      case 'français':
      case 'french':
        return const Locale('fr');
      case 'deutsch':
      case 'german':
        return const Locale('de');
      case '日本語':
      case 'japanese':
        return const Locale('ja');
      case 'hindi':
      case 'हिन्दी':
        return const Locale('hi');
      case 'english':
      default:
        return const Locale('en');
    }
  }
}
