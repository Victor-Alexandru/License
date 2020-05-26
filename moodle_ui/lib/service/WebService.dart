import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moodle_ui/models/group-notification.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/request-to-group.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/models/user-group.dart';
import 'package:moodle_ui/models/user-message.dart';
import 'package:moodle_ui/service/FirebaseService.dart';

class Webservice {
  Token token;
  Map<String, String> queryParameters = {};
  final String deafultURL = "192.168.1.108:8000";
  FirebaseService _fbs = FirebaseService();
  String _username;

  Webservice(Token tk, String username) {
    this.token = tk;
    this._username = username;
    this._fbs.setFirebaseToken(username);
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

  Future<List<SiteUser>> fetchMembers(String groupId) async {
    this.queryParameters.clear();
    queryParameters['group_id'] = groupId;

    var url =
        Uri.http('192.168.1.108:8000', 'monitor/members/', queryParameters);

    final response = await makeGetRequest(url);

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((siteUser) => SiteUser.fromJson(siteUser)).toList();
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

  Future<List<UserGroup>> fetchUserGroupsByGroupID(String groupId) async {
    this.queryParameters.clear();
    queryParameters['group_id'] = groupId;

    var url = Uri.http(
        '192.168.1.108:8000', 'monitor/user-groups-group/', queryParameters);

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

  void makeAPostGroupRequest(String groupName, String groupSize,
      String groupDuration, String skillName) async {
    var url = Uri.http('192.168.1.108:8000', 'monitor/groups/', {});

    this.queryParameters.clear();
    this.queryParameters['name'] = groupName;
    this.queryParameters['group_size'] = groupSize;
    this.queryParameters['estimated_work_duration'] = groupDuration;
    this.queryParameters['skill_name'] = skillName;

    String body = json.encode(this.queryParameters);
    String access = this.token.access;

    await http
        .post(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $access'
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 201) {
        print("post cu succes");
      } else {
        print("Sa busit ceva");
        print(response.statusCode);
      }
    });
  }

  void makeDeleteGroupRequest(int groupId) async {
    var url = Uri.http(
        '192.168.1.108:8000', 'monitor/groups/' + groupId.toString() + "/", {});
    await http.delete(url);
  }

  Future<int> makeDeleteUserGroupRequest(int groupId) async {
    var url = Uri.http('192.168.1.108:8000',
        'monitor/user-groups/' + groupId.toString() + "/", {});
    String access = this.token.access;

    var response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $access',
    });
    return response.statusCode;
  }
}
