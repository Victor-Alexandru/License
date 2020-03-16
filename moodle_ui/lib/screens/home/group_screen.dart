import 'package:flutter/material.dart';
import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/user.dart';

class GroupScreen extends StatefulWidget {
  User _currentUser;

  GroupScreen(User user) {
    this._currentUser = user;
  }

  @override
  _GroupScreenState createState() => _GroupScreenState(this._currentUser);
}

class _GroupScreenState extends State<GroupScreen> {
  // Position _currentPosition;
  User _currentUser;
  var _associateGroups = new List<Group>();

  _GroupScreenState(User user) {
    this._currentUser = user;
  }

  
  Widget GroupCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        print("Tap on " + _associateGroups[index].name);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             ChatScreen(_currentUser, _nearbySiteUsers[index])));
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
        title: Text("Find Nearby Users"),
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

}
