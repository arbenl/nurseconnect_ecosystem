// lib/features/home/domain/entities/service_request_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nurseconnect_shared/utils/geopoint_converter.dart';
import 'package:nurseconnect_shared/utils/timestamp_converter.dart';

part 'service_request_data.freezed.dart';
part 'service_request_data.g.dart';

// Enum for request status for better type safety
enum ServiceRequestStatus {
  pending,          // Request created, waiting for an offer
  offered,          // System has offered the request to a specific nurse
  assigned,         // Nurse has accepted the offer
  nurseEnRoute,     // Nurse is traveling to the patient
  arrived,          // Nurse has arrived at the patient's location
  inProgress,       // Nurse has arrived and is delivering the service
  completed,        // Service is finished successfully
  cancelled,        // Request was cancelled
  failed,           // System failed to find a nurse
}

@freezed
class ServiceRequestData with _$ServiceRequestData {
  const factory ServiceRequestData({
    required String requestId, // Document ID
    required String patientId,
    required String patientName, // Denormalized for easy display
    @GeoPointConverter() required GeoPoint patientLocation,
    @TimestampConverter() required Timestamp requestTimestamp,
    required ServiceRequestStatus status,
    required String serviceDetails, // e.g., "Basic Service", or custom text
    String? assignedNurseId, // Nullable
    String? assignedNurseName, // Nullable, denormalized
    int? etaMinutes, // Nullable
    String? patientAddress, // Nullable
    String? travelMode,
    @TimestampConverter() Timestamp? completedAt,
    String? completionNotes,
    String? paymentMethodId,
  }) = _ServiceRequestData;

  factory ServiceRequestData.fromJson(Map<String, dynamic> json) => _$ServiceRequestDataFromJson(json);

  factory ServiceRequestData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceRequestData.fromJson(data).copyWith(requestId: doc.id);
  }
}
