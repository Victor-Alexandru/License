import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/user-message.dart';
import 'package:moodle_ui/models/user.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  User _currentUser;
  SiteUser _nearbyUser;

  ChatScreen(User cUser, SiteUser nUser) {
    this._currentUser = cUser;
    this._nearbyUser = nUser;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState(_currentUser, _nearbyUser);
}

class _ChatScreenState extends State<ChatScreen> {
  User _currentUser;
  SiteUser _nearbyUser;
  List<UserMessage> _messages = new List();
  final _sendMessageController = TextEditingController();

  _ChatScreenState(User cUser, SiteUser nUser) {
    this._currentUser = cUser;
    this._nearbyUser = nUser;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _sendMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._getMessages();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                _nearbyUser.firstName,
                style: TextStyle(color: Colors.black),
              )
            ],
          )
        ]),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return messageCell(context, index);
                    })),
          ),
        ),
        _sendMessageWidget(),
      ]),
    );
  }

  // ListView.builder(
  //           itemCount: _messages.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return messageCell(context, index);
  //           })

  Widget messageCell(BuildContext context, int index) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * 0.75,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color(0xFFFFEFEE),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            )),
        child: Center(
          child: Text(_messages[index].text),
        ));
  }

  _sendMessageWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _sendMessageController,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              print(_sendMessageController.text);
              Map data = {
                'text': _sendMessageController.text,
                'owner': _currentUser.id.toString(),
                'to_user_msg': _nearbyUser.id.toString()
              };

              String body = json.encode(data);

              await http
                  .post(
                'http://192.168.1.108:8000/monitor/user-messages/',
                headers: {"Content-Type": "application/json"},
                body: body,
              )
                  .then((response) {
                if (response.statusCode == 201) {
                  _getMessages();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  _getMessages() async {
    Map<String, String> queryParameters = {
      'first_user_id': _currentUser.id.toString(),
      'second_user_id': _nearbyUser.id.toString(),
    };
    var _getUsersMessagesUrlEnpoint = Uri.http(
        '192.168.1.108:8000', 'monitor/user-messages/', queryParameters);

    http.get(_getUsersMessagesUrlEnpoint).then((response) {
      print(response.body);
      setState(() {
        Iterable list = json.decode(response.body);
        _messages = list.map((model) => UserMessage.fromJson(model)).toList();
      });
    });
  }
}
