import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/user.dart';

class RequestToGroup {
  int _id;
  int _requestTo;
  String _status;
  User _requestFrom;

  Group _group;

  String get status => _status;

  void set status(String status) {
    _status = status;
  }

  int get id => _id;

  int get requestTo => _requestTo;

  User get requestFrom => _requestFrom;

  Group get group => _group;

  RequestToGroup.fromJson(Map jsonDict)
      : _id = jsonDict['id'],
        _requestTo = jsonDict['request_to'],
        _status = jsonDict['status'],
        _requestFrom = User.fromJson(jsonDict["request_from"]),
        _group = Group.fromJson(jsonDict["group"]);
}
