// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeModelImpl _$$EmployeeModelImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      designation: json['designation'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      joinDate: json['joinDate'] == null
          ? null
          : DateTime.parse(json['joinDate'] as String),
      department: json['department'] as String?,
      attendanceHistory: json['attendanceHistory'] == null
          ? const []
          : _attendanceListFromJson(json['attendanceHistory'] as List?),
    );

Map<String, dynamic> _$$EmployeeModelImplToJson(_$EmployeeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'designation': instance.designation,
      'email': instance.email,
      'phone': instance.phone,
      'status': instance.status,
      'avatarUrl': instance.avatarUrl,
      'joinDate': instance.joinDate?.toIso8601String(),
      'department': instance.department,
      'attendanceHistory': _attendanceListToJson(instance.attendanceHistory),
    };
