// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_request_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceRequestData _$ServiceRequestDataFromJson(Map<String, dynamic> json) {
  return _ServiceRequestData.fromJson(json);
}

/// @nodoc
mixin _$ServiceRequestData {
  String get requestId => throw _privateConstructorUsedError; // Document ID
  String get patientId => throw _privateConstructorUsedError;
  String get patientName =>
      throw _privateConstructorUsedError; // Denormalized for easy display
  @GeoPointConverter()
  GeoPoint get patientLocation => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp get requestTimestamp => throw _privateConstructorUsedError;
  ServiceRequestStatus get status => throw _privateConstructorUsedError;
  String get serviceDetails =>
      throw _privateConstructorUsedError; // e.g., "Basic Service", or custom text
  String? get assignedNurseId => throw _privateConstructorUsedError; // Nullable
  String? get assignedNurseName =>
      throw _privateConstructorUsedError; // Nullable, denormalized
  int? get etaMinutes => throw _privateConstructorUsedError; // Nullable
  String? get patientAddress => throw _privateConstructorUsedError; // Nullable
  String? get travelMode => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get completedAt => throw _privateConstructorUsedError;
  String? get completionNotes => throw _privateConstructorUsedError;
  String? get paymentMethodId => throw _privateConstructorUsedError;

  /// Serializes this ServiceRequestData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceRequestDataCopyWith<ServiceRequestData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceRequestDataCopyWith<$Res> {
  factory $ServiceRequestDataCopyWith(
    ServiceRequestData value,
    $Res Function(ServiceRequestData) then,
  ) = _$ServiceRequestDataCopyWithImpl<$Res, ServiceRequestData>;
  @useResult
  $Res call({
    String requestId,
    String patientId,
    String patientName,
    @GeoPointConverter() GeoPoint patientLocation,
    @TimestampConverter() Timestamp requestTimestamp,
    ServiceRequestStatus status,
    String serviceDetails,
    String? assignedNurseId,
    String? assignedNurseName,
    int? etaMinutes,
    String? patientAddress,
    String? travelMode,
    @TimestampConverter() Timestamp? completedAt,
    String? completionNotes,
    String? paymentMethodId,
  });
}

