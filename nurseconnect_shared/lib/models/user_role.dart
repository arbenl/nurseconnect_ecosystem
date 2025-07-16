// lib/features/auth/domain/entities/user_role.dart
enum UserRole {
  patient,
  nurse,
  unknown, // Represents error or user not found in expected collections
}