import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String uid,
    required String name,
    required String email,
    required String role,
    DateTime? createdAt,
    String? profilePictureUrl,
    String? phoneNumber,
    String? address,
    String? dateOfBirth,
    String? themeMode,
    bool? marketingConsent,
    bool? pushNotificationsEnabled,
    List<Map<String, dynamic>>? activityLog,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  factory UserData.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return UserData.fromJson(data);
  }
}