/// @nodoc
class _$ServiceRequestDataCopyWithImpl<$Res, $Val extends ServiceRequestData>
    implements $ServiceRequestDataCopyWith<$Res> {
  _$ServiceRequestDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? patientLocation = null,
    Object? requestTimestamp = null,
    Object? status = null,
    Object? serviceDetails = null,
    Object? assignedNurseId = freezed,
    Object? assignedNurseName = freezed,
    Object? etaMinutes = freezed,
    Object? patientAddress = freezed,
    Object? travelMode = freezed,
    Object? completedAt = freezed,
    Object? completionNotes = freezed,
    Object? paymentMethodId = freezed,
  }) {
    return _then(
      _value.copyWith(
            requestId:
                null == requestId
                    ? _value.requestId
                    : requestId // ignore: cast_nullable_to_non_nullable
                        as String,
            patientId:
                null == patientId
                    ? _value.patientId
                    : patientId // ignore: cast_nullable_to_non_nullable
                        as String,
            patientName:
                null == patientName
                    ? _value.patientName
                    : patientName // ignore: cast_nullable_to_non_nullable
                        as String,
            patientLocation:
                null == patientLocation
                    ? _value.patientLocation
                    : patientLocation // ignore: cast_nullable_to_non_nullable
                        as GeoPoint,
            requestTimestamp:
                null == requestTimestamp
                    ? _value.requestTimestamp
                    : requestTimestamp // ignore: cast_nullable_to_non_nullable
                        as Timestamp,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as ServiceRequestStatus,
            serviceDetails:
                null == serviceDetails
                    ? _value.serviceDetails
                    : serviceDetails // ignore: cast_nullable_to_non_nullable
                        as String,
            assignedNurseId:
                freezed == assignedNurseId
                    ? _value.assignedNurseId
                    : assignedNurseId // ignore: cast_nullable_to_non_nullable
                        as String?,
            assignedNurseName:
                freezed == assignedNurseName
                    ? _value.assignedNurseName
                    : assignedNurseName // ignore: cast_nullable_to_non_nullable
                        as String?,
            etaMinutes:
                freezed == etaMinutes
                    ? _value.etaMinutes
                    : etaMinutes // ignore: cast_nullable_to_non_nullable
                        as int?,
            patientAddress:
                freezed == patientAddress
                    ? _value.patientAddress
                    : patientAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            travelMode:
                freezed == travelMode
                    ? _value.travelMode
                    : travelMode // ignore: cast_nullable_to_non_nullable
                        as String?,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as Timestamp?,
            completionNotes:
                freezed == completionNotes
                    ? _value.completionNotes
                    : completionNotes // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentMethodId:
                freezed == paymentMethodId
                    ? _value.paymentMethodId
                    : paymentMethodId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceRequestDataImplCopyWith<$Res>
    implements $ServiceRequestDataCopyWith<$Res> {
  factory _$$ServiceRequestDataImplCopyWith(
    _$ServiceRequestDataImpl value,
    $Res Function(_$ServiceRequestDataImpl) then,
  ) = __$$ServiceRequestDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String requestId,
    String patientId,
    String patientName,
    @GeoPointConverter() GeoPoint patientLocation,
    @TimestampConverter() Timestamp requestTimestamp,
    ServiceRequestStatus status,
    String serviceDetails,
    String? assignedNurseId,
    String? assignedNurseName,
    int? etaMinutes,
    String? patientAddress,
    String? travelMode,
    @TimestampConverter() Timestamp? completedAt,
    String? completionNotes,
    String? paymentMethodId,
  });
}

/// @nodoc
class __$$ServiceRequestDataImplCopyWithImpl<$Res>
    extends _$ServiceRequestDataCopyWithImpl<$Res, _$ServiceRequestDataImpl>
    implements _$$ServiceRequestDataImplCopyWith<$Res> {
  __$$ServiceRequestDataImplCopyWithImpl(
    _$ServiceRequestDataImpl _value,
    $Res Function(_$ServiceRequestDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceRequestData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? patientLocation = null,
    Object? requestTimestamp = null,
    Object? status = null,
    Object? serviceDetails = null,
    Object? assignedNurseId = freezed,
    Object? assignedNurseName = freezed,
    Object? etaMinutes = freezed,
    Object? patientAddress = freezed,
    Object? travelMode = freezed,
    Object? completedAt = freezed,
    Object? completionNotes = freezed,
    Object? paymentMethodId = freezed,
  }) {
    return _then(
      _$ServiceRequestDataImpl(
        requestId:
            null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                    as String,
        patientId:
            null == patientId
                ? _value.patientId
                : patientId // ignore: cast_nullable_to_non_nullable
                    as String,
        patientName:
            null == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                    as String,
        patientLocation:
            null == patientLocation
                ? _value.patientLocation
                : patientLocation // ignore: cast_nullable_to_non_nullable
                    as GeoPoint,
        requestTimestamp:
            null == requestTimestamp
                ? _value.requestTimestamp
                : requestTimestamp // ignore: cast_nullable_to_non_nullable
                    as Timestamp,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as ServiceRequestStatus,
        serviceDetails:
            null == serviceDetails
                ? _value.serviceDetails
                : serviceDetails // ignore: cast_nullable_to_non_nullable
                    as String,
        assignedNurseId:
            freezed == assignedNurseId
                ? _value.assignedNurseId
                : assignedNurseId // ignore: cast_nullable_to_non_nullable
                    as String?,
        assignedNurseName:
            freezed == assignedNurseName
                ? _value.assignedNurseName
                : assignedNurseName // ignore: cast_nullable_to_non_nullable
                    as String?,
        etaMinutes:
            freezed == etaMinutes
                ? _value.etaMinutes
                : etaMinutes // ignore: cast_nullable_to_non_nullable
                    as int?,
        patientAddress:
            freezed == patientAddress
                ? _value.patientAddress
                : patientAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        travelMode:
            freezed == travelMode
                ? _value.travelMode
                : travelMode // ignore: cast_nullable_to_non_nullable
                    as String?,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as Timestamp?,
        completionNotes:
            freezed == completionNotes
                ? _value.completionNotes
                : completionNotes // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentMethodId:
            freezed == paymentMethodId
                ? _value.paymentMethodId
                : paymentMethodId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceRequestDataImpl implements _ServiceRequestData {
  const _$ServiceRequestDataImpl({
    required this.requestId,
    required this.patientId,
    required this.patientName,
    @GeoPointConverter() required this.patientLocation,
    @TimestampConverter() required this.requestTimestamp,
    required this.status,
    required this.serviceDetails,
    this.assignedNurseId,
    this.assignedNurseName,
    this.etaMinutes,
    this.patientAddress,
    this.travelMode,
    @TimestampConverter() this.completedAt,
    this.completionNotes,
    this.paymentMethodId,
  });

  factory _$ServiceRequestDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceRequestDataImplFromJson(json);

  @override
  final String requestId;
  // Document ID
  @override
  final String patientId;
  @override
  final String patientName;
  // Denormalized for easy display
  @override
  @GeoPointConverter()
  final GeoPoint patientLocation;
  @override
  @TimestampConverter()
  final Timestamp requestTimestamp;
  @override
  final ServiceRequestStatus status;
  @override
  final String serviceDetails;
  // e.g., "Basic Service", or custom text
  @override
  final String? assignedNurseId;
  // Nullable
  @override
  final String? assignedNurseName;
  // Nullable, denormalized
  @override
  final int? etaMinutes;
  // Nullable
  @override
  final String? patientAddress;
  // Nullable
  @override
  final String? travelMode;
  @override
  @TimestampConverter()
  final Timestamp? completedAt;
  @override
  final String? completionNotes;
  @override
  final String? paymentMethodId;

  @override
  String toString() {
    return 'ServiceRequestData(requestId: $requestId, patientId: $patientId, patientName: $patientName, patientLocation: $patientLocation, requestTimestamp: $requestTimestamp, status: $status, serviceDetails: $serviceDetails, assignedNurseId: $assignedNurseId, assignedNurseName: $assignedNurseName, etaMinutes: $etaMinutes, patientAddress: $patientAddress, travelMode: $travelMode, completedAt: $completedAt, completionNotes: $completionNotes, paymentMethodId: $paymentMethodId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceRequestDataImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.patientLocation, patientLocation) ||
                other.patientLocation == patientLocation) &&
            (identical(other.requestTimestamp, requestTimestamp) ||
                other.requestTimestamp == requestTimestamp) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.serviceDetails, serviceDetails) ||
                other.serviceDetails == serviceDetails) &&
            (identical(other.assignedNurseId, assignedNurseId) ||
                other.assignedNurseId == assignedNurseId) &&
            (identical(other.assignedNurseName, assignedNurseName) ||
                other.assignedNurseName == assignedNurseName) &&
            (identical(other.etaMinutes, etaMinutes) ||
                other.etaMinutes == etaMinutes) &&
            (identical(other.patientAddress, patientAddress) ||
                other.patientAddress == patientAddress) &&
            (identical(other.travelMode, travelMode) ||
                other.travelMode == travelMode) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.completionNotes, completionNotes) ||
                other.completionNotes == completionNotes) &&
            (identical(other.paymentMethodId, paymentMethodId) ||
                other.paymentMethodId == paymentMethodId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    requestId,
    patientId,
    patientName,
    patientLocation,
    requestTimestamp,
    status,
    serviceDetails,
    assignedNurseId,
    assignedNurseName,
    etaMinutes,
    patientAddress,
    travelMode,
    completedAt,
    completionNotes,
    paymentMethodId,
  );

  /// Create a copy of ServiceRequestData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceRequestDataImplCopyWith<_$ServiceRequestDataImpl> get copyWith =>
      __$$ServiceRequestDataImplCopyWithImpl<_$ServiceRequestDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceRequestDataImplToJson(this);
  }
}

