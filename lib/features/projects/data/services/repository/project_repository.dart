// lib/features/project/domain/repositories/project_repository.dart
import 'package:appattendance/features/project/domain/models/project_model.dart';

abstract class ProjectRepository {
  /// Employee ke mapped projects
  Future<List<MappedProject>> getMappedProjects(String empId);

  /// Manager ke team ke saare mapped projects (unique)
  Future<List<ProjectModel>> getTeamProjects(String mgrEmpId);

  /// Single project details
  Future<ProjectModel?> getProjectById(String projectId);
}
