import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch/my_app.dart';
import 'package:stop_watch/presentation/views/home/home_screen.dart';
import 'package:stop_watch/presentation/views/standalone_timer/standalone_timer_screen.dart';

void main() {
  testWidgets('App loads cleanly directly to HomeScreen with workout timer and presets', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();

    // Verify MyApp is mounted and HomeScreen is rendered
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify workout configuration is displayed
    expect(find.text('SweatClock'), findsOneWidget);
    expect(find.text('START WORKOUT'), findsOneWidget);
    expect(find.text('HIIT 40/20'), findsOneWidget);
    expect(find.text('Boxing'), findsOneWidget);
  });

  testWidgets('Navigating to StandaloneTimerScreen shows Countdown and Stopwatch', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();

    // Tap timer button in header
    await tester.tap(find.byIcon(Icons.timer_outlined));
    await tester.pumpAndSettle();

    // StandaloneTimerScreen is rendered
    expect(find.byType(StandaloneTimerScreen), findsOneWidget);
    expect(find.text('COUNTDOWN'), findsOneWidget);
    expect(find.text('STOPWATCH'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);

    // Switch to STOPWATCH
    await tester.tap(find.text('STOPWATCH'));
    await tester.pumpAndSettle();
    expect(find.text('00:00'), findsOneWidget);

    // Switch back to COUNTDOWN
    await tester.tap(find.text('COUNTDOWN'));
    await tester.pumpAndSettle();
    expect(find.text('10:00'), findsOneWidget);
  });

  testWidgets('Standalone timer controls work smoothly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();

    // Open timer screen
    await tester.tap(find.byIcon(Icons.timer_outlined));
    await tester.pumpAndSettle();

    // Tap START
    await tester.tap(find.text('START'));
    await tester.pump();

    // Controls update: PAUSE and RESET
    expect(find.text('PAUSE'), findsOneWidget);
    expect(find.text('RESET'), findsOneWidget);

    // Tap PAUSE
    await tester.tap(find.text('PAUSE'));
    await tester.pump();
    expect(find.text('RESUME'), findsOneWidget);
    expect(find.text('RESET'), findsOneWidget);

    // Tap RESET
    await tester.tap(find.text('RESET'));
    await tester.pump();
    expect(find.text('START'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
  });

  testWidgets('Duration picker opens and updates timer display', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();

    // Open timer screen
    await tester.tap(find.byIcon(Icons.timer_outlined));
    await tester.pumpAndSettle();

    // Tap on timer display
    await tester.tap(find.text('10:00'));
    await tester.pumpAndSettle();

    expect(find.text('Set Duration'), findsAtLeastNWidgets(1));
    expect(find.text('5m'), findsOneWidget);

    // Tap '5m' quick chip
    await tester.tap(find.text('5m'));
    await tester.pumpAndSettle();

    // Tap Done
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('05:00'), findsOneWidget);
  });
}
