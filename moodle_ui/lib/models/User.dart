class User {
  String _username;
  String _password;
  String _email;
  int _id;

  User(this._username, this._password);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._id = obj["id"];
    this._password = obj["password"];
  }

  String get username => _username;

  String get password => _password;

  String get email => _email;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["id"] = _id;
    map["password"] = _password;

    return map;
  }

  User.fromJson(Map jsonDict)
      : _id = jsonDict['id'],
        _username = jsonDict['username'],
        _email = jsonDict['email'];

  @override
  String toString() {
    // TODO: implement toString
    return this._id.toString() +
        "   " +
        this._username +
        "   " +
        this._password;
  }
}
