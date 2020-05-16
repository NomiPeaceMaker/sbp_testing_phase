import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator_questions_screen.dart';
import 'package:sciencebowlportable/screens/waiting_room.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/models/Questions.dart';
import 'package:sciencebowlportable/utilities/styles.dart';

class ModeratorWaitingRoom extends waitingRoom {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  @override
  ModeratorWaitingRoom(this.server, this.moderator,this.questionSet);
  _ModeratorWaitingRoomState createState() {
    return _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);
  }
}

class _ModeratorWaitingRoomState extends waitingRoomState<ModeratorWaitingRoom> {
  Server server;
  Moderator moderator;
  List<Question> questionSet;
  _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);

  @override
  initState() {
    super.initState();
    appBarText = "HOST";

    // stream recieving data from websockets
    // accepts a json encoded string
    // message responses based on if conditions on the "type" key
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data) {
      data = json.decode(data);
      Player player = Player(data["playerID"]);
      player.userName = data["userName"];
      player.email = data["email"];
      if (data["type"] == "pin") {
        if (data["pin"] == pin) {
          server.sockets[data["uniqueID"]].write(
              json.encode({
                "type": "pinState",
                "pinState": "Accepted",
                "moderatorName": user.userName
              })
          );
        } else {
          server.sockets[data["uniqueID"]].write(
              json.encode({
                "type": "pinState",
                "pinState": "Rejected"
              })
          );
        }
      } else if (data["type"] == "movingToWaitingRoom") {
        userSlotsDict[data["uniqueID"]] = null;
        var waitingScreenState = {"type": "waitingScreenState"};
        waitingScreenState["playerSlotIsTakenList"] = json.encode(playerSlotIsOccupiedList);
        waitingScreenState["playerNamesList"] = json.encode(playerSlotNamesList);
        server.sendAll(json.encode(waitingScreenState));
      } else if (data["type"] == "selectSlot") {
        String previousState = userSlotsDict[data["uniqueID"]];
        int playerPositionIndex = int.parse(data["playerPositionIndex"]);
        if (!playerSlotIsOccupiedList[playerPositionIndex]) {
          server.sendAll(json.encode(data));
          if (previousState!=null) {
            int previousStateIndex = retrievePlayerSlotIndexDict[previousState];
            playerJoinStreamControllers[previousStateIndex].add("undoSelect");
          }
          playerJoinStreamControllers[playerPositionIndex].add(player.userName);
          userSlotsDict[data["uniqueID"]] = data["playerID"];
        }
      } else if (data["type"] == "playerLeaving") {
        var uniqueID = data["uniqueID"];
        server.sockets[uniqueID].close();
        server.sockets.removeWhere((key, _) => key == uniqueID);
        int playerPositionIndex = int.parse(data["playerPositionIndex"]);
        playerJoinStreamControllers[playerPositionIndex].add("undoSelect");
      }
    });
  }

  @override

  Align bottomScreenMessage() {
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new SizedBox(
        width: 180.0,
        height: 60.0,
        child: new RaisedButton(
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
          ),
          child: new Text(
              "Start Game",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
          ),
          color: Colors.pink,
          textColor: Colors.white,
          onPressed: () {
            if (playerSlotIsOccupiedList[0] && playerSlotIsOccupiedList[5]) {
              socketDataStreamSubscription.cancel();
              server.sendAll(json.encode({"type":"startGame", "gameTimer":game.gameTime}));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ModeratorQuestions(this.server, this.moderator, this.questionSet)),
              );
            } else {
              _captainLeftDialog();
//              server.sendAll(json.encode({"type":"startGame", "gameTimer":game.gameTime}));
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => ModeratorQuestions(this.server, this.moderator, this.questionSet)),
//              );
//              socketDataStreamSubscription.cancel();
            }
          },
        ),
      ),
    );
  }

  @override
  Container pinBar() {
    pin = game.gamePin;
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "You're hosting,\n${user.userName}",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18),
              ),
            Text(
              "Game Pin:\n${game.gamePin}",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18),
            ),
          ],
        )
      ),
    );}

  @override
  void onExit() {
    server.sendAll(json.encode({"type": "moderatorLeaving"}));
    server.stop();
  }

  _captainLeftDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog (
          title: Text("Captains Need to Join"),
          content: Text("Both team captians need to join before we can start the game. Please ask them to join before proceeding."),
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

}