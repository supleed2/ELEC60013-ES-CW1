import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leg_barkr_app/service/map_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({ Key? key }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;

  // This will be changed, to center around the dog (once app reads metrics from the server)
  final LatLng _center = const LatLng(51.498356, -0.176894);

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final lastLocation = await MapService().getLastLocation("132-567-001");  // change this.
    setState(() {
      _markers.clear();
      print(lastLocation.longitude);
      final petMarker = Marker(
        markerId: MarkerId("pet_location"),
        position: LatLng(lastLocation.latitude, lastLocation.longitude),
        infoWindow: InfoWindow(
          title: "Pet location",
        ),
      );
      _markers["pet_location"] = petMarker;
      print(_markers["pet_location"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}