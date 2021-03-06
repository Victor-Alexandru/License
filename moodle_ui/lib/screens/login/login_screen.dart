import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/screens/home/selection_screen.dart';
import 'package:moodle_ui/screens/login/login_screen_presenter.dart';
import 'dart:io';

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

  void _submit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _username.trim();
      _password.trim();
      print(_username);
      print(_password);

      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          _presenter.doLogin(_username, _password);
        }
      } on SocketException catch (_) {
        _showSnackBar('not connected');
      }
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
                    return val.length < 4
                        ? "Username must have at least 4 chars"
                        : null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Username", icon: Icon(Icons.person)),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  validator: (val) {
                    return val.length < 4
                        ? "Password must have at least 4 chars"
                        : null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Password", icon: Icon(Icons.security)),
                ),
              ),
            ],
          ),
        ),
        loginBtn
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
  void onLoginSuccess(Token token, String username) async {
    setState(() => _isLoading = false);

    //changing the route
    Route route = MaterialPageRoute(
        builder: (context) => SelectionScreen(token, username));

    Navigator.pushReplacement(context, route);
  }
}
