import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class VolmapsPage extends StatefulWidget {
  @override
  _VolmapsPageState createState() => _VolmapsPageState();
}

class _VolmapsPageState extends State<VolmapsPage> {
  GoogleMapController mapController;
  final Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteers Map View'),
        backgroundColor: Colors.blue[500],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(12.2958, 76.6394),
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });
  }
}
