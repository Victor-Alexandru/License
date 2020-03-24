import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moodle_ui/screens/group/detail.dart';

class GroupScreen extends StatefulWidget {
  User _currentUser;
  Token _token;

  GroupScreen(Token token) {
    this._token = token;
  }

  @override
  _GroupScreenState createState() => _GroupScreenState(this._token);
}

class _GroupScreenState extends State<GroupScreen> {
  // Position _currentPosition;
  var _associateGroups = new List<Group>();
  Token _token;

  _GroupScreenState(Token token) {
    this._token = token;
  }

  @override
  void initState() {
    super.initState();
    this._getGroups();
  }

  Widget GroupCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GroupDetailView(_associateGroups[index],_token)));
      },
      child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      _associateGroups[index].name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " (" + _associateGroups[index].skill.name + ")",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.group, color: Colors.blue),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groups"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              // _getNearbyUsers();
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: _associateGroups.length,
            itemBuilder: (context, index) => GroupCell(context, index),
          ),
        ]),
      ),
    );
  }

  _getGroups() {
    var _getYourGroupsUrlEnpoint =
        Uri.http('192.168.1.108:8000', 'monitor/groups/', {});
    String token = this._token.access;

    http.get(_getYourGroupsUrlEnpoint, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((response) {
      print(response.body);
      setState(() {
        Iterable list = json.decode(response.body);
        _associateGroups = list.map((model) => Group.fromJson(model)).toList();
        print(_associateGroups);
      });
    });
  }
}
