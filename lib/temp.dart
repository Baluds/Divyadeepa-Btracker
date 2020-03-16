import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
class VolmapsPage extends StatefulWidget {
  @override
  _VolmapsPageState createState() => _VolmapsPageState();
}

class _VolmapsPageState extends State<VolmapsPage> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
 Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

Future _addMarkerLongPressed(LatLng latlang) async {
    setState(() {
        final MarkerId markerId = MarkerId("RANDOM_ID");
        Marker marker = Marker(
            markerId: markerId,
            draggable: true,
            position: latlang, //With this parameter you automatically obtain latitude and longitude
            infoWindow: InfoWindow(
                title: "Marker here",
                snippet: 'This looks good',
            ),
            icon: BitmapDescriptor.defaultMarker,
        );

        _markers[markerId] = marker;
    });

    //This is optional, it will zoom when the marker has been created
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latlang, 17.0));
}


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
        onLongPress: (latlang) {
                        _addMarkerLongPressed(latlang);
                    },
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
      _markers[MarkerId("curr_loc")] = marker;
    });
  }



}
