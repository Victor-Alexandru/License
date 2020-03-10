import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/user.dart';

class HomePage extends StatefulWidget {
  User _currentUser;

  HomePage(User user) {
    this._currentUser = user;
  }

  @override
  _HomePageState createState() => _HomePageState(this._currentUser);
}

class _HomePageState extends State<HomePage> {
  // Position _currentPosition;
  String _currentUserId = '1';
  String _currentAddress;
  User _currentUser;
  String _apiPutUrl;
  var _nearbySiteUsers = new List<SiteUser>();

  _HomePageState(User user) {
    this._currentUser = user;
    _apiPutUrl =
        'http://192.168.1.108:8000/monitor/users/' + user.id.toString() + '/';
  }

  String _apiUsersUrl = 'http://192.168.1.108:8000/monitor/users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Find Nearby Location"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.location_searching),
              onPressed: () {
                _getNearbyUsers();
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _nearbySiteUsers.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(_nearbySiteUsers[index].firstName));
          },
        ));
  }

  _getCurrentLocation() async {
    print(" -----  _getCurrentLocation START ----- ");
    //code from flutter pub documentation
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();

    // here it ends --- how to get the Location object based on user location permissions

    // getting the locality based on latitude and longitude

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    var first = addresses.first;

    var preciseLocality = first.locality;

    print(" -----  _getCurrentLocation END ----- ");

    return preciseLocality;
  }

  _getUsers() {
    http.get(_apiUsersUrl).then((response) {
      print(response.body);
    });
  }

  _getNearbyUsers() async {
    var preciseLocality = await this._getCurrentLocation();
    Map<String, String> queryParameters = {
      'locality': preciseLocality,
    };

    var _getNearbtUsersUrlEnpoint =
        Uri.http('192.168.1.108:8000', 'monitor/site-users/', queryParameters);

    http.get(_getNearbtUsersUrlEnpoint).then((response) {
      // print(response.body);
      setState(() {
        Iterable list = json.decode(response.body);
        _nearbySiteUsers =
            list.map((model) => SiteUser.fromJson(model)).toList();
        print(_nearbySiteUsers);
      });
    });
  }
}

// made if the user wants to set it's location
// _makePatchRequest() async {
//   var preciseLocality = await this._getCurrentLocation();

//   String json = '{"location":"' + preciseLocality + '"}';

//   Map<String, String> headers = {"Content-type": "application/json"};

//   try {
//     Response response =
//         await http.patch(_apiPutUrl, headers: headers, body: json);

//     print(response);

//     if (response.statusCode == 200) {
//       print("put success");
//     } else {
//       print("put not success");
//     }
//   } catch (e) {
//     print(e);
//   }

//   //making a patch request to set the locality
// }
