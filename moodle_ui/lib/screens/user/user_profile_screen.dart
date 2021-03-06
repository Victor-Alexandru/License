import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/request-to-group.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/skill.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_ui/models/user-group.dart';
import 'package:moodle_ui/service/WebService.dart';
import 'package:moodle_ui/utils/functions.dart' as utils;

class UserProfileView extends StatefulWidget {
  SiteUser _currentUser;
  Webservice _webservice;

  UserProfileView(Webservice ws) {
    this._webservice = ws;
  }

  @override
  _UserProfileViewState createState() =>
      _UserProfileViewState(_webservice, _currentUser);
}

class _UserProfileViewState extends State<UserProfileView> {
  Webservice _webservice;
  SiteUser _currentUser;
  PageController _pageController;
  var _ownerGroups = new List<Group>();
  var _currentUserUserGroups = new List<UserGroup>();
  var _currentRequestToGroups = new List<RequestToGroup>();
  final _formKey = GlobalKey<FormState>();
  final _formKeyTwo = GlobalKey<FormState>();
  final _groupNameCTR = TextEditingController();
  final _groupNameUpdCTR = TextEditingController();
  final _groupSizeCTR = TextEditingController();
  final _groupDurationCTR = TextEditingController();
  final _groupSkillCTR = TextEditingController();

  _UserProfileViewState(Webservice ws, SiteUser nUser) {
    this._webservice = ws;
    this._currentUser = nUser;
  }

  @override
  void initState() {
    super.initState();
    this._getGroups();
    this._getUserGroups();
    this._getRequestGroups();
    _pageController = PageController();
  }

