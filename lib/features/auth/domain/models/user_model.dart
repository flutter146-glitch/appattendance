// lib/features/auth/domain/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole { employee, manager, admin }

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required UserRole role,
    required String department,
    String? employeeId,
    String? phone,
    String? profileImage,
    String? token, // ← API ke liye
    @Default(false) bool biometricEnabled,
    @Default(false) bool mpinSet,
    @Default([]) List<dynamic> projects,
    DateTime? createdAt,
  }) = _UserModel;

  bool get isEmployee => role == UserRole.employee;
  bool get isManager => role == UserRole.manager;
  bool get isAdmin => role == UserRole.admin;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
