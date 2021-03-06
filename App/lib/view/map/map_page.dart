import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leg_barkr_app/service/map_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  const MapPage({ Key? key }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    final prefs = await SharedPreferences.getInstance();
    final user = await FirebaseAuth.instance.currentUser!;
    final String token = await user.getIdToken();
    final String deviceId = prefs.getString("current_device") ?? "";
    final lastLocation = await MapService().getPetLastLocation(deviceId, token);
    final myLocation = await MapService().getMyLocation();

    setState(() {
      _markers.clear();
      final petMarker = Marker(
        markerId: MarkerId("pet_location"),
        position: LatLng(lastLocation.latitude, lastLocation.longitude),
        infoWindow: InfoWindow(title: "Pet location"));

      final myMarker = Marker(
        markerId: MarkerId("my_location"),
        position: LatLng(myLocation.latitude, myLocation.longitude),
        infoWindow: InfoWindow(title: "My location"));

      _markers["pet_location"] = petMarker;
      _markers["my_location"] = myMarker;
      _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(myLocation.latitude, myLocation.longitude)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(51.5, -0.12),
            zoom: 12.0,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}