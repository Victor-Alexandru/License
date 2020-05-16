import 'dart:async';
import 'dart:convert';
import 'package:moodle_ui/models/token.dart';
import 'package:http/http.dart' as http;

class RestDatasource {
  static final LOGIN_URL = "http://192.168.1.108:8000/api/jwtauth/token/";

  Future<Token> login(String username, String password) {
    Map data = {
      'username': username,
      'password': password,
    };

    String body = json.encode(data);

    return http
        .post(LOGIN_URL,
            headers: {"Content-Type": "application/json"}, body: body)
        .then((dynamic response) {
      Map responseBody = json.decode(response.body);
      print("-----------------------");
      print(response.body);
      print("-----------------------");

      if (responseBody.containsKey("detail")) {
        throw new Exception(responseBody["detail"]);
      }

      return new Token.map(responseBody);
    });
  }
}
