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
      child: Card(
          margin: EdgeInsets.fromLTRB(32, 8, 32, 8),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 12,
                child: new Center(
                    child: new Icon(
                  Icons.person,
                  size: MediaQuery.of(context).size.width / 6,
                )),
              ),
              this._nearbySiteUsers[index].display(),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      iconSize: 32,
                      icon: new Icon(Icons.supervised_user_circle,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDetailView(
                                    _webservice.token,
                                    _nearbySiteUsers[index])));
                      }),
                  IconButton(
                      iconSize: 32,
                      icon: new Icon(Icons.chat, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    _webservice, _nearbySiteUsers[index])));
                      }),
                ],
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: ListView.builder(
        itemCount: _nearbySiteUsers.length == 0 ? 1 : _nearbySiteUsers.length+1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // return the header
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: new Text(
                "Nearby Users",
                style: TextStyle(color: Colors.black, fontSize: 24),
              )),
            );
          }
          index -= 1;
          return SiteUserCell(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getNearbyUsers(),
        child: Icon(
          Icons.location_searching,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  _getCurrentLocation() async {
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

    var preciseLocality = first.locality;

    await this._webservice.makePatchRequest(preciseLocality);

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
