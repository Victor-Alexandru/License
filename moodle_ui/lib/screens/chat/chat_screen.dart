import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/models/user-message.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  SiteUser _nearbyUser;
  Token _token;

  ChatScreen(Token token, SiteUser nUser) {
    this._token = token;
    this._nearbyUser = nUser;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState(_token, _nearbyUser);
}

class _ChatScreenState extends State<ChatScreen> {
  Token _token;
  SiteUser _nearbyUser;
  List<UserMessage> _messages = new List();
  final _sendMessageController = TextEditingController();
  Timer timer;

  _ChatScreenState(Token token, SiteUser nUser) {
    this._token = token;
    this._nearbyUser = nUser;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _sendMessageController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._getMessages();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _getMessages());
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
                'to_user_msg': _nearbyUser.id.toString()
              };

              String body = json.encode(data);
              String token = this._token.access;
              await http
                  .post(
                'http://192.168.1.108:8000/monitor/user-messages/',
                headers: {
                  "Content-Type": "application/json",
                  'Authorization': 'Bearer $token'
                },
                body: body,
              )
                  .then((response) {
                if (response.statusCode == 201) {
                  _sendMessageController.clear();
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
      'second_user_id': _nearbyUser.id.toString(),
    };
    var _getUsersMessagesUrlEnpoint = Uri.http(
        '192.168.1.108:8000', 'monitor/user-messages/', queryParameters);
    String token = this._token.access;

    http.get(_getUsersMessagesUrlEnpoint, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((response) {
      print("--------------------------");
      print(response.body);
      print("--------------------------");

      setState(() {
        Iterable list = json.decode(response.body);
        _messages = list.map((model) => UserMessage.fromJson(model)).toList();
      });
    });
  }
}
