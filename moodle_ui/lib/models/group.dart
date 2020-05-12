import 'package:flutter/material.dart';
import 'package:moodle_ui/models/skill.dart';

class Group {
  String _name;
  int _groupSize;
  int _estimatedWorkDuration;
  int _id;
  Skill _skill;

  Group(this._name, this._groupSize, this._estimatedWorkDuration);

  Group.map(dynamic obj) {
    this._name = obj["name"];
    this._id = obj["id"];
    this._groupSize = obj["group_size"];
    this._estimatedWorkDuration = obj["estimated_work_duration"];
  }

  String get name => _name;

  int get id => _id;

  int get groupSize => _groupSize;

  int get estimatedWorkDuration => _estimatedWorkDuration;

  Skill get skill => _skill;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["id"] = _id;
    map["group_size"] = _groupSize;
    map["estimated_work_duration"] = _estimatedWorkDuration;

    return map;
  }

  Group.fromJson(Map jsonDict)
      : _id = jsonDict['id'],
        _name = jsonDict['name'],
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
                    this.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " (" + this.skill.name + ")",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(Icons.group, color: Colors.blue),
            ],
          ),
        ));
  }
}
