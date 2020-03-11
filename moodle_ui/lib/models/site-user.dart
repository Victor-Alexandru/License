class SiteUser {
  int id;
  String firstName;
  String surname;
  String location;

  SiteUser(int id, String firstName, String surname, String location) {
    this.id = id;
    this.firstName = firstName;
    this.location = location;
  }

  SiteUser.fromJson(Map json)
      : id = json['id'],
        firstName = json['first_name'],
        surname = json['surname'],
        location = json['location'];

  Map toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'surname': surname,
      'location': location
    };
  }
}