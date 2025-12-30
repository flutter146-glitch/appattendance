// lib/features/project/data/repositories/project_repository_impl.dart
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/projects/data/services/repository/project_repository.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  @override
  Future<List<MappedProject>> getMappedProjects(String empId) async {
    final db = await DBHelper.instance.database;

    final mappedRows = await db.query(
      'employee_mapped_projects',
      where: 'emp_id = ? AND mapping_status = ?',
      whereArgs: [empId, 'active'],
    );

    final List<MappedProject> result = [];

    for (var mapped in mappedRows) {
      final projectId = mapped['project_id'] as String;
      final projectRows = await db.query(
        'project_master',
        where: 'project_id = ?',
        whereArgs: [projectId],
      );

      if (projectRows.isNotEmpty) {
        final project = ProjectModel.fromJson(projectRows.first);
        result.add(
          MappedProject(
            empId: empId,
            projectId: projectId,
            mappingStatus: mapped['mapping_status'] as String,
            project: project,
            createdAt: DateTime.parse(mapped['created_at'] as String),
            updatedAt: DateTime.parse(mapped['updated_at'] as String),
          ),
        );
      }
    }

    return result;
  }

  @override
  Future<List<ProjectModel>> getTeamProjects(String mgrEmpId) async {
    final db = await DBHelper.instance.database;

    // Team members
    final teamMembers = await db.query(
      'employee_master',
      where: 'reportingManagerId = ?',
      whereArgs: [mgrEmpId],
    );

    if (teamMembers.isEmpty) return [];

    final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();

    // Unique project_ids from mapped
    final mappedRows = await db.query(
      'employee_mapped_projects',
      where:
          'emp_id IN (${List.filled(empIds.length, '?').join(',')}) AND mapping_status = ?',
      whereArgs: [...empIds, 'active'],
    );

    final projectIds = mappedRows
        .map((m) => m['project_id'] as String)
        .toSet()
        .toList();

    if (projectIds.isEmpty) return [];

    final projects = await db.query(
      'project_master',
      where: 'project_id IN (${List.filled(projectIds.length, '?').join(',')})',
      whereArgs: projectIds,
    );

    return projects.map(ProjectModel.fromJson).toList();
  }

  @override
  Future<ProjectModel?> getProjectById(String projectId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(
      'project_master',
      where: 'project_id = ?',
      whereArgs: [projectId],
    );
    return rows.isNotEmpty ? ProjectModel.fromJson(rows.first) : null;
  }
}
