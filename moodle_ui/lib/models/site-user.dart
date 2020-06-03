import 'package:flutter/material.dart';

class SiteUser {
  int id;
  String firstName;
  String surname;
  String location;
  String description;


  SiteUser(int id, String firstName, String surname, String location) {
    this.id = id;
    this.firstName = firstName;
    this.location = location;
  }

  SiteUser.fromJson(Map json)
      : id = json['id'],
        firstName = json['first_name'],
        surname = json['surname'],
        description = json['description'],
        location = json['location'];

  Map toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'surname': surname,
      'location': location
    };
  }

  Widget display() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        this.firstName,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