  _setSiteUser() async {
    this._currentUser = await this._webservice.fetchSiteUserBasedOnToken();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _groupNameCTR.dispose();
    _groupSizeCTR.dispose();
    _groupDurationCTR.dispose();
    _groupSkillCTR.dispose();
    _groupNameUpdCTR.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: PageView(
          controller: _pageController,
          children: [ProfilePage(), OwnerGroupProfilePage(), RequestsPage()],
        ),
      ),
    );
  }

  Widget ProfilePage() {
    Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _buildCoverImage(screenSize),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SafeArea(
                          child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            _buildProfileImage(),
                            _buildFullName(),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height / 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colors.white),
              child: Center(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        this._currentUser != null
                            ? this._currentUser.description
                            : "",
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height / 10,
          ),
          MaterialButton(
            onPressed: () {
              _showDialog();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Text(
                " Create a group ",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            color: Colors.white,
            textColor: Colors.black,
            padding: EdgeInsets.all(8.0),
          ),
        ],
      ),
    );
  }

  _showUpdateGroupDialog(Group group, String groupName) {
    showDialog(
        context: context,
        builder: (BuildContext contex) {
          return AlertDialog(
            content: ListView(children: <Widget>[
              Form(
                key: _formKeyTwo,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _groupNameUpdCTR,
                        validator: (val) {
                          return val.length < 5
                              ? "Name must have at least 5 chars"
                              : null;
                        },
                        decoration: new InputDecoration(
                          labelText: "Group Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text("Update"),
                        onPressed: () {
                          if (_formKeyTwo.currentState.validate()) {
                            print(_groupNameUpdCTR.text);
                            _changeGroupName(group, _groupNameUpdCTR.text);
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ]),
          );
        });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _groupNameCTR,
                          validator: (val) {
                            return val.length < 5
                                ? "Name must have at least 5 chars"
                                : null;
                          },
                          decoration: new InputDecoration(
                            labelText: "Name",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _groupSizeCTR,
                          validator: (val) {
                            return !isNumeric(val)
                                ? "Size must be an integer"
                                : null;
                          },
                          decoration: new InputDecoration(
                            labelText: "Size (nr of members)",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _groupDurationCTR,
                          validator: (val) {
                            return !isNumeric(val)
                                ? "Duration must be an integer"
                                : null;
                          },
                          decoration: new InputDecoration(
                            labelText: "Duration (days) ",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _groupSkillCTR,
                          validator: (val) {
                            return null;
                          },
                          decoration: new InputDecoration(
                            labelText: "Skill",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Create"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              print(_groupNameCTR.text);
                              print(_groupSizeCTR.text);
                              print(_groupDurationCTR.text);
                              print(_groupSkillCTR.text);
                              print("Totul este ok");
                              int id = await this
                                  ._webservice
                                  .makeAPostGroupRequest(
                                      _groupNameCTR.text,
                                      _groupSizeCTR.text,
                                      _groupDurationCTR.text,
                                      _groupSkillCTR.text);
                              print(id);
                              if (id != -1) {
                                Group gr = new Group(
                                    _groupNameCTR.text,
                                    int.parse(_groupDurationCTR.text),
                                    int.parse(_groupDurationCTR.text));
                                gr.setId(id);
                                gr.setSkill(new Skill(_groupSkillCTR.text));
                                setState(() {
                                  this._ownerGroups.add(gr);
                                });
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/cover.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/avatar.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _currentUser != null ? _currentUser.firstName : "Loading",
      style: _nameTextStyle,
    );
  }

  Widget GroupCell(BuildContext ctx, int index) {
    return GestureDetector(
        onTap: () {
//          this._getGroups();
          _showUpdateGroupDialog(_ownerGroups[index], _ownerGroups[index].name);
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: new IconButton(
                    icon: Icon(Icons.group),
                    color: Colors.black,
                    iconSize: 50,
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      _ownerGroups[index].name,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                    child: Center(
                  child: Text(
                    _ownerGroups[index].skill.name,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                )),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        iconSize: 32,
                        icon: new Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          int status = await this
                              ._webservice
                              .makeDeleteGroupRequest(_ownerGroups[index].id);
                          if (status >= 200 && status < 300) {
                            setState(() {
                              this._ownerGroups.removeWhere(
                                  (item) => item.id == _ownerGroups[index].id);
                            });
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget OwnerGroupProfilePage() {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: ListView.builder(
          itemCount: _ownerGroups.length == 0 ? 1 : _ownerGroups.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // return the header
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: new Text(
                  "Owned groups",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                )),
              );
            }
            index -= 1;
            return GroupCell(context, index);
          },
        ),
      ),
    );
  }

  Widget RequestCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {},
      child: Card(
          color: _currentRequestToGroups[index].status == "PG"
              ? Colors.white
              : Colors.white,
          margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
          elevation: 4.0,
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
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  _currentRequestToGroups[index].requestFrom.username,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  _currentRequestToGroups[index].group.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: _currentRequestToGroups[index].status != "PG"
                    ? Text(
                        _currentRequestToGroups[index].getStatusLong(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  _currentRequestToGroups[index].status == "PG"
                      ? IconButton(
                          icon: new Icon(Icons.close, color: Colors.blue),
                          onPressed: () {
                            _changeStatus('CL', _currentRequestToGroups[index]);
                          })
                      : Container(),
                  _currentRequestToGroups[index].status == "PG"
                      ? IconButton(
                          icon: new Icon(Icons.check, color: Colors.blue),
                          onPressed: () {
                            //put request to change status to acc or close
                            //if put successfull then setState status to accordingly
                            _changeStatus('AC', _currentRequestToGroups[index]);
                          })
                      : Container()
                ],
              ),
            ],
          )),
    );
  }

  Widget RequestsPage() {
    return Container(
      color: Colors.redAccent,
      child: Center(
        child: ListView.builder(
          itemCount: _currentRequestToGroups.length == 0
              ? 1
              : _currentRequestToGroups.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // return the header
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: new Text(
                  "Requests to your groups",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                )),
              );
            }
            index -= 1;
            return RequestCell(context, index);
          },
        ),
      ),
    );
  }

  _getGroups() async {
    await this._setSiteUser();

    _webservice
        .fetchGroupsBasedOnSiteUserId(this._currentUser)
        .then((groupList) {
      setState(() {
        _ownerGroups = groupList;
      });
    });
  }

  _getUserGroups() {
    _webservice.fetchUserGroups().then((uGroups) {
      setState(() {
        _currentUserUserGroups = uGroups;
      });
    });
  }

  _getRequestGroups() {
    _webservice.fetchRequestGroups().then((uGroups) {
      setState(() {
        _currentRequestToGroups = uGroups;
      });
    });
  }

  _changeStatus(String status, RequestToGroup requestToGroup) async {
    String patchJson = '{"status":"' + status + '"}';
    String token = this._webservice.token.access;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      http.Response response = await http.patch(
          'http://192.168.1.108:8000/monitor/request-groups/' +
              requestToGroup.id.toString() +
              '/',
          headers: headers,
          body: patchJson);
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          requestToGroup.status = status;
        });
      } else {
        print("put not success");
      }
    } catch (e) {
      print(e);
    }
  }

  _changeGroupName(Group group, String name) async {
    String patchJson = '{"name":"' + group.name + '"}';
    String token = this._webservice.token.access;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      http.Response response = await http.patch(
          'http://192.168.1.108:8000/monitor/groups/' +
              group.id.toString() +
              '/',
          headers: headers,
          body: patchJson);
      print(response);
      if (response.statusCode == 200) {
        setState(() {
          group.setName(name);
        });
      } else {
        print("put not success");
      }
    } catch (e) {
      print(e);
    }
  }
}
