// lib/features/auth/domain/models/user_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('Admin')
  admin,
  @JsonValue('Employee')
  employee,
  @JsonValue('Project Manager')
  projectManager,
  @JsonValue('Sr. Manager')
  srManager,
  @JsonValue('Operations Manager')
  operationsManager,
  @JsonValue('HR Manager')
  hrManager,
  @JsonValue('Finance Manager')
  financeManager,
  @JsonValue('Manager')
  manager,
  @JsonValue('Unknown')
  unknown,
}

enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('suspended')
  suspended,
  @JsonValue('terminated')
  terminated,
}

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  // YEHI SAB KUCH HAIN - KOI get isManager, get roleDisplay, get shortName YA KOI BHI COMPUTED GETTER YAHAN NAHI
  const factory UserModel({
    required String empId,
    required String orgShortName,
    required String name,
    required String email,
    String? phone,
    required UserRole role,
    String? department,
    String? designation,
    DateTime? joiningDate,
    @Default(UserStatus.active) UserStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<String> assignedProjectIds,
    @Default([]) List<String> projectNames,
    String? shiftId,
    String? reportingManagerId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// SARE COMPUTED GETTERS YAHAN AAYENGE (EXTENSION MEIN)
extension UserModelExtension on UserModel {
  bool get isManagerial =>
      role == UserRole.manager ||
      role == UserRole.projectManager ||
      role == UserRole.srManager ||
      role == UserRole.operationsManager ||
      role == UserRole.hrManager ||
      role == UserRole.financeManager ||
      role == UserRole.admin;

  bool get isActive => status == UserStatus.active;

  bool get canViewTeamAttendance => isManagerial;
  bool get canApproveAttendance =>
      role == UserRole.admin || role == UserRole.hrManager;
  bool get canApplyRegularisation => role == UserRole.employee;
  bool get canApproveRegularisation => isManagerial;
  bool get canViewTeamLeaves => isManagerial;
  bool get canApproveLeaves => isManagerial || role == UserRole.hrManager;
  bool get canManageEmployees =>
      role == UserRole.hrManager || role == UserRole.admin;

  String get displayRole {
    final roleName = role.toString().split('.').last;
    return roleName.replaceAllMapped(RegExp(r'([A-Z])'), (match) {
      return ' ${match.group(0)}';
    }).trim();
  }

  String get shortName {
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts.first : name;
  }
}

// Helper functions for DB
UserModel userFromDB(
  Map<String, dynamic> userRow,
  Map<String, dynamic> empRow,
) {
  return UserModel(
    empId: userRow['emp_id'] as String,
    orgShortName: empRow['org_short_name'] as String? ?? 'NUTANTEK',
    name: empRow['emp_name'] as String? ?? 'Unknown',
    email: empRow['emp_email'] as String? ?? userRow['email_id'] as String,
    phone: empRow['emp_phone'] as String?,
    role: _mapRole(empRow['emp_role'] as String?),
    department: empRow['emp_department'] as String?,
    designation: empRow['designation'] as String?,
    joiningDate: _parseDate(empRow['emp_joining_date'] as String?),
    status: _mapStatus(userRow['emp_status'] as String?),
    createdAt: _parseDate(userRow['created_at'] as String?),
    updatedAt: _parseDate(userRow['updated_at'] as String?),
  );
}

UserRole _mapRole(String? roleStr) {
  final lower = (roleStr ?? '').toLowerCase();
  if (lower.contains('admin')) return UserRole.admin;
  if (lower.contains('hr')) return UserRole.hrManager;
  if (lower.contains('finance')) return UserRole.financeManager;
  if (lower.contains('operations')) return UserRole.operationsManager;
  if (lower.contains('sr') || lower.contains('senior'))
    return UserRole.srManager;
  if (lower.contains('project')) return UserRole.projectManager;
  if (lower.contains('manager')) return UserRole.manager;
  return UserRole.employee;
}

UserStatus _mapStatus(String? status) {
  final lower = (status ?? '').toLowerCase();
  if (lower == 'inactive') return UserStatus.inactive;
  if (lower == 'suspended') return UserStatus.suspended;
  if (lower == 'terminated') return UserStatus.terminated;
  return UserStatus.active;
}

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null) return null;
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    return null;
  }
}

// // lib/features/auth/domain/models/user_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'user_model.freezed.dart';
// part 'user_model.g.dart';

// enum UserRole { employee, manager, admin }

// @freezed
// class UserModel with _$UserModel {
//   const UserModel._();

//   const factory UserModel({
//     required String id,
//     required String name,
//     required String email,
//     required UserRole role,
//     required String department,
//     String? employeeId,
//     String? phone,
//     String? profileImage,
//     String? token, // ← API ke liye
//     @Default(false) bool biometricEnabled,
//     @Default(false) bool mpinSet,
//     @Default([]) List<dynamic> projects,
//     DateTime? createdAt,
//   }) = _UserModel;

//   bool get isEmployee => role == UserRole.employee;
//   bool get isManager => role == UserRole.manager;
//   bool get isAdmin => role == UserRole.admin;

//   factory UserModel.fromJson(Map<String, dynamic> json) =>
//       _$UserModelFromJson(json);
// }
