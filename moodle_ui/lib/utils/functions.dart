import 'package:moodle_ui/models/group.dart';
import 'package:moodle_ui/models/user-group.dart';

bool isUserInGroup(UserGroup userGroup, Group group) {
  //checks if a user is assigned to a group
  if (userGroup.groupId == group.id) return true;
  return false;
}

bool isUserInGroupFromUsersGroupList(List<UserGroup> userGroups, Group group) {
  for (UserGroup userGroup in userGroups) {
    if (userGroup.groupId == group.id) return true;
  }
  return false;
}

bool isUserInGroupListFromUsersGroupList(
    List<UserGroup> userGroups, List<Group> groups) {
  for (UserGroup userGroup in userGroups) {
    for (Group group in groups) if (userGroup.groupId == group.id) return true;
  }
  return false;
}

bool isUserInGroupOwnerFromUsersGroupList(
    List<UserGroup> userGroups, Group group) {
  for (UserGroup userGroup in userGroups) {
    if (userGroup.groupId == group.id && userGroup.isTeacher) return true;
  }
  return false;
}

bool isUserInGroupLearnerFromUsersGroupList(
    List<UserGroup> userGroups, Group group) {
  for (UserGroup userGroup in userGroups) {
    if (userGroup.groupId == group.id && userGroup.isLearner) return true;
  }
  return false;
}
