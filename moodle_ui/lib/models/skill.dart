class Skill {
  int _id;
  String _name;

  Skill(this._name);

  String get name => _name;

  int get id => _id;

  Skill.fromJson(Map json)
      : _id = json['id'],
        _name = json['name'];

  @override
  String toString() {
    // TODO: implement toString
    return " Skill :  " + this._name + "   ";
  }
}
