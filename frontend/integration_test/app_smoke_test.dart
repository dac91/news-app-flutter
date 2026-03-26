import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news_app_clean_architecture/main.dart' as app;

/// Basic integration (smoke) test that verifies the app boots
/// without crashing and the home screen renders key UI elements.
///
/// Run with:
/// ```
/// flutter test integration_test/app_smoke_test.dart
/// ```
/// Or on a device/emulator:
/// ```
/// flutter test integration_test/app_smoke_test.dart -d <device-id>
/// ```
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and shows home screen', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // The MaterialApp was mounted
    expect(find.byType(app.MyApp), findsOneWidget);

    // At least one Scaffold is present (home screen rendered)
    expect(find.byType(Scaffold), findsWidgets);

    // A bottom navigation bar is present (main navigation loaded)
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
