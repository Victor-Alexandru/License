import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_ui/models/user-group.dart';
import 'package:moodle_ui/utils/functions.dart' as utils;

class UserDetailView extends StatefulWidget {
  SiteUser _nearbyUser;
  Token _token;

  UserDetailView(Token token, SiteUser nUser) {
    this._token = token;
    this._nearbyUser = nUser;
  }

  @override
  _UserDetailViewState createState() =>
      _UserDetailViewState(_token, _nearbyUser);
}

class _UserDetailViewState extends State<UserDetailView> {
  Token _token;
  SiteUser _nearbyUser;
  PageController _pageController;
  var _ownerGroups = new List<Group>();
  var _currentUserUserGroups = new List<UserGroup>();

  @override
  void initState() {
    super.initState();
    this._getGroups();
    this._getUserGroups();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _UserDetailViewState(Token token, SiteUser nUser) {
    this._token = token;
    this._nearbyUser = nUser;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.redAccent,
        body: PageView(
          controller: _pageController,
          children: [ProfilePage(), OwnerGroupProfilePage()],
        ),
      ),
    );
  }

  Widget ProfilePage() {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
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
                ))
              ],
            ),
          ),
        ),
      ],
    );
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
      _nearbyUser.firstName,
      style: _nameTextStyle,
    );
  }

  Widget GroupCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {},
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
                    (!utils.isUserInGroupFromUsersGroupList(
                        _currentUserUserGroups, _ownerGroups[index]))?
                    IconButton(
                        icon: new Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          ///make post to create a request to group
                          _postReqToCreateRequestToGroup(_ownerGroups[index]);
                        }):Container(),
                    utils.isUserInGroupFromUsersGroupList(
                            _currentUserUserGroups, _ownerGroups[index])
                        ? Icon(Icons.check, color: Colors.blue)
                        : Icon(Icons.close, color: Colors.blue),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget OwnerGroupProfilePage() {
    return Container(
      color: Colors.redAccent,
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Stack(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              Text(
                "User  " + this._nearbyUser.firstName + " owner groups ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ListView.builder(
            itemCount: _ownerGroups.length,
            itemBuilder: (context, index) => GroupCell(context, index),
          ),
        ]),
      ),
    );
  }

  _getGroups() {
    Map<String, String> queryParameters = {
      'owner_id': this._nearbyUser.id.toString(),
    };

    var _getYourGroupsUrlEnpoint =
        Uri.http('192.168.1.108:8000', 'monitor/groups/', queryParameters);
    String token = this._token.access;

    http.get(_getYourGroupsUrlEnpoint, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((response) {
      print(response.body);
      setState(() {
        Iterable list = json.decode(response.body);
        _ownerGroups = list.map((model) => Group.fromJson(model)).toList();
        print(_ownerGroups);
      });
    });
  }

  _getUserGroups() {
    var _getYourGroupsUrlEnpoint =
        Uri.http('192.168.1.108:8000', 'monitor/user-groups/', {});
    String token = this._token.access;

    http.get(_getYourGroupsUrlEnpoint, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((response) {
      print(response.body);
      setState(() {
        Iterable list = json.decode(response.body);
        _currentUserUserGroups =
            list.map((model) => UserGroup.fromJson(model)).toList();
        print(_currentUserUserGroups);
      });
    });
  }

  _postReqToCreateRequestToGroup(Group g) async {
    Map data = {
      'status': 'PG',
      'request_to': _nearbyUser.id.toString(),
      'group_id': g.id,
    };
    String body = json.encode(data);
    String token = this._token.access;

    print(body);
    await http
        .post(
      'http://192.168.1.108:8000/monitor/request-groups/',
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: body,
    )
        .then((response) {
      if (response.statusCode == 201) {
        print("REQUEST to group creat cu success");
      }
    });
  }
}
