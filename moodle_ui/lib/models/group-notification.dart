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
}
