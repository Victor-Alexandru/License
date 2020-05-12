import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moodle_ui/models/group-notification.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/token.dart';

class Webservice {
  Token token;

  Webservice(Token tk) {
    this.token = tk;
  }

  Future<List<Group>> fetchGroups() async {
    String access = this.token.access;
    final url = "http://192.168.1.108:8000/monitor/groups";
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $access',
    });
    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((group) => Group.fromJson(group)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<GroupNotification>> fetchGroupNotifications(Group group) async {
    var url = Uri.http('192.168.1.108:8000', 'monitor/group-notifications/',
        {"group_id": group.id.toString()});

    String access = this.token.access;

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $access',
    });

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((gropuNotification) => GroupNotification.fromJson(gropuNotification)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }



}
