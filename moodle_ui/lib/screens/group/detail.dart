import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group-notification.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/user-group.dart';
import 'package:moodle_ui/screens/chat/chat_screen.dart';
import 'package:moodle_ui/screens/user/user_detail_screen.dart';
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
  List _members = new List<SiteUser>();
  Webservice _webservice;
  String _messageText;
  String _colorText;
  String _prioriyText;
  SiteUser _currentUser;
  var _currentUserUserGroups = new List<UserGroup>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GroupDetailViewState(Group group, Webservice ws) {
    this._currentGroup = group;
    this._webservice = ws;
  }

  _setSiteUser() async {
    this._currentUser = await this._webservice.fetchSiteUserBasedOnToken();
  }

  @override
  void initState() {
    super.initState();
    _setSiteUser();
    _getUserGroups();
    _pageController = PageController();
    _getGroupNotifications();
    _getMembers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> getPages() {
    if (this._currentGroup.ownerId == this._currentUser.id) {
      return [NotificationPage(), MembersPage(), FormPage()];
    } else {
      return [NotificationPage(), MembersPage()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: PageView(
          controller: _pageController,
          children: _currentUser != null ? getPages() : [],
        ),
      ),
    );
  }

  Widget NotificationPage() {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: ListView.builder(
          itemCount: _groupNotifications.length == 0
              ? 1
              : _groupNotifications.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // return the header
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: new Text(
                  "Notifications",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                )),
              );
            }
            index -= 1;
            return GroupNotificationCell(context, index);
          },
        ),
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

  Widget SiteUserCell(BuildContext ctx, int index) {
    return GestureDetector(
      child: Card(
          margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 12,
                child: new Center(
                    child: new Icon(
                  Icons.person,
                  size: MediaQuery.of(context).size.width / 6,
                )),
              ),
              this._members[index].display(),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      iconSize: 32,
                      icon: new Icon(Icons.supervised_user_circle,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDetailView(
                                    _webservice.token, _members[index])));
                      }),
                  IconButton(
                      iconSize: 32,
                      icon: new Icon(Icons.chat, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(_webservice, _members[index])));
                      }),
                  (this._currentGroup.ownerId == this._currentUser.id)
                      ? IconButton(
                          iconSize: 32,
                          icon: new Icon(Icons.delete_forever,
                              color: Colors.redAccent),
                          onPressed: () async {
                            for (UserGroup userGroup
                                in _currentUserUserGroups) {
                              if (userGroup.groupId == this._currentGroup.id &&
                                  this._members[index].id ==
                                      userGroup.user.id) {
                                int status = await this
                                    ._webservice
                                    .makeDeleteUserGroupRequest(userGroup.id);
                                if (status >= 200 && status < 300) {
                                  setState(() {
                                    this._members.removeWhere(
                                        (item) => item.id == userGroup.user.id);
                                  });
                                  break;
                                }
                              }
                            }

                            //doar owneru are voie sa dea delete
                          })
                      : Container(),
                ],
              ),
            ],
          )),
    );
  }

  Widget MembersPage() {
    return Center(
      child: Stack(children: <Widget>[
        ListView.builder(
          itemCount: _members.length == 0 ? 1 : _members.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // return the header
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: new Text(
                  "Group Members",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                )),
              );
            }
            index -= 1;
            return SiteUserCell(context, index);
          },
        ),
      ]),
    );
  }

  Widget FormPage() {
    return Container(
      color: Colors.redAccent,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildMessageField(),
              _buildColorField(),
              _buildPriorityField(),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.white,
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      'Send Notification',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
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
                        List<String> usernames = [];
                        for (SiteUser su in _members) {
                          usernames.add(su.firstName);
                        }
                        this._webservice.addFireBaseMessage(
                            _messageText, _currentGroup.name, usernames);
                        this._getGroupNotifications();
                      }
                    });

                    // finishing the post request

                    //Send to API
                  },
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Message'),
        maxLength: 25,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Message is Required';
          }

          if (value.length > 25) {
            return 'Message has less than 25 characters';
          }

          return null;
        },
        onSaved: (String value) {
          _messageText = value;
        },
      ),
    );
  }

  Widget _buildColorField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
      ),
    );
  }

  Widget _buildPriorityField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Priority'),
        maxLength: 25,
        validator: (String value) {
          print(value != 'HG');
          if (value.isEmpty) {
            return 'Priority is Required';
          }
          if (!(value == 'HG' || value == 'MD' || value == 'LW')) {
            return 'Priority must be HG MD or LW';
          }

          return null;
        },
        onSaved: (String value) {
          _prioriyText = value;
        },
      ),
    );
  }

  _getMembers() async {
    var groupId = this._currentGroup.id.toString();
    _webservice.fetchMembers(groupId).then((m) {
      setState(() {
        _members = m;
      });
    });
  }

  _getUserGroups() async {
    var groupId = this._currentGroup.id.toString();
    _webservice.fetchUserGroupsByGroupID(groupId).then((m) {
      setState(() {
        _currentUserUserGroups = m;
      });
    });
  }
}
