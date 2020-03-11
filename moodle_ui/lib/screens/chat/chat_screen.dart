import 'package:flutter/material.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/user-message.dart';
import 'package:moodle_ui/models/user.dart';

class ChatScreen extends StatefulWidget {
  User _currentUser;
  SiteUser _nearbyUser;

  ChatScreen(User cUser, SiteUser nUser) {
    this._currentUser = cUser;
    this._nearbyUser = nUser;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState(_currentUser, _nearbyUser);
}

class _ChatScreenState extends State<ChatScreen> {
  User _currentUser;
  SiteUser _nearbyUser;
  List<UserMessage> _messages = new List<UserMessage>();

  _ChatScreenState(User cUser, SiteUser nUser) {
    this._currentUser = cUser;
    this._nearbyUser = nUser;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                _nearbyUser.firstName,
                style: TextStyle(color: Colors.black),
              )
            ],
          )
        ]),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => MessageCell(context, index),
            )
          ],
        ),
      ),
    );
  }

  Widget MessageCell(BuildContext ctx, int index) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children:<Widget>[
                  Text("data")
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}
