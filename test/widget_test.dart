import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch/my_app.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Set up mock SharedPreferences for test context
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(sharedPreferences: prefs));

    // Verify MyApp is mounted in tree
    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets('CoffeeScreen renders cleanly without layout exceptions', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();

    // Verify app runs and widgets can settle without layout errors
    expect(find.byType(MyApp), findsOneWidget);
  });
}
