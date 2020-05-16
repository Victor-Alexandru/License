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
      backgroundColor: Colors.redAccent,
      body: new Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(_webservice)));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "Find Nearby Users",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              color: Colors.white,
              textColor: Colors.black,
              padding: EdgeInsets.all(8.0),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupScreen(_webservice)));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "See your groups",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              color: Colors.white,
              textColor: Colors.black,
              padding: EdgeInsets.all(8.0),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FirebaseScreen()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "Firebase Notifications",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              color: Colors.white,
              textColor: Colors.black,
              padding: EdgeInsets.all(8.0),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileView(_webservice)));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "Your profile",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              color: Colors.white,
              textColor: Colors.black,
              padding: EdgeInsets.all(8.0),
            )
          ],
        ),
      ),
    ));
  }
}
