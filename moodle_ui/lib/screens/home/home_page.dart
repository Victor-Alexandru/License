import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:moodle_ui/models/site-user.dart';
import 'package:moodle_ui/models/token.dart';
import 'package:moodle_ui/screens/chat/chat_screen.dart';
import 'package:moodle_ui/screens/user/user_detail_screen.dart';
import 'package:moodle_ui/service/WebService.dart';

class HomePage extends StatefulWidget {
  Webservice _webservice;

  HomePage(Webservice ws) {
    this._webservice = ws;
  }

  @override
  _HomePageState createState() => _HomePageState(this._webservice);
}

class _HomePageState extends State<HomePage> {
  // Position _currentPosition;
  Webservice _webservice;
  var _nearbySiteUsers = new List<SiteUser>();

  _HomePageState(Webservice ws) {
    this._webservice = ws;
  }

  Widget SiteUserCell(BuildContext ctx, int index) {
    return GestureDetector(
      onTap: () {
        print("Tap on " + _nearbySiteUsers[index].firstName);
      },
      child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      _nearbySiteUsers[index].firstName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                    icon: new Icon(Icons.supervised_user_circle,
                        color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserDetailView(
                                  _webservice.token, _nearbySiteUsers[index])));
                    }),
                IconButton(
                    icon: new Icon(Icons.chat, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  _webservice, _nearbySiteUsers[index])));
                    }),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Nearby Users"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_searching),
            onPressed: () {
              _getNearbyUsers();
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(children: <Widget>[
          ListView.builder(
            itemCount: _nearbySiteUsers.length,
            itemBuilder: (context, index) => SiteUserCell(context, index),
          ),
        ]),
      ),
    );
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

  _getNearbyUsers() async {
    var preciseLocality = await this._getCurrentLocation();
    _webservice.fetchNearbyUsers(preciseLocality).then((nearbyUsers) {
      setState(() {
        _nearbySiteUsers = nearbyUsers;
      });
    });
  }
}
