import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart' as e1;
import 'dart:async';
//import 'package:location/location.dart';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;
  var gudpeeps = [];
  final LatLng _center = const LatLng(12.2958, 76.6394);
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  void initState() {
    super.initState();

    populategudpeeps();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  populategudpeeps() {
    _markers.clear();
    gudpeeps = [];
    Firestore.instance.collection('locations').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          gudpeeps.add(docs.documents[i].data);
          initMarker(i, docs.documents[i].data, docs.documents[i].documentID);
          //print(i);
        }
      }
    });
  }

  initMarker(index, gudpeeps, dcid) {
    var markerIdVal = dcid;
    setState(() {
      final MarkerId markerId = MarkerId(markerIdVal);
      var g = gudpeeps['geopoint']['geopoint'] as GeoPoint;
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(g.latitude, g.longitude),
        draggable: false,
        infoWindow: InfoWindow(title: gudpeeps['name']),
        onTap: () {
          _showDialog(index);
        },
        visible: true,
      );
      _markers[markerId] = marker;
      //print(_markers);
    });
  }

  _showDialog(index) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: new Text('Do you want to clear the marker?'),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                deleteop(index);
                Future.delayed(const Duration(seconds: 2), () {
                  populategudpeeps();
                });
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('No(check bottom left for directions)'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  deleteop(index) async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("locations").getDocuments();
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(snapshot.documents[index].reference);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vans Map View'),
        backgroundColor: Colors.blue[500],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
          },
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: Set<Marker>.of(_markers.values),
        //_markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          populategudpeeps();
          //print(_markers.values);
        },
        tooltip: 'Collect',
        child: Icon(Icons.featured_play_list),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
