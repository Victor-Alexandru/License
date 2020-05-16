import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moodle_ui/models/group-notification.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/request-to-group.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/models/user-group.dart';
import 'package:moodle_ui/models/user-message.dart';

class Webservice {
  Token token;
  Map<String, String> queryParameters = {};

  Webservice(Token tk) {
    this.token = tk;
  }

  Future<http.Response> makeGetRequest(url) async {
    String access = this.token.access;
    return http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $access',
    });
  }

  Future<List<Group>> fetchGroups() async {
    final url = "http://192.168.1.108:8000/monitor/groups";

    final response = await makeGetRequest(url);

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

    final response = await makeGetRequest(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list
          .map((gropuNotification) =>
              GroupNotification.fromJson(gropuNotification))
          .toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<SiteUser>> fetchNearbyUsers(preciseLocality) async {
    this.queryParameters.clear();

    queryParameters['locality'] = preciseLocality;

    var url =
        Uri.http('192.168.1.108:8000', 'monitor/site-users/', queryParameters);

    final response = await makeGetRequest(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((siteUser) => SiteUser.fromJson(siteUser)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<UserMessage>> fetchUserMessages(SiteUser nearbyUser) async {
    this.queryParameters.clear();

    queryParameters['second_user_id'] = nearbyUser.id.toString();

    var url = Uri.http(
        '192.168.1.108:8000', 'monitor/user-messages/', queryParameters);

    final response = await makeGetRequest(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list
          .map((userMessages) => UserMessage.fromJson(userMessages))
          .toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<SiteUser> fetchSiteUserBasedOnToken() async {
    var url = Uri.http('192.168.1.108:8000', 'monitor/token-site-user/', {});
    final response = await makeGetRequest(url);
    return SiteUser.fromJson(json.decode(response.body));
  }

  Future<List<Group>> fetchGroupsBasedOnSiteUserId(SiteUser s) async {
    this.queryParameters.clear();

    queryParameters['owner_id'] = s.id.toString();
    var url =
        Uri.http('192.168.1.108:8000', 'monitor/groups/', queryParameters);

    final response = await makeGetRequest(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((group) => Group.fromJson(group)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<UserGroup>> fetchUserGroups() async {
    var url = Uri.http('192.168.1.108:8000', 'monitor/user-groups/', {});

    final response = await makeGetRequest(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((ug) => UserGroup.fromJson(ug)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<RequestToGroup>> fetchRequestGroups() async {
    var url = Uri.http('192.168.1.108:8000', 'monitor/request-groups/', {});

    final response = await makeGetRequest(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((ug) => RequestToGroup.fromJson(ug)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }

  }
}
