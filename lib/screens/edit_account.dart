import 'package:flutter/material.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/screens/username.dart';

class EditAccountScreen extends StatefulWidget {
  EditAccountScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _Edit_account createState() => _Edit_account();
}

class _Edit_account extends State<EditAccountScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        backgroundColor: Color(0xFFF8B400),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/home_back.png',
              ),
              alignment: Alignment.bottomLeft,
              fit: BoxFit.scaleDown),
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 2,
                horizontal: SizeConfig.safeBlockHorizontal * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.blockSizeHorizontal * 2,
                      SizeConfig.safeBlockVertical * 2,
                      SizeConfig.blockSizeHorizontal,
                      SizeConfig.safeBlockVertical * 2),
                  child: Text(
                    "Username: ",
                    style: TextStyle(color: Colors.grey[500], fontSize: 18),
                  ),
                ),
                Text("${user.userName}",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, 0, SizeConfig.safeBlockHorizontal*2, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Username()),
                          );
                        },
                        child: Text(
                          "edit",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
