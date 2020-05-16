import 'package:flutter/material.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sciencebowlportable/screens/login.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:flutter/services.dart';

int initScreen = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  initScreen = await prefs.getInt("initScreen");
  user.userName = await prefs.getString("username_set");
  user_email = await prefs.getString("user_email");
  print('initScreen $initScreen');
  print('user_email $user_email');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

Map<String, Widget Function(BuildContext)> route0;

class _MyApp extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (initScreen == 1) {
      // IF THIS IS NOT THE FIRST TIME RUNNING
      if (user_email == null) {
        route0 = <String, WidgetBuilder>{
          '/': (context) => Login(),
          '/home': (context) => MyHomePage(),
        };
      } else {
        route0 = <String, WidgetBuilder>{
          '/': (context) => MyHomePage(),
          '/home': (context) => MyHomePage(),
        };
      }
    } else {
      // IF THIS IS THE FIRST TIME RUNNING

      route0 = <String, WidgetBuilder>{
        '/': (context) => OnboardingScreen(),
        '/home': (context) => MyHomePage(),
      };
    }
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: route0,

      // home: OnboardingScreen(),
      // home: Result()
    );
  }
}

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         appBarTheme: AppBarTheme(
//           color: Color.fromARGB(200, 255, 255, 255),

//       ),
//         brightness: Brightness.light,
//         primaryColor: Color(0xFFF8B400),
//         accentColor: Colors.cyan[600],
//         primarySwatch: Colors.lightGreen,
//         fontFamily: 'Georgia',
//       ),
//       home: MyHomePage(title: 'Science Bowl Portable!'),
//     );
//   }
// }
