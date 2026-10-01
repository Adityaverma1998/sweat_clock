import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch/my_app.dart';
import 'package:stop_watch/presentation/views/home/home_screen.dart';
import 'package:stop_watch/presentation/viewmodels/settings_viewmodel.dart';
import 'package:stop_watch/core/localization/app_localizations.dart';

void main() {
  testWidgets('App updates language across all supported languages', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'language': 'English'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();

    // Verify English text on HomeScreen
    expect(find.text('START WORKOUT'), findsOneWidget);
    expect(find.text('WORKOUT PRESETS'), findsOneWidget);
    expect(find.text('SESSION TIMELINE'), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Ready to crush it?')),
      findsOneWidget,
    );

    final context = tester.element(find.byType(HomeScreen));
    final settingsVm = Provider.of<SettingsViewModel>(context, listen: false);

    // 1. Spanish
    settingsVm.changeLanguage('Español');
    await tester.pumpAndSettle();
    expect(find.text('INICIAR ENTRENAMIENTO'), findsOneWidget);
    expect(find.text('RUTINAS PREDETERMINADAS'), findsOneWidget);
    expect(find.text('LÍNEA DE TIEMPO'), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('¿Listo para darlo todo?')),
      findsOneWidget,
    );

    // 2. French
    settingsVm.changeLanguage('Français');
    await tester.pumpAndSettle();
    expect(find.text('DÉMARRER LA SÉANCE'), findsOneWidget);
    expect(find.text('PROGRAMMES RAPIDES'), findsOneWidget);
    expect(find.text('CHRONOLOGIE DE SÉANCE'), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Prêt à tout donner ?')),
      findsOneWidget,
    );

    // 3. German
    settingsVm.changeLanguage('Deutsch');
    await tester.pumpAndSettle();
    expect(find.text('TRAINING STARTEN'), findsOneWidget);
    expect(find.text('SCHNELLE VORLAGEN'), findsOneWidget);
    expect(find.text('TRAININGS-ABLAUF'), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Bereit alles zu geben?')),
      findsOneWidget,
    );

    // 4. Japanese
    settingsVm.changeLanguage('日本語');
    await tester.pumpAndSettle();
    expect(find.text('ワークアウトを開始'), findsOneWidget);
    expect(find.text('クイックプリセット'), findsOneWidget);
    expect(find.text('セッションタイムライン'), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('準備はいいですか？')),
      findsOneWidget,
    );

    // 5. Hindi
    settingsVm.changeLanguage('हिन्दी');
    await tester.pumpAndSettle();
    expect(find.text('वर्कआउट शुरू करें'), findsOneWidget);
    expect(find.text('क्विक प्रीसेट'), findsOneWidget);
    expect(find.text('सेशन टाइमलाइन'), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('क्या आप तैयार हैं?')),
      findsOneWidget,
    );
  });

  test('AppLocalizations has 100% key parity across all languages', () {
    const supportedLocales = ['en', 'es', 'fr', 'de', 'ja', 'hi'];

    const testKeys = [
      'title', 'settings', 'preparation', 'workout', 'rest', 'rounds',
      'total_time', 'start_workout', 'resume', 'pause', 'skip', 'reset',
      'congrats', 'done', 'countdown', 'stopwatch', 'start', 'set_duration',
      'hours', 'timer_title', 'ready_to_crush', 'lets_go', 'session_timeline',
      'choose_intensity', 'preview', 'prep_desc', 'work_desc', 'rest_desc',
      'next', 'finish', 'round_label', 'workout_complete', 'workout_complete_sub',
      'streak_banner', 'share', 'share_text', 'go_again', 'back', 'preset_boxing', 'rounds_short'
    ];

    for (final code in supportedLocales) {
      final loc = AppLocalizations(Locale(code));
      for (final key in testKeys) {
        final translated = loc.translate(key);
        expect(translated, isNotEmpty, reason: 'Key "$key" should not be empty in $code');
        expect(translated, isNot(equals(key)), reason: 'Key "$key" should be translated in $code');
      }
    }
  });
}
