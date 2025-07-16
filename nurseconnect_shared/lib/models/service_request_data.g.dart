// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceRequestDataImpl _$$ServiceRequestDataImplFromJson(
  Map<String, dynamic> json,
) => _$ServiceRequestDataImpl(
  requestId: json['requestId'] as String,
  patientId: json['patientId'] as String,
  patientName: json['patientName'] as String,
  patientLocation: const GeoPointConverter().fromJson(
    json['patientLocation'] as Map<String, dynamic>,
  ),
  requestTimestamp: const TimestampConverter().fromJson(
    json['requestTimestamp'],
  ),
  status: $enumDecode(_$ServiceRequestStatusEnumMap, json['status']),
  serviceDetails: json['serviceDetails'] as String,
  assignedNurseId: json['assignedNurseId'] as String?,
  assignedNurseName: json['assignedNurseName'] as String?,
  etaMinutes: (json['etaMinutes'] as num?)?.toInt(),
  patientAddress: json['patientAddress'] as String?,
  travelMode: json['travelMode'] as String?,
  completedAt: const TimestampConverter().fromJson(json['completedAt']),
  completionNotes: json['completionNotes'] as String?,
  paymentMethodId: json['paymentMethodId'] as String?,
);

Map<String, dynamic> _$$ServiceRequestDataImplToJson(
  _$ServiceRequestDataImpl instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'patientId': instance.patientId,
  'patientName': instance.patientName,
  'patientLocation': const GeoPointConverter().toJson(instance.patientLocation),
  'requestTimestamp': const TimestampConverter().toJson(
    instance.requestTimestamp,
  ),
  'status': _$ServiceRequestStatusEnumMap[instance.status]!,
  'serviceDetails': instance.serviceDetails,
  'assignedNurseId': instance.assignedNurseId,
  'assignedNurseName': instance.assignedNurseName,
  'etaMinutes': instance.etaMinutes,
  'patientAddress': instance.patientAddress,
  'travelMode': instance.travelMode,
  'completedAt': _$JsonConverterToJson<dynamic, Timestamp>(
    instance.completedAt,
    const TimestampConverter().toJson,
  ),
  'completionNotes': instance.completionNotes,
  'paymentMethodId': instance.paymentMethodId,
};

const _$ServiceRequestStatusEnumMap = {
  ServiceRequestStatus.pending: 'pending',
  ServiceRequestStatus.offered: 'offered',
  ServiceRequestStatus.assigned: 'assigned',
  ServiceRequestStatus.nurseEnRoute: 'nurseEnRoute',
  ServiceRequestStatus.arrived: 'arrived',
  ServiceRequestStatus.inProgress: 'inProgress',
  ServiceRequestStatus.completed: 'completed',
  ServiceRequestStatus.cancelled: 'cancelled',
  ServiceRequestStatus.failed: 'failed',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
