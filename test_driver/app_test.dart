// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Check onboarding scrolling ', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final skipFinder = find.byValueKey('Skip');
    final googleLogin = find.byValueKey('googleLogin');
    
    // final buttonFinder = find.byValueKey('increment');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('scolling pages is enabled  ', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      final pagesFinder = find.byValueKey('pageContainer');
      final endFinder = find.byValueKey('thirdPage');

      await driver.scrollUntilVisible(pagesFinder, endFinder, dxScroll: -300.0);
      // await driver.
      assert(googleLogin == null);
    });

    test('skip to login screen ', () async {
      // First, tap the button.
      await driver.tap(skipFinder);

      // Then, verify the counter text is incremented by 1.
      expect(await driver.getText(googleLogin), "    Continue with Google");
    });
   
  });
}
