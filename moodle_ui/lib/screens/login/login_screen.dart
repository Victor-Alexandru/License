import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moodle_ui/auth.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/models/user.dart';
import 'package:moodle_ui/routes.dart';
import 'package:moodle_ui/screens/home/home_page.dart';
import 'package:moodle_ui/screens/home/selection_screen.dart';
import 'package:moodle_ui/screens/login/login_screen_presenter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _username;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      print(_username);
      print(_password);
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {
           _submit();
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Text(
              "Login",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          color: Colors.white,
          textColor: Colors.black,
          padding: EdgeInsets.all(8.0),
        ));

    var loginForm = new Column(
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 5
                        ? "Username must have at least 5 chars"
                        : null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Username", icon: Icon(Icons.person)),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(
                      labelText: "Password", icon: Icon(Icons.security)),
                ),
              ),
            ],
          ),
        ),
        loginBtn
        // _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      backgroundColor: Colors.redAccent,
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new Container(
            child: loginForm,
            height: 300.0,
            width: 300.0,
            decoration: new BoxDecoration(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    print(errorTxt);
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(Token token) async {
    _showSnackBar(token.access);
    setState(() => _isLoading = false);

    //changing the route
    Route route =
        MaterialPageRoute(builder: (context) => SelectionScreen(token));

    Navigator.pushReplacement(context, route);

    // Navigator.of(_ctx).pushReplacementNamed("/home");
    // var db = new DatabaseHelper();
    // await db.saveUser(user);
  }
}
