import 'package:flutter/material.dart';
import 'package:moodle_ui/screens/login/login_screen.dart';
import 'package:moodle_ui/screens/register/register_screen.dart';

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        backgroundColor: Colors.redAccent,
        body: SafeArea(
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height /
                  2.5,
//                        ),
            child: new Center(
              child:new Icon(Icons.border_clear,size: MediaQuery.of(context).size.width/2,)
            ),
            ),
            Expanded(
              child: new Align(
                alignment: Alignment.topCenter,
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
                                builder: (context) => LoginScreen()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black)),
                      child: SizedBox(
                        width:  MediaQuery.of(context).size.width/1.5,
                        child: Text(
                          "Login",
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
                                builder: (context) => RegisterScreen()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black)),
                      child: SizedBox(
                        width:  MediaQuery.of(context).size.width/1.5,
                        child: Text(
                          "Register",
                          style: TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      color: Colors.white,
                      textColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
