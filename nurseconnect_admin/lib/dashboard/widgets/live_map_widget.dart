
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveMapWidget extends StatefulWidget {
  const LiveMapWidget({super.key});

  @override
  State<LiveMapWidget> createState() => _LiveMapWidgetState();
}

class _LiveMapWidgetState extends State<LiveMapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(34.052235, -118.243683), // Los Angeles
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    _listenToNurses();
    _listenToPatients();
  }

  void _listenToNurses() {
    FirebaseFirestore.instance.collection('nurses').where('isAvailable', isEqualTo: true).snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        final nurse = doc.data();
        final location = nurse['currentLocation'] as GeoPoint;
        final marker = Marker(
          markerId: MarkerId('nurse_${doc.id}'),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(title: nurse['name'] ?? 'Available Nurse'),
        );
        setState(() {
          _markers.add(marker);
        });
      }
    });
  }

  void _listenToPatients() {
    FirebaseFirestore.instance.collection('serviceRequests').where('status', whereIn: ['pending', 'offered', 'assigned', 'nurseEnRoute', 'inProgress']).snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        final request = doc.data();
        final location = request['patientLocation'] as GeoPoint;
        final marker = Marker(
          markerId: MarkerId('patient_${doc.id}'),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          infoWindow: InfoWindow(title: request['patientName'] ?? 'Patient Request'),
        );
        setState(() {
          _markers.add(marker);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kInitialPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
    );
  }
}
