import 'package:flutter/widgets.dart';
// Imports the Flutter Driver API.
// import 'package:connectivity/connectivity.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  // bool skipOnboardingTest = false;
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
      final midFinder = find.byValueKey('secondPage');
      final endFinder = find.byValueKey('thirdPage');

      await driver.scrollUntilVisible(pagesFinder, midFinder, dxScroll: -300.0);
      assert(endFinder == null);

      await driver.scrollUntilVisible(pagesFinder, endFinder, dxScroll: -300.0);
      assert(endFinder != null);
      assert(googleLogin == null);
    });

    // test('skip to login screen ', () async {
    //   // First, tap the button.
    //   await driver.tap(skipFinder);

    //   expect(await driver.getText(googleLogin), "    Continue with Google");
    // });
    // skipOnboardingTest = true;
  },
      // skip: skipOnboardingTest
      //     ? false
      //     : "Test previously passed. Moving to Next Tests."
          );

  // NOTE: Testing Google or Facebook Auth is not possible
  // group("Testing home", () async {
  //   // test online or offline behaviour depending on connectivity
  //   dynamic checkconnectivity = await Connectivity().checkConnectivity();
    
  //   final googleLogin = find.byValueKey('googleLogin');
  //   final hostButtonFinder = find.byValueKey('HOST GAME');
  //   final joinButtonFinder = find.byValueKey("JOIN GAME");
  //   final howtoButtonFinder = find.byValueKey("HOW TO PLAY");
  //   final drawerFinder = find.byValueKey("homeDrawer");

  //   // JOIN GAME
  //   final joinConfirmButton = find.byValueKey('confirmJoin');
  //   final joinCancelButton = find.byValueKey('cancelJoin');
  //   final joinPin = find.byValueKey('pinField');

  //   // HOW TO

  //   FlutterDriver driver;

  //   // Connect to the Flutter driver before running any tests.
  //   setUpAll(() async {
  //     driver = await FlutterDriver.connect();
  //   });

  //   // Close the connection to the driver after the tests have completed.
  //   tearDownAll(() async {
  //     if (driver != null) {
  //       driver.close();
  //     }
  //   });

  //   if (checkconnectivity == ConnectivityResult.wifi) {
  //     test('Testing connected HOME SCREEN behaviour', () async {
  //       // HOST GAME: Successful behaviour when allowed to host
  //       await driver.tap(hostButtonFinder);
  //       await driver.waitFor(find.text('MATCH'));
  //       var hostBackButton = find.byValueKey('matchBack');
  //       assert(hostBackButton != null);
  //       await driver.tap(hostBackButton);

  //       // JOIN GAME: Successful behaviour when unable to join (Defect Testing)
  //       await driver.waitFor(find.text("JOIN GAME"));
  //       await driver.tap(joinButtonFinder);
  //       await driver.tap(joinConfirmButton);
  //       await driver.tap(joinPin);
  //       await driver.enterText("12345");
  //       await driver.waitFor(find.text("12345"));
  //       await driver.tap(joinConfirmButton);
  //       await driver.tap(joinCancelButton);

  //       // HOW TO: Successful behaviour when can go over content of how-to
  //       await driver.waitFor(find.text("HOW TO PLAY"));
  //       await driver.tap(howtoButtonFinder);

  //     });
  //   } else {
  //     test('Testing no wifi behaviour', () async {});
  //   }
  // },skip: true);
}
