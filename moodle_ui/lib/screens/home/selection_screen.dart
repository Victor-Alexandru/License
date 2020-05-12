import 'package:flutter/material.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/screens/firebase/firebase_screen.dart';
import 'package:moodle_ui/screens/home/group_screen.dart';
import 'package:moodle_ui/screens/home/home_page.dart';
import 'package:moodle_ui/screens/user/user_profile_screen.dart';
import 'package:moodle_ui/service/WebService.dart';

class SelectionScreen extends StatelessWidget {
  // This widget is the root of your application.
  Token token;
  Webservice _webservice;

  SelectionScreen(Token token) {
    this.token = token;
    _webservice = new Webservice(token);
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage(token)));
              },
              child: Text(
                "Find Users Nearby",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.lightBlueAccent,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupScreen(_webservice)));
              },
              child: Text(
                "See your Gropus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.lightBlueAccent,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FirebaseScreen()));
              },
              child: Text(
                "Firebase test",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.lightBlueAccent,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileView(this.token)));
              },
              child: Text(
                "Your profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    ));
  }
}
