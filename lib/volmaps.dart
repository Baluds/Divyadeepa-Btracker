import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as e1;
import 'dart:async';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolmapsPage extends StatefulWidget {
  @override
  _VolmapsPageState createState() => _VolmapsPageState();
}

class _VolmapsPageState extends State<VolmapsPage> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Location location = new Location();
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  String test;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteers Map View'),
        backgroundColor: Colors.blue[500],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(12.2958, 76.6394),
          zoom: 11.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        compassEnabled: true,
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _getLocation(test) async {
    var currentLocation = await e1.Geolocator()
        .getCurrentPosition(desiredAccuracy: e1.LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: test + 's pile'),
        draggable: true,
        onTap: () {},
      );
      _markers[MarkerId("curr_loc")] = marker;
    });
  }

  Future<DocumentReference> _addGeoPoint(test) async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore.collection('locations').add({
      'geopoint': point.data,
      'name': test,
    });
  }

  _showDialog() async {
    TextEditingController _firsttb = new TextEditingController();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: _firsttb,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Volunteer Name', hintText: 'Enter your name'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Submit'),
              onPressed: () {
                test = _firsttb.text;
                _getLocation(test);
                _addGeoPoint(test);
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
