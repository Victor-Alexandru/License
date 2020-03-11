class UserMessage {
  int _id;
  String _text;

  int get id => _id;

  String get text => _text;

  UserMessage.fromJson(Map json)
      : _id = json['id'],
        _text = json['text'];

  Map toJson() {
    return {
      'id': id,
      'text': _text,
    };
  }
}
