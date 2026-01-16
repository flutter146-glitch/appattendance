// lib/features/projects/domain/models/task_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskStatus { assigned, inProgress, resolved, closed, pending, open }

enum TaskPriority { urgent, high, medium, normal }

@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String taskId,
    required String projectId,
    required String projectName,
    required String taskName,
    required String type, // e.g., Bug, Feature, Testing
    required TaskPriority priority,
    required DateTime estEndDate, // Estimated end date
    DateTime? actualEndDate,
    required double estEffortHrs,
    double? actualEffortHrs,
    required TaskStatus status,
    required String description,
    String? deliverables,
    String? taskHistory,
    String? managerComments,
    String? notes,
    required bool billable,
    @Default([]) List<AttachedFile> attachedFiles,
    // NEW: Who is assigned (for manager view)
    String? assignedToEmpId,
    String? assignedToName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  // Computed helpers
  bool get isOverdue =>
      estEndDate.isBefore(DateTime.now()) && status != TaskStatus.closed;

  String get displayStatus => status.name.toUpperCase();
  String get displayPriority => priority.name.toUpperCase();

  // Progress contribution (if completed)
  double get progressImpact =>
      status == TaskStatus.closed ? 100.0 / estEffortHrs : 0.0;

  String get assignedDisplay {
    if (assignedToName != null && assignedToName!.isNotEmpty) {
      return assignedToName!;
    }
    if (assignedToEmpId != null && assignedToEmpId!.isNotEmpty) {
      return 'Emp: $assignedToEmpId';
    }
    return 'Unassigned';
  }
}

@freezed
class AttachedFile with _$AttachedFile {
  const factory AttachedFile({
    required String fileName,
    required String filePath,
    required String fileType,
  }) = _AttachedFile;

  factory AttachedFile.fromJson(Map<String, dynamic> json) =>
      _$AttachedFileFromJson(json);
}

// DB Factory (from task_master table)
TaskModel taskFromDB(Map<String, dynamic> row) {
  return TaskModel(
    taskId: row['task_id'] as String,
    projectId: row['project_id'] as String,
    projectName: row['project_name'] as String,
    taskName: row['task_name'] as String,
    type: row['type'] as String,
    priority: _mapTaskPriority(row['priority'] as String),
    estEndDate: DateTime.parse(row['est_end_date'] as String),
    actualEndDate: _parseDate(row['actual_end_date'] as String?),
    estEffortHrs: (row['est_effort_hrs'] as num?)?.toDouble() ?? 0.0,
    actualEffortHrs: (row['actual_effort_hrs'] as num?)?.toDouble(),
    status: _mapTaskStatus(row['status'] as String),
    description: row['description'] as String,
    deliverables: row['deliverables'] as String?,
    taskHistory: row['task_history'] as String?,
    managerComments: row['manager_comments'] as String?,
    notes: row['notes'] as String?,
    billable: (row['billable'] as int? ?? 0) == 1,
    assignedToEmpId: row['assigned_to_emp_id'] as String?,
    assignedToName: row['assigned_to_name'] as String?,
    attachedFiles: [], // Handle separately
    createdAt: _parseDate(row['created_at'] as String?),
    updatedAt: _parseDate(row['updated_at'] as String?),
  );
}

TaskStatus _mapTaskStatus(String status) {
  return TaskStatus.values.firstWhere(
    (e) => e.name == status.toLowerCase(),
    orElse: () => TaskStatus.pending,
  );
}

TaskPriority _mapTaskPriority(String priority) {
  return TaskPriority.values.firstWhere(
    (e) => e.name == priority.toLowerCase(),
    orElse: () => TaskPriority.normal,
  );
}

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null) return null;
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    return null;
  }
}

// // lib/features/projects/domain/models/task_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'task_model.freezed.dart';
// part 'task_model.g.dart';

// enum TaskStatus { assigned, resolved, closed, pending, open }

// enum TaskPriority { urgent, high, medium, normal }

// @freezed
// class TaskModel with _$TaskModel {
//   const factory TaskModel({
//     required String taskId,
//     required String projectId,
//     required String projectName,
//     required String taskName,
//     required String type,
//     required TaskPriority priority,
//     required DateTime estEndDate,
//     DateTime? actualEndDate,
//     required double estEffortHrs,
//     double? actualEffortHrs,
//     required TaskStatus status,
//     required String description,
//     String? deliverables,
//     String? taskHistory,
//     String? managerComments,
//     String? notes,
//     required bool billable,
//     @Default([]) List<AttachedFile> attachedFiles,
//   }) = _TaskModel;

//   factory TaskModel.fromJson(Map<String, dynamic> json) =>
//       _$TaskModelFromJson(json);
// }

// @freezed
// class AttachedFile with _$AttachedFile {
//   const factory AttachedFile({
//     required String fileName,
//     required String filePath,
//     required String fileType,
//   }) = _AttachedFile;

//   factory AttachedFile.fromJson(Map<String, dynamic> json) =>
//       _$AttachedFileFromJson(json);
// }
