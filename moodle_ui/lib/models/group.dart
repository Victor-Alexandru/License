class Group {
  String _name;
  int _groupSize;
  int _estimatedWorkDuration;
  int _id;

  Group(this._name, this._groupSize, this._estimatedWorkDuration);

  Group.map(dynamic obj) {
    this._name = obj["name"];
    this._id = obj["id"];
    this._groupSize = obj["group_size"];
    this._estimatedWorkDuration = obj["estimated_work_duration"];
  }

  String get name => _name;

  int get id => _id;

  int get groupSize => _groupSize;

  int get estimatedWorkDuration => _estimatedWorkDuration;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["id"] = _id;
    map["group_size"] = _groupSize;
    map["estimated_work_duration"] = _estimatedWorkDuration;

    return map;
  }

  Group.fromJson(Map json)
      : _id = json['id'],
        _name = json['name'],
        _groupSize = json['group_size'],
        _estimatedWorkDuration = json['estimated_work_duration'];

  @override
  String toString() {
    // TODO: implement toString
    return this._id.toString() +
        "   " +
        this._name +
        "   " +
        this._groupSize.toString();
  }
}
