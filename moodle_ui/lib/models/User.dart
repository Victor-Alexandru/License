class User {
  String _username;
  String _password;
  int _id;
  User(this._username, this._password);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._id = obj["id"];
    this._password = obj["password"];
  }

  String get username => _username;
  String get password => _password;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["id"] = _id;
    map["password"] = _password;

    return map;
  }

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
