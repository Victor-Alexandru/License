import 'package:flutter/material.dart';
import 'package:moodle_ui/models/skill.dart';
import 'package:moodle_ui/service/WebService.dart';

class Group {
  String _name;
  int _groupSize;
  int _estimatedWorkDuration;
  int _id;
  int _ownerId;
  Skill _skill;

  Group(this._name, this._groupSize, this._estimatedWorkDuration);

  Group.map(dynamic obj) {
    this._name = obj["name"];
    this._id = obj["id"];
    this._ownerId = obj["owner"];
    this._groupSize = obj["group_size"];
    this._estimatedWorkDuration = obj["estimated_work_duration"];
  }

  String get name => _name;

  void setName(name) => _name = name;

  void setId(id) => _id = id;

  void setSkill(skill) => _skill = skill;

  int get id => _id;

  int get ownerId => _ownerId;

  int get groupSize => _groupSize;

  int get estimatedWorkDuration => _estimatedWorkDuration;

  Skill get skill => _skill;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["id"] = _id;
    map["owner"] = _ownerId;
    map["group_size"] = _groupSize;
    map["estimated_work_duration"] = _estimatedWorkDuration;

    return map;
  }

  Group.fromJson(Map jsonDict)
      : _id = jsonDict['id'],
        _name = jsonDict['name'],
        _ownerId = jsonDict['owner'],
        _groupSize = jsonDict['group_size'],
        _estimatedWorkDuration = jsonDict['estimated_work_duration'],
        _skill = Skill.fromJson(jsonDict["skill"]);

  @override
  String toString() {
    // TODO: implement toString
    return this._id.toString() +
        "   " +
        this._name +
        "   " +
        this._groupSize.toString();
  }

  Widget GroupCardView() {
    return Card(
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
                  this.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
                child: Center(
              child: Text(
                this.skill.name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget GroupProfileView(Webservice ws) {
    return Card(
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
                  this.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
                child: Center(
              child: Text(
                this.skill.name,
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
                    onPressed: () {
                      ws.makeDeleteGroupRequest(this.id);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
