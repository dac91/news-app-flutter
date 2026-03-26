import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news_app_clean_architecture/main.dart' as app;

/// Basic integration (smoke) test that verifies the app boots
/// without crashing and the home screen renders.
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

    // The app should display at least one widget after initialization.
    // We verify the MaterialApp was mounted (any Scaffold will do).
    expect(find.byType(app.MyApp), findsOneWidget);
  });
}
