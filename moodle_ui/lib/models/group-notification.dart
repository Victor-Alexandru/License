import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupNotification {
  int _id;
  String _message;
  String _color;
  String _prioriy;

  String get message => _message;

  String get color => _color;

  String get priority => _prioriy;

  GroupNotification.fromJson(Map jsonDict)
      : _id = jsonDict['id'],
        _message = jsonDict['message'],
        _color = jsonDict['color'],
        _prioriy = jsonDict['prioriy'];

  @override
  String toString() {
    // TODO: implement toString
    return this._message;
  }

  Widget GroupNotificationCard(){
    return Card(
        margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
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
                    this.message,
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(Icons.notifications, color: Colors.black,size: 25,),
            ],
          ),
        ));
  }
}
