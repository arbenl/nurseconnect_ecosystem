// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      themeMode: json['themeMode'] as String?,
      marketingConsent: json['marketingConsent'] as bool?,
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool?,
      activityLog:
          (json['activityLog'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList(),
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
      'profilePictureUrl': instance.profilePictureUrl,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'dateOfBirth': instance.dateOfBirth,
      'themeMode': instance.themeMode,
      'marketingConsent': instance.marketingConsent,
      'pushNotificationsEnabled': instance.pushNotificationsEnabled,
      'activityLog': instance.activityLog,
    };
