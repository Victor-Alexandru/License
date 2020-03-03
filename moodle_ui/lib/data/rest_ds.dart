import 'dart:async';

import 'package:moodle_ui/utils/network_util.dart';
import 'package:moodle_ui/models/user.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = "http://192.168.1.105:8000/monitor/auth";
  // static final _API_KEY = "somerandomkey";

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      // "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      print("&&&&&&&&&&&&&&&&&&&&&&&");
      print(res.toString());
      print("&&&&&&&&&&&&&&&&&&&&&&&");
      if(res["error"]) throw new Exception(res["error_msg"]);
      return new User.map(res["user"]);
    });
  }
}