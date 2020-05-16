import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/request-to-group.dart';
import 'package:moodle_ui/models/site-user.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          children: [ProfilePage(), OwnerGroupProfilePage(), RequestsPage()],
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
      _currentUser != null ? _currentUser.firstName : "Loading",
      style: _nameTextStyle,
    );
  }

  Widget GroupCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {},
      child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      _ownerGroups[index].name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " (" + _ownerGroups[index].skill.name + ")",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                    icon: new Icon(Icons.send, color: Colors.blue),
                    onPressed: () {}),
                utils.isUserInGroupFromUsersGroupList(
                        _currentUserUserGroups, _ownerGroups[index])
                    ? Icon(Icons.check, color: Colors.blue)
                    : Icon(Icons.close, color: Colors.blue),
              ],
            ),
          )),
    );
  }

  Widget OwnerGroupProfilePage() {
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
                this._currentUser != null
                    ? "User  " + this._currentUser.firstName + " owner groups "
                    : "Loading",
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

  Widget RequestCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {},
      child: Card(
          color: _currentRequestToGroups[index].status == "PG"
              ? Colors.green
              : Colors.red,
          margin: EdgeInsets.all(8),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      _currentRequestToGroups[index].requestFrom.username,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
          )),
    );
  }

  Widget RequestsPage() {
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
                " Pending requests to your groups  ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ListView.builder(
            itemCount: _currentRequestToGroups.length,
            itemBuilder: (context, index) => RequestCell(context, index),
          ),
        ]),
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
}