abstract class _ServiceRequestData implements ServiceRequestData {
  const factory _ServiceRequestData({
    required final String requestId,
    required final String patientId,
    required final String patientName,
    @GeoPointConverter() required final GeoPoint patientLocation,
    @TimestampConverter() required final Timestamp requestTimestamp,
    required final ServiceRequestStatus status,
    required final String serviceDetails,
    final String? assignedNurseId,
    final String? assignedNurseName,
    final int? etaMinutes,
    final String? patientAddress,
    final String? travelMode,
    @TimestampConverter() final Timestamp? completedAt,
    final String? completionNotes,
    final String? paymentMethodId,
  }) = _$ServiceRequestDataImpl;

  factory _ServiceRequestData.fromJson(Map<String, dynamic> json) =
      _$ServiceRequestDataImpl.fromJson;

  @override
  String get requestId; // Document ID
  @override
  String get patientId;
  @override
  String get patientName; // Denormalized for easy display
  @override
  @GeoPointConverter()
  GeoPoint get patientLocation;
  @override
  @TimestampConverter()
  Timestamp get requestTimestamp;
  @override
  ServiceRequestStatus get status;
  @override
  String get serviceDetails; // e.g., "Basic Service", or custom text
  @override
  String? get assignedNurseId; // Nullable
  @override
  String? get assignedNurseName; // Nullable, denormalized
  @override
  int? get etaMinutes; // Nullable
  @override
  String? get patientAddress; // Nullable
  @override
  String? get travelMode;
  @override
  @TimestampConverter()
  Timestamp? get completedAt;
  @override
  String? get completionNotes;
  @override
  String? get paymentMethodId;

  /// Create a copy of ServiceRequestData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceRequestDataImplCopyWith<_$ServiceRequestDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
