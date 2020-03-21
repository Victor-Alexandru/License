import 'dart:async';
import 'dart:convert';
import 'package:moodle_ui/utils/network_util.dart';
import 'package:moodle_ui/models/user.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = "http://192.168.1.108:8000/api/jwtauth/token/";
  // static final _API_KEY = "somerandomkey";

  Future<User> login(String username, String password) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    return _netUtil
        .post(LOGIN_URL,
            body: {
              // "token": _API_KEY,
              "username": username,
              "password": password
            },
            headers: headers)
        .then((dynamic res) {
      print("&&&&&&&&&&&&&&&&&&&&&&&");
      print(res.toString());
      print("&&&&&&&&&&&&&&&&&&&&&&&");
      return new User.map(res["user"]);
    });
  }
}
