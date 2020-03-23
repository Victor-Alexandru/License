import 'package:flutter/material.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/models/user.dart';
import 'package:moodle_ui/screens/home/group_screen.dart';
import 'package:moodle_ui/screens/home/home_page.dart';

class SelectionScreen extends StatelessWidget {
  // This widget is the root of your application.
  Token token;

  SelectionScreen(Token token) {
    this.token = token;
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
              color: Colors.blue,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GroupScreen(token)));
              },
              child: Text(
                "See your Gropus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              color: Colors.blue,
            )
          ],
        ),
      ),
    ));
  }
}
