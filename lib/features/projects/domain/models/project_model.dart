// // lib/features/projects/domain/models/project_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'project_model.freezed.dart';
// part 'project_model.g.dart';

// @freezed
// class ProjectModel with _$ProjectModel {
//   const ProjectModel._();

//   const factory ProjectModel({
//     required String id,
//     required String name,
//     String? status,
//     String? site,
//     String? shift,
//     String? clientName,
//     String? clientContact,
//     String? managerName,
//     String? managerEmail,
//     String? managerContact,
//     String? description,
//     String? techStack,
//     DateTime? assignedDate,
//   }) = _ProjectModel;

//   factory ProjectModel.fromJson(Map<String, dynamic> json) =>
//       _$ProjectModelFromJson(json);
// }

// @freezed
// class ProjectAnalytics with _$ProjectAnalytics {
//   const factory ProjectAnalytics({
//     required Map<String, List<double>> graphData,
//     required List<String> labels,
//     required int totalProjects,
//     required int totalEmployees,
//     required Map<String, double> statusDistribution,
//     @Default({}) Map<String, dynamic> additionalStats,
//   }) = _ProjectAnalytics;

//   factory ProjectAnalytics.fromJson(Map<String, dynamic> json) =>
//       _$ProjectAnalyticsFromJson(json);
// }
// lib/features/project/domain/models/project_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();

  const factory ProjectModel({
    required String projectId, // PK
    required String orgShortName,
    required String projectName,
    String? projectSite,
    String? clientName,
    String? clientLocation,
    String? clientContact,
    String? mngName,
    String? mngEmail,
    String? mngContact,
    String? projectDescription,
    String? projectTechstack,
    String? projectAssignedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}

// Mapped Project (employee_mapped_projects join)
@freezed
class MappedProject with _$MappedProject {
  const MappedProject._();

  const factory MappedProject({
    required String empId,
    required String projectId,
    required String mappingStatus, // 'active' / 'deactive'
    required ProjectModel project,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MappedProject;

  factory MappedProject.fromJson(Map<String, dynamic> json) =>
      _$MappedProjectFromJson(json);
}
