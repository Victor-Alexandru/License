import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  // Position _currentPosition;
  String _currentAddress;
  String _apiUsersUrl = 'http://192.168.1.102:8000/monitor/users';

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
    // geolocator
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
    //     .then((Position position) async {
    //   setState(() {
    //     _currentPosition = position;
    //   });
    //   await _getAddressFromLatLng();
    // }).catchError((e) {
    //   print(e);
    // });

    var location = new Location();
    var currentLocation;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      print(currentLocation.toString());
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }

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
