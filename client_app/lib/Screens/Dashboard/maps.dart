import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with Route'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;

      // Add markers for start and end points
      _markers.add(
        Marker(
          markerId: MarkerId('start'),
          position: LatLng(37.7749, -122.4194), // Start point
          infoWindow: InfoWindow(title: 'Start'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('end'),
          position: LatLng(37.7749, -122.4294), // End point
          infoWindow: InfoWindow(title: 'End'),
        ),
      );

      // Add polyline for route
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: [
            LatLng(37.7749, -122.4194), // Start point
            LatLng(37.7749, -122.4294), // End point
          ],
          color: Colors.blue,
          width: 3,
        ),
      );
    });
  }
}
