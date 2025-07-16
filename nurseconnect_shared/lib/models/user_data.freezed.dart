// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get uid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String? get profilePictureUrl => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get dateOfBirth => throw _privateConstructorUsedError;
  String? get themeMode => throw _privateConstructorUsedError;
  bool? get marketingConsent => throw _privateConstructorUsedError;
  bool? get pushNotificationsEnabled => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get activityLog =>
      throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call({
    String uid,
    String name,
    String email,
    String role,
    DateTime? createdAt,
    String? profilePictureUrl,
    String? phoneNumber,
    String? address,
    String? dateOfBirth,
    String? themeMode,
    bool? marketingConsent,
    bool? pushNotificationsEnabled,
    List<Map<String, dynamic>>? activityLog,
  });
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? createdAt = freezed,
    Object? profilePictureUrl = freezed,
    Object? phoneNumber = freezed,
    Object? address = freezed,
    Object? dateOfBirth = freezed,
    Object? themeMode = freezed,
    Object? marketingConsent = freezed,
    Object? pushNotificationsEnabled = freezed,
    Object? activityLog = freezed,
  }) {
    return _then(
      _value.copyWith(
            uid:
                null == uid
                    ? _value.uid
                    : uid // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            role:
                null == role
                    ? _value.role
                    : role // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            profilePictureUrl:
                freezed == profilePictureUrl
                    ? _value.profilePictureUrl
                    : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            phoneNumber:
                freezed == phoneNumber
                    ? _value.phoneNumber
                    : phoneNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as String?,
            dateOfBirth:
                freezed == dateOfBirth
                    ? _value.dateOfBirth
                    : dateOfBirth // ignore: cast_nullable_to_non_nullable
                        as String?,
            themeMode:
                freezed == themeMode
                    ? _value.themeMode
                    : themeMode // ignore: cast_nullable_to_non_nullable
                        as String?,
            marketingConsent:
                freezed == marketingConsent
                    ? _value.marketingConsent
                    : marketingConsent // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pushNotificationsEnabled:
                freezed == pushNotificationsEnabled
                    ? _value.pushNotificationsEnabled
                    : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            activityLog:
                freezed == activityLog
                    ? _value.activityLog
                    : activityLog // ignore: cast_nullable_to_non_nullable
                        as List<Map<String, dynamic>>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
    _$UserDataImpl value,
    $Res Function(_$UserDataImpl) then,
  ) = __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String name,
    String email,
    String role,
    DateTime? createdAt,
    String? profilePictureUrl,
    String? phoneNumber,
    String? address,
    String? dateOfBirth,
    String? themeMode,
    bool? marketingConsent,
    bool? pushNotificationsEnabled,
    List<Map<String, dynamic>>? activityLog,
  });
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
    _$UserDataImpl _value,
    $Res Function(_$UserDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? createdAt = freezed,
    Object? profilePictureUrl = freezed,
    Object? phoneNumber = freezed,
    Object? address = freezed,
    Object? dateOfBirth = freezed,
    Object? themeMode = freezed,
    Object? marketingConsent = freezed,
    Object? pushNotificationsEnabled = freezed,
    Object? activityLog = freezed,
  }) {
    return _then(
      _$UserDataImpl(
        uid:
            null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        role:
            null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        profilePictureUrl:
            freezed == profilePictureUrl
                ? _value.profilePictureUrl
                : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        phoneNumber:
            freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as String?,
        dateOfBirth:
            freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                    as String?,
        themeMode:
            freezed == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                    as String?,
        marketingConsent:
            freezed == marketingConsent
                ? _value.marketingConsent
                : marketingConsent // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pushNotificationsEnabled:
            freezed == pushNotificationsEnabled
                ? _value.pushNotificationsEnabled
                : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        activityLog:
            freezed == activityLog
                ? _value._activityLog
                : activityLog // ignore: cast_nullable_to_non_nullable
                    as List<Map<String, dynamic>>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataImpl implements _UserData {
  const _$UserDataImpl({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.createdAt,
    this.profilePictureUrl,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.themeMode,
    this.marketingConsent,
    this.pushNotificationsEnabled,
    final List<Map<String, dynamic>>? activityLog,
  }) : _activityLog = activityLog;

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  final String uid;
  @override
  final String name;
  @override
  final String email;
  @override
  final String role;
  @override
  final DateTime? createdAt;
  @override
  final String? profilePictureUrl;
  @override
  final String? phoneNumber;
  @override
  final String? address;
  @override
  final String? dateOfBirth;
  @override
  final String? themeMode;
  @override
  final bool? marketingConsent;
  @override
  final bool? pushNotificationsEnabled;
  final List<Map<String, dynamic>>? _activityLog;
  @override
  List<Map<String, dynamic>>? get activityLog {
    final value = _activityLog;
    if (value == null) return null;
    if (_activityLog is EqualUnmodifiableListView) return _activityLog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserData(uid: $uid, name: $name, email: $email, role: $role, createdAt: $createdAt, profilePictureUrl: $profilePictureUrl, phoneNumber: $phoneNumber, address: $address, dateOfBirth: $dateOfBirth, themeMode: $themeMode, marketingConsent: $marketingConsent, pushNotificationsEnabled: $pushNotificationsEnabled, activityLog: $activityLog)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.marketingConsent, marketingConsent) ||
                other.marketingConsent == marketingConsent) &&
            (identical(
                  other.pushNotificationsEnabled,
                  pushNotificationsEnabled,
                ) ||
                other.pushNotificationsEnabled == pushNotificationsEnabled) &&
            const DeepCollectionEquality().equals(
              other._activityLog,
              _activityLog,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    name,
    email,
    role,
    createdAt,
    profilePictureUrl,
    phoneNumber,
    address,
    dateOfBirth,
    themeMode,
    marketingConsent,
    pushNotificationsEnabled,
    const DeepCollectionEquality().hash(_activityLog),
  );

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(this);
  }
}

abstract class _UserData implements UserData {
  const factory _UserData({
    required final String uid,
    required final String name,
    required final String email,
    required final String role,
    final DateTime? createdAt,
    final String? profilePictureUrl,
    final String? phoneNumber,
    final String? address,
    final String? dateOfBirth,
    final String? themeMode,
    final bool? marketingConsent,
    final bool? pushNotificationsEnabled,
    final List<Map<String, dynamic>>? activityLog,
  }) = _$UserDataImpl;

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  String get uid;
  @override
  String get name;
  @override
  String get email;
  @override
  String get role;
  @override
  DateTime? get createdAt;
  @override
  String? get profilePictureUrl;
  @override
  String? get phoneNumber;
  @override
  String? get address;
  @override
  String? get dateOfBirth;
  @override
  String? get themeMode;
  @override
  bool? get marketingConsent;
  @override
  bool? get pushNotificationsEnabled;
  @override
  List<Map<String, dynamic>>? get activityLog;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
