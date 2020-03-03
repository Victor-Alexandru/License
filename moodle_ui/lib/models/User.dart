// class User {
//   int _id;
//   String _first_name;
//   String _surname;
//   String _user_name;
//   String _password;
//   String _location;
//   String _email;

//   int get id => _id;

//   set id(int id) {
//     _id = id;
//   }

//   String get first_name => _first_name;

//   set first_name(String first_name) {
//     _first_name = first_name;
//   }

//   String get surname => _surname;

//   set surname(String surname) {
//     _surname = surname;
//   }

//   String get user_name => _user_name;

//   set user_name(String user_name) {
//     _user_name = user_name;
//   }

//   String get password => _password;

//   set password(String password) {
//     _password = password;
//   }

//   String get location => _location;

//   set location(String password) {
//     _location = location;
//   }

//   String get email => _email;

//   set email(String email) {
//     _email = email;
//   }

//   User.fromJson(Map<String, dynamic> json)
//       : _id = json['id'],
//         _first_name = json['first_name'].toString(),
//         _surname = json['surname'].toString(),
//         _user_name = json['user_name'].toString(),
//         _password = json['password'].toString(),
//         _email = json['email'].toString(),
//         _location = json['location'].toString();

//   Map<String, dynamic> toMap() {
//     var map = new Map<String, dynamic>();
//     map['id'] = _id;
//     map["first_name"] = _first_name;
//     map["surname"] = _surname;
//     map["user_name"] = _user_name;
//     map["password"] = _password;
//     map["location"] = _location;
//     map["email"] = _email;

//     return map;
//   }

//   User.map(dynamic obj) {
//     this._id = obj["id"];
//     this._first_name = obj["first_name"];
//     this._surname = obj["surname"];
//     this._user_name = obj["user_name"];
//     this._password = obj["password"];
//     this._location = obj["location"];
//     this._email = obj["email"];
//   }

//   User(
//     String first_name,
//     String surname,
//     String user_name,
//     String password,
//     String location,
//     String email,
//   ) {
//     _first_name = first_name;
//     _surname = surname;
//     _user_name = user_name;
//     _password = password;
//     _location = location;
//     _email = email;
//   }
// }
class User {
  String _username;
  String _password;
  User(this._username, this._password);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];
  }

  String get username => _username;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;

    return map;
  }
}
