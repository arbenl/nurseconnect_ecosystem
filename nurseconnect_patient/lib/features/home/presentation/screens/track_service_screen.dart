import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/router/app_router.dart';
import 'package:nurseconnect_shared/nurseconnect_shared.dart';
import '../bloc/home_bloc.dart';
import 'package:nurseconnect_patient/core/utils/logger.dart';

class TrackServiceScreen extends StatefulWidget {
  const TrackServiceScreen({super.key});

  @override
  State<TrackServiceScreen> createState() => _TrackServiceScreenState();
}

class _TrackServiceScreenState extends State<TrackServiceScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = {};

  LatLng? _patientLocation;
  LatLng? _nurseLocation;
  StreamSubscription? _nurseLocationSubscription;

  @override
  void initState() {
    super.initState();
    // Listen to HomeBloc state changes to get active request and nurse ID
    context.read<HomeBloc>().stream.listen((state) {
      if (state.activeRequest != null) {
        _patientLocation = LatLng(
          state.activeRequest!.patientLocation.latitude,
          state.activeRequest!.patientLocation.longitude,
        );
        _updateMarkers();

        if (state.activeRequest!.assignedNurseId != null &&
            _nurseLocationSubscription == null) {
          _listenToNurseLocation(state.activeRequest!.assignedNurseId!);
        }
      } else {
        // If no active request, clear markers and subscriptions
        _markers.clear();
        _nurseLocationSubscription?.cancel();
        _nurseLocationSubscription = null;
        _patientLocation = null;
        _nurseLocation = null;
      }
    });
  }

  @override
  void dispose() {
    _nurseLocationSubscription?.cancel();
    super.dispose();
  }

  void _listenToNurseLocation(String nurseId) {
    AppLogger.log("Subscribing to nurse location for ID: $nurseId", tag: "TrackServiceScreen");
    _nurseLocationSubscription = FirebaseFirestore.instance
        .collection('nurses')
        .doc(nurseId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final GeoPoint? geoPoint = data['currentLocation'] as GeoPoint?;
        if (geoPoint != null) {
          setState(() {
            _nurseLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
            _updateMarkers();
          });
        }
      }
    }, onError: (error, stackTrace) {
      AppLogger.error("Error listening to nurse location", tag: "TrackServiceScreen", error: error, stackTrace: stackTrace);
    });
  }

  void _updateMarkers() {
    _markers.clear();

    if (_patientLocation != null) {
      _markers.add(Marker(
        markerId: const MarkerId('patient_location'),
        position: _patientLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));
    }

    if (_nurseLocation != null) {
      _markers.add(Marker(
        markerId: const MarkerId('nurse_location'),
        position: _nurseLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Nurse Location'),
      ));
    }

    // Move camera to show both markers if both are available
    if (_patientLocation != null && _nurseLocation != null) {
      _mapController.future.then((controller) {
        final LatLngBounds bounds = LatLngBounds(southwest: _patientLocation!,
northeast: _nurseLocation!); // Corrected: Use patient and nurse locations
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
      });
    } else if (_patientLocation != null) {
      _mapController.future.then((controller) {
        controller.animateCamera(CameraUpdate.newLatLngZoom(_patientLocation!, 15));
      });
    }

    setState(() {}); // Trigger rebuild to update markers on map
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>( // Keep BlocListener for logout etc.
        listener: (context, state) {
          if (state is HomeLogoutSuccess) {
            AppLogger.log("Logout success state detected by listener - Navigating to Login", tag: "TrackServiceScreen");
            context.goNamed(AppRoutes.login);
          }
          if (state is HomeError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ));
          } else if (state is HomeServiceRequestSuccess) { // <-- Add this block
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Service requested successfully! Searching for nurses...'),
              backgroundColor: Colors.green,
            ));
          }
        },
        child: Scaffold( // Scaffold moved inside listener's child for context access
          appBar: AppBar(
            title: const Text('Track Your Service'),
            automaticallyImplyLeading: false,
            actions: [
              Builder(
                builder: (buttonContext) => IconButton(
                  icon: const Icon(Icons.person),
                  tooltip: 'Profile',
                  onPressed: () {
                    buttonContext.goNamed(AppRoutes.patientProfile);
                  },
                ),
              ),
              Builder(
                builder: (buttonContext) => IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'Service History',
                  onPressed: () {
                    buttonContext.goNamed(AppRoutes.patientServiceHistory);
                  },
                ),
              ),
              Builder(
                builder: (buttonContext) => IconButton(
                  icon: const Icon(Icons.credit_card),
                  tooltip: 'Payment Methods',
                  onPressed: () {
                    buttonContext.goNamed(AppRoutes.paymentMethods);
                  },
                ),
              ),
              Builder(
                builder: (buttonContext) => IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () {
                    buttonContext.read<HomeBloc>().add(LogoutButtonPressed());
                  },
                ),
              ),
            ],
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final activeRequest = state.activeRequest;

              if (activeRequest != null &&
                  ![ServiceRequestStatus.completed,
                    ServiceRequestStatus.cancelled,
                    ServiceRequestStatus.failed,
                  ].contains(activeRequest.status)) // Simplified terminal states
              {
                // Display map and status overlay
                return Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _patientLocation ?? const LatLng(0, 0), // Default to 0,0 if patient location not yet available
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        _mapController.complete(controller);
                        _updateMarkers(); // Initial marker update after map is created
                      },
                      markers: _markers,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Request Status:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                activeRequest.status.name.toUpperCase(),
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              if (activeRequest.assignedNurseName != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Nurse: ${activeRequest.assignedNurseName}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                              if (activeRequest.etaMinutes != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'ETA: ${activeRequest.etaMinutes} mins',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                // Display initial request service button
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        const Text('Request basic nursing service to your location.', textAlign: TextAlign.center,),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.medical_services_outlined),
                          label: const Text('Request Basic Service Now'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            context.goNamed(AppRoutes.selectService);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
    );
  }
}