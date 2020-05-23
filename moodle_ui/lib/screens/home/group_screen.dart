import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moodle_ui/screens/group/detail.dart';
import 'package:moodle_ui/service/WebService.dart';

class GroupScreen extends StatefulWidget {
  Webservice _webservice;

  GroupScreen(Webservice ws) {
    this._webservice = ws;
  }

  @override
  _GroupScreenState createState() => _GroupScreenState(this._webservice);
}

class _GroupScreenState extends State<GroupScreen> {
  // Position _currentPosition;
  var _associateGroups = new List<Group>();
  Webservice _webservice;

  _GroupScreenState(Webservice ws) {
    this._webservice = ws;
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
                      GroupDetailView(_associateGroups[index], _webservice)));
        },
        child: _associateGroups[index].GroupCardView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: _associateGroups.length,
            itemBuilder: (context, index) => GroupCell(context, index),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getGroups(),
        child: Icon(
          Icons.group,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  _getGroups() {
    _webservice.fetchGroups().then((groupList) {
      setState(() {
        _associateGroups = groupList;
      });
    });
  }
}
