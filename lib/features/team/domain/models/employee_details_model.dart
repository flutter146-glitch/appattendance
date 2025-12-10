// lib/features/team/domain/models/employee_model.dart
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_details_model.freezed.dart';
part 'employee_details_model.g.dart';

@freezed
class EmployeeModel with _$EmployeeModel {
  const factory EmployeeModel({
    required String id,
    required String name,
    required String designation,
    required String email,
    required String phone,
    String? status,
    String? avatarUrl,
    DateTime? joinDate,
    String? department,
    @JsonKey(fromJson: _attendanceListFromJson, toJson: _attendanceListToJson)
    @Default([])
    List<AttendanceModel> attendanceHistory,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}

// YE 2 FUNCTIONS ADD KAR (file ke end mein)
List<AttendanceModel> _attendanceListFromJson(List<dynamic>? list) {
  if (list == null) return [];
  return list
      .map((item) => AttendanceModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

List<Map<String, dynamic>> _attendanceListToJson(List<AttendanceModel> list) {
  return list.map((item) => item.toJson()).toList();
}
