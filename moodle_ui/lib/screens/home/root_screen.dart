import 'package:flutter/material.dart';
import 'package:moodle_ui/screens/login/login_screen.dart';

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
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
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 14),
              ),
              color: Colors.white,
              textColor: Colors.red,
              padding: EdgeInsets.all(8.0),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 14),
              ),
              color: Colors.white,
              textColor: Colors.red,
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }
}
