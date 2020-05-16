import 'package:flutter/material.dart';
import 'package:sciencebowlportable/screens/edit_account.dart';
import 'package:sciencebowlportable/screens/pin_screen.dart';
import 'package:sciencebowlportable/screens/match_settings.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:sciencebowlportable/utilities/styles.dart';
import 'package:sciencebowlportable/screens/howtoplay.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:sciencebowlportable/screens/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum settings { help, report }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime currentBackPressTime;
  settings _selection;
  bool _connectedToWifi = true;
  final ableColor = Color(0xFF20BABA);
  Color buttonColor = Color(0xFF20BABA);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return new WillPopScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/homeBG.png"), fit: BoxFit.cover)),
          child: Scaffold(
            drawer: Drawer(
                child: ListView(
              children: [
                DrawerHeader(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text.rich(TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Welcome,\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    SizeConfig.safeBlockHorizontal * 6.5)),
                        TextSpan(
                            text: "${user.userName}",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize:
                                    SizeConfig.safeBlockHorizontal * 4.5)),
                      ],
                    )),
                  ),
                ),
                ListTile(
                  leading: Icon(IconData(59475, fontFamily: 'MaterialIcons'),
                      color: Color(0xFFF8B400)),
                  title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAccountScreen()),
                        );
                      },
                      child: Container(
                        child: Text(
                          "Edit Account",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFF8B400),
                              fontSize: SizeConfig.safeBlockHorizontal * 4.5),
                        ),
                      )),
                ),
                ListTile(
                  leading: Icon(IconData(59513, fontFamily: 'MaterialIcons'),
                      color: Color(0xFFF8B400)),
                  title: GestureDetector(
                      onTap: () {
                        GoogleSignIn.games().signOut();
                        FacebookLogin.channel.invokeMethod("logOut");
                        FirebaseAuth.instance.signOut().then((ob) {
                          print("loggedout");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OnboardingScreen()),
                          );
                        }).catchError((e){
                          print("not logged out");
                          Fluttertoast.showToast(
                              msg: "Log out failed",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                          );


                        });
                      },
                      child: Container(
                        child: Text(
                          "Logout",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFF8B400),
                              fontSize: SizeConfig.safeBlockHorizontal * 4.5),
                        ),
                      )),
                ),
                ListTile(),
                ListTile(),
              ],
            )),
            appBar: AppBar(
              title: Text('SBP', style: appBarStyle),
              centerTitle: true,
              backgroundColor: Color(0xFFF8B400),
              actions: <Widget>[
                PopupMenuButton<settings>(
                  onSelected: (settings result) {
                    setState(() {
                      _selection = result;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<settings>>[
                    PopupMenuItem(
                      value: settings.report,
                      child: Text('Report'),
                    ),
                  ],
                ),
              ],
            ),

            // THIS IS WHERE THE MAIN PAGE OF THE APP STARTS
            backgroundColor: Colors.white,
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/home_back.png',
                      ),
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.scaleDown),
                ),
                child: Column(children: [
                  Row(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.safeBlockHorizontal * 7,
                            SizeConfig.safeBlockVertical * 5,
                            SizeConfig.safeBlockHorizontal * 5,
                            SizeConfig.safeBlockVertical * 5),
                        child: Row(children: [
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'Welcome, ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 18.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${user.userName}!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ])),
                        ])),
                  ]),
                  _buildButton("HOST GAME", MatchSettings()),
                  _buildButton("JOIN GAME", PinScreen()),
                  _buildNoInternetbutton("HOW TO PLAY", HowToPlayScreen())
                ])),
          ),
        ),
      ),
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
    );
  }

  _buildButton(String title, landingPage) {
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 3.5,
            horizontal: SizeConfig.safeBlockHorizontal * 5),
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SizedBox(
              height: SizeConfig.blockSizeVertical * 21,
              width: SizeConfig.blockSizeVertical * 50,
              child: Center(
                child: Text(title,
                    style: TextStyle(color: Colors.white, fontSize: 22.0)),
              ),
            ),
            color: buttonColor,

            // Change button color and behaviour based on internet connectivity
            onPressed: () async {
              await _checkWifiConnectivity();
              setState(() {
                if (_connectedToWifi) {
                  buttonColor = ableColor;
                } else {
                  buttonColor = disableColor;
                }
              });
              if (_connectedToWifi) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => landingPage),
                );
              } else {
                _showNoInternetDialog();
              }
            }));
  }

  _buildNoInternetbutton(String title, landingPage) {
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 3.5,
            horizontal: SizeConfig.safeBlockHorizontal * 5),
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SizedBox(
              height: SizeConfig.blockSizeVertical * 21,
              width: SizeConfig.blockSizeVertical * 50,
              child: Center(
                child: Text(title,
                    style: TextStyle(color: Colors.white, fontSize: 22.0)),
              ),
            ),
            color: ableColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => landingPage),
              );
            }));
  }

  _showNoInternetDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("No Wifi Connectivity"),
            content: Text(
                "You need to be connected to Wifi to continue. Connect to Wifi and try again."),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay", style: staystyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _checkWifiConnectivity() async {
    var result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      print("Connected to Wifi");
      _connectedToWifi = true;
    } else {
      print("NO wifi detected");
      _connectedToWifi = false;
    }
  }
}
