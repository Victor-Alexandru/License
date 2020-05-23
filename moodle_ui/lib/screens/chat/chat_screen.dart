import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/user-message.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_ui/service/WebService.dart';

class ChatScreen extends StatefulWidget {
  SiteUser _nearbyUser;
  Webservice _webservice;

  ChatScreen(Webservice ws, SiteUser nUser) {
    this._webservice = ws;
    this._nearbyUser = nUser;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState(_webservice, _nearbyUser);
}

class _ChatScreenState extends State<ChatScreen> {
  Webservice _webservice;
  SiteUser _nearbyUser;
  List<UserMessage> _messages = new List();
  ScrollController _scrollController = new ScrollController();
  final _sendMessageController = TextEditingController();
  Timer timer;

  _ChatScreenState(Webservice ws, SiteUser nUser) {
    this._webservice = ws;
    this._nearbyUser = nUser;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _sendMessageController.dispose();
    _scrollController.dispose();
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
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.redAccent,
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
            color: Colors.white,
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return messageCell(context, index);
                }),
          ),
        ),
        _sendMessageWidget(),
      ]),
    );
  }

  void performScrollAnimations() {
    _scrollController.animateTo(
      (_scrollController.position.maxScrollExtent + 100),
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget messageCell(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment:
        (this._nearbyUser.id == this._messages[index].toUserMsg)
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(
              maxWidth: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
            ),
            decoration: (this._nearbyUser.id == this._messages[index].toUserMsg)
                ? BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            )
                : BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            child: Text(_messages[index].text,
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
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
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () async {
              if (_sendMessageController.text.isNotEmpty) {
                print(_sendMessageController.text);
                Map data = {
                  'text': _sendMessageController.text,
                  'to_user_msg': _nearbyUser.id.toString()
                };

                String body = json.encode(data);
                String token = this._webservice.token.access;
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
                    performScrollAnimations();
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  _getMessages() async {
    _webservice.fetchUserMessages(_nearbyUser).then((userMessages) {
      setState(() {
        _messages = userMessages;
        if (_messages.length != userMessages.length)
          performScrollAnimations();
      });
    });
  }
}
