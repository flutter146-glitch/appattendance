// lib/features/projects/domain/models/project_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();

  const factory ProjectModel({
    required String id,
    required String name,
    String? status,
    String? site,
    String? shift,
    String? clientName,
    String? clientContact,
    String? managerName,
    String? managerEmail,
    String? managerContact,
    String? description,
    String? techStack,
    DateTime? assignedDate,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);
}

@freezed
class ProjectAnalytics with _$ProjectAnalytics {
  const factory ProjectAnalytics({
    required Map<String, List<double>> graphData,
    required List<String> labels,
    required int totalProjects,
    required int totalEmployees,
    required Map<String, double> statusDistribution,
    @Default({}) Map<String, dynamic> additionalStats,
  }) = _ProjectAnalytics;

  factory ProjectAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ProjectAnalyticsFromJson(json);
}
