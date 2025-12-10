// lib/features/projects/domain/models/task_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskStatus { assigned, resolved, closed, pending, open }

enum TaskPriority { urgent, high, medium, normal }

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String taskId,
    required String projectId,
    required String projectName,
    required String taskName,
    required String type,
    required TaskPriority priority,
    required DateTime estEndDate,
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
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
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
