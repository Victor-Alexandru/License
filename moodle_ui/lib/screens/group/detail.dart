import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group-notification.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_ui/models/token.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle_ui/service/WebService.dart';

class GroupDetailView extends StatefulWidget {
  Group _currentGroup;
  Webservice _webservice;

  GroupDetailView(Group group, Webservice ws) {
    this._currentGroup = group;
    this._webservice = ws;
  }

  _GroupDetailViewState createState() =>
      _GroupDetailViewState(_currentGroup, _webservice);
}

class _GroupDetailViewState extends State<GroupDetailView> {
  PageController _pageController;
  Group _currentGroup;
  List _groupNotifications = new List<GroupNotification>();
  Webservice _webservice;
  String _messageText;
  String _colorText;
  String _prioriyText;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GroupDetailViewState(Group group, Webservice ws) {
    this._currentGroup = group;
    this._webservice = ws;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _getGroupNotifications();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          children: [
            NotificationPage(),
            MembersPage(),
            FormPage(),
          ],
        ),
      ),
    );
  }

  Widget NotificationPage() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Stack(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              Text(
                "Group Notification ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ListView.builder(
            itemCount: _groupNotifications.length,
            itemBuilder: (context, index) =>
                GroupNotificationCell(context, index),
          ),
        ]),
      ),
    );
  }

  Widget GroupNotificationCell(BuildContext ctx, int index) {
    return GestureDetector(
        child: _groupNotifications[index].GroupNotificationCard());
  }

  _getGroupNotifications() {
    _webservice
        .fetchGroupNotifications(this._currentGroup)
        .then((groupNotifications) {
      setState(() {
        _groupNotifications = groupNotifications;
      });
    });
  }

  Widget MembersPage() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          "Page with all members enrolled to the course",
        ),
      ),
    );
  }

  Widget FormPage() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildMessageField(),
            _buildColorField(),
            _buildPriorityField(),
            SizedBox(height: 100),
            RaisedButton(
              color: Colors.white70,
              child: Text(
                'Send Notification',
                style: TextStyle(color: Colors.black45, fontSize: 16),
              ),
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                _formKey.currentState.save();

                print(_messageText);
                print(_colorText);
                print(_prioriyText);

                //making the post request here
                Map data = {
                  'message': _messageText,
                  'color': _colorText,
                  'priority': _prioriyText,
                  'group': _currentGroup.id,
                };
                String body = json.encode(data);
                String token = this._webservice.token.access;

                await http
                    .post(
                  'http://192.168.1.108:8000/monitor/group-notifications/',
                  headers: {
                    "Content-Type": "application/json",
                    'Authorization': 'Bearer $token'
                  },
                  body: body,
                )
                    .then((response) {
                  if (response.statusCode == 201) {
                    Firestore.instance.runTransaction((transaction) async {
                      await transaction.set(
                          Firestore.instance.collection("Messages").document(),
                          {
                            'message': _messageText,
                          });
                    });
                    print("post cu succes");
                  }
                });

                // finishing the post request

                //Send to API
              },
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Message'),
      maxLength: 25,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Message is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _messageText = value;
      },
    );
  }

  Widget _buildColorField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Color'),
      maxLength: 25,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Color is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _colorText = value;
      },
    );
  }

  Widget _buildPriorityField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Priority'),
      maxLength: 25,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Priority is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _prioriyText = value;
      },
    );
  }
}
