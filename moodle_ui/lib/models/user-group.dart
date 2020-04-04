import 'package:moodle_ui/models/user.dart';

class UserGroup {
  int _id;
  bool _isTeacher;
  bool _isLearner;
  int _groupId;
  User _user;

  bool get isTeacher => _isTeacher;

  bool get isLearner => _isLearner;

  int get id => _id;

  int get groupId => _groupId;

  User get user => _user;

  UserGroup.fromJson(Map jsonDict)
      : _id = jsonDict['id'],
        _isTeacher = jsonDict['isTeacher'],
        _isLearner = jsonDict['isLearner'],
        _groupId = jsonDict['group'],
        _user = User.fromJson(jsonDict["user"]);

}
