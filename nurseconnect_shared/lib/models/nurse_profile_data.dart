// lib/features/home/domain/entities/nurse_profile_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NurseProfileData extends Equatable {
  final String uid;
  final String name;
  final String email;
  final bool isAvailable;
  // Add other fields like location, geohash as needed later
  final GeoPoint? currentLocation;
  final String? geohash;

  const NurseProfileData({
    required this.uid,
    required this.name,
    required this.email,
    required this.isAvailable,
    this.currentLocation,
    this.geohash,
  });

  // Factory to create from Firestore snapshot data Map
  // Note: It's of›ten good practice to keep Firestore-specific parsing
  // in the data layer (repository or data source), but having it here
  // can be convenient if the Bloc directly receives map data.
  factory NurseProfileData.fromMap(String uid, Map<String, dynamic> data) {
    return NurseProfileData(
      uid: uid, // Use passed UID
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      isAvailable: data['isAvailable'] ?? false, // Default if missing
      // Parse other fields if they exist
      currentLocation: data['currentLocation'] as GeoPoint?,
      geohash: data['geohash'] as String?,
    );
  }

  // copyWith method to create a new instance with updated values
  NurseProfileData copyWith({
    // Only include fields you expect the Bloc to update via copyWith
    bool? isAvailable,
    GeoPoint? currentLocation, // Add if needed
    String? geohash,          // Add if needed
  }) {
    return NurseProfileData(
      uid: uid, // Keep original values for non-updated fields
      name: name,
      email: email,
      isAvailable: isAvailable ?? this.isAvailable, // Use new value or fallback to current
      currentLocation: currentLocation ?? this.currentLocation,
      geohash: geohash ?? this.geohash,
    );
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    isAvailable,
    currentLocation,
    geohash,
  ];
}