import 'package:flutter/material.dart';
import 'package:moodle_ui/models/site-user.dart';
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

  _ChatScreenState(User cUser, SiteUser nUser) {
    this._currentUser = cUser;
    this._nearbyUser = nUser;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Center(
        child: Text("Chat between " +
            _currentUser.username +
            "  and  " +
            _nearbyUser.firstName),
      ),
    );
  }
}
