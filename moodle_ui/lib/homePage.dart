import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Position _currentPosition;
  String _currentAddress;
  // http://192.168.1.105:8000/monitor/users/
  String _apiUsersUrl = 'http://192.168.1.105:8000/monitor/users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // if (_currentPosition != null) Text(_currentAddress),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              child: Text("Set your location"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              child: Text("Find nearby  users"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              child: Text("Get Users"),
              onPressed: () {
                _getUsers();
              },
            )
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    print(" -----  You pressed here START ----- ");
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

    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    var first = addresses.first;

    print("${first.locality}");

    print(" -----  You pressed here END ----- ");
  }

  _getUsers() {
    http.get(_apiUsersUrl).then((response) {
      print(response.body);
    });
  }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);

  //     Placemark place = p[0];
  //     if (place != null) {
  //       setState(() {
  //         print("${place.locality}");
  //         _currentAddress =
  //             "${place.locality}, ${place.postalCode}, ${place.country}";
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
