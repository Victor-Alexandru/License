import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final formKey = new GlobalKey<FormState>();
  String _password, _username, _password2, _email, _description;
  bool _isLoading = false;

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<int> _submit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _email.trim();
      _username.trim();
      _password.trim();
      _password2.trim();
      _description.trim();
      return _performRegister();
    }
  }

  Future<int> _performRegister() async {
    Map<String, String> queryParameters = {};
    final String registerURL =
        "http://192.168.1.108:8000/api/jwtauth/register/";
    queryParameters['username'] = _username;
    queryParameters['email'] = _email;
    queryParameters['password'] = _password;
    queryParameters['password2'] = _password2;
    queryParameters['description'] = _description;

    String body = json.encode(queryParameters);

    var response = await http.post(registerURL,
        headers: {"Content-Type": "application/json"}, body: body);
    print("------------------------");
    print(response.body);
    print("------------------------");
    return response.statusCode;
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    var registerBtn = Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () async {
            int statusCode = await _submit();
            if (statusCode == 201) {
              _showSnackBar("Register succesfully");
            } else {
              _showSnackBar("Register failed");
            }
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Text(
              "Register",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          color: Colors.white,
          textColor: Colors.black,
          padding: EdgeInsets.all(8.0),
        ));

    var registerForm = new Column(
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
                    return null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Username", icon: Icon(Icons.person)),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _email = val,
                  decoration: new InputDecoration(
                      labelText: "Email", icon: Icon(Icons.email)),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _description = val,
                  decoration: new InputDecoration(
                      labelText: "Profile Description",
                      icon: Icon(Icons.description)),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(
                      labelText: "Password", icon: Icon(Icons.security)),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password2 = val,
                  decoration: new InputDecoration(
                      labelText: "Confirm Password",
                      icon: Icon(Icons.security)),
                ),
              ),
            ],
          ),
        ),
        registerBtn,
//         _isLoading ? new CircularProgressIndicator() : Container()
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.redAccent,
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new SingleChildScrollView(
            child: registerForm,
          ),
        ),
      ),
    );
  }
}
