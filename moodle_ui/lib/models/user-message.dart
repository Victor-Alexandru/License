import 'dart:convert';

class UserMessage {
  int _id;
  String _text;
  int _toUserMsg;

  int get id => _id;

  int get toUserMsg => _toUserMsg;

  String get text => _text;

  UserMessage.fromJson(Map json)
      : _id = json['id'],
        _text = json['text'],
        _toUserMsg = json['to_user_msg'];

  Map toJson() {
    return {
      'id': id,
      'text': _text,
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return "to  " + toUserMsg.toString();
  }
}
