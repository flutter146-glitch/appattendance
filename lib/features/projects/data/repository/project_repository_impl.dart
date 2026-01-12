import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/projects/data/repository/project_repository.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:sqflite/sqflite.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final DBHelper _dbHelper;

  ProjectRepositoryImpl(this._dbHelper);

  @override
  Future<List<MappedProject>> getMappedProjects(String empId) async {
    try {
      final db = await _dbHelper.database;

      final mappedRows = await db.query(
        'employee_mapped_projects',
        where: 'emp_id = ? AND mapping_status = ?',
        whereArgs: [empId, 'active'],
      );

      final List<MappedProject> result = [];

      for (var mapped in mappedRows) {
        final projectId = mapped['project_id'] as String?;
        if (projectId == null || projectId.isEmpty) continue;

        final project = await _getProjectById(projectId, db);
        if (project != null) {
          result.add(
            MappedProject(
              empId: empId,
              projectId: projectId,
              mappingStatus: mapped['mapping_status'] as String? ?? 'active',
              project: project,
              createdAt: _parseDate(mapped['created_at'] as String?),
              updatedAt: _parseDate(mapped['updated_at'] as String?),
            ),
          );
        }
      }

      return result;
    } catch (e) {
      // TODO: Use proper logger in production
      print('Error fetching mapped projects for empId $empId: $e');
      return [];
    }
  }

  @override
  Future<List<ProjectModel>> getTeamProjects(String mgrEmpId) async {
    try {
      final db = await _dbHelper.database;

      // Get all team members under this manager
      final teamMembers = await db.query(
        'employee_master',
        columns: ['emp_id'],
        where: 'reporting_manager_id = ?',
        whereArgs: [mgrEmpId],
      );

      if (teamMembers.isEmpty) return [];

      final empIds = teamMembers
          .map((m) => m['emp_id'] as String?)
          .whereType<String>()
          .toList();

      if (empIds.isEmpty) return [];

      final placeholders = List.filled(empIds.length, '?').join(',');

      // Get unique active projects for the team
      final mappedRows = await db.rawQuery('''
        SELECT DISTINCT project_id
        FROM employee_mapped_projects
        WHERE emp_id IN ($placeholders) AND mapping_status = 'active'
      ''', empIds);

      final projectIds = mappedRows
          .map((row) => row['project_id'] as String?)
          .whereType<String>()
          .toList();

      if (projectIds.isEmpty) return [];

      final List<ProjectModel> projects = [];
      for (final pid in projectIds) {
        final project = await _getProjectById(pid, db);
        if (project != null) {
          projects.add(project);
        }
      }

      // Sort by created_at DESC (latest first)
      projects.sort((a, b) {
        final aDate = a.createdAt ?? DateTime(2000);
        final bDate = b.createdAt ?? DateTime(2000);
        return bDate.compareTo(aDate);
      });

      return projects;
    } catch (e) {
      print('Error fetching team projects for mgr $mgrEmpId: $e');
      return [];
    }
  }

  @override
  Future<ProjectModel?> getProjectById(String projectId) async {
    try {
      final db = await _dbHelper.database;
      return await _getProjectById(projectId, db);
    } catch (e) {
      print('Error fetching project $projectId: $e');
      return null;
    }
  }

  // Centralized & Optimized: Fetch single project + team size
  Future<ProjectModel?> _getProjectById(String projectId, Database db) async {
    final projectRows = await db.query(
      'project_master',
      where: 'project_id = ?',
      whereArgs: [projectId],
      limit: 1,
    );

    if (projectRows.isEmpty) return null;

    final row = projectRows.first;

    // Count active team members (efficient COUNT query)
    final teamSizeResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM employee_mapped_projects WHERE project_id = ? AND mapping_status = ?',
      [projectId, 'active'],
    );

    final teamSize = Sqflite.firstIntValue(teamSizeResult) ?? 0;

    return ProjectModel(
      projectId: row['project_id'] as String? ?? '',
      orgShortName: row['org_short_name'] as String? ?? 'NUTANTEK',
      projectName: row['project_name'] as String? ?? 'Unnamed Project',
      projectDescription: row['project_description'] as String?,
      projectSite: row['project_site'] as String?,
      clientName: row['client_name'] as String?,
      clientLocation: row['client_location'] as String?,
      clientContact: row['client_contact'] as String?,
      mngName: row['mng_name'] as String?,
      mngEmail: row['mng_email'] as String?,
      mngContact: row['mng_contact'] as String?,
      techStack: row['project_techstack'] as String?,
      progress: (row['progress'] as num?)?.toDouble() ?? 0.0,
      totalTasks: row['total_tasks'] as int? ?? 0,
      completedTasks: row['completed_tasks'] as int? ?? 0,
      teamSize: teamSize,
      status: _mapProjectStatus(row['project_status'] as String? ?? 'active'),
      priority: _mapProjectPriority(
        row['project_priority'] as String? ?? 'medium',
      ),
      startDate: _parseDate(row['start_date'] as String?),
      endDate: _parseDate(row['end_date'] as String?),
      assignedDate: _parseDate(row['assigned_date'] as String?),
      createdAt: _parseDate(row['created_at'] as String?),
      updatedAt: _parseDate(row['updated_at'] as String?),
    );
  }

  // ── Helper Mappers ──────────────────────────────────────────────────────────
  ProjectStatus _mapProjectStatus(String? status) {
    final lower = (status ?? '').toLowerCase();
    return switch (lower) {
      'inactive' => ProjectStatus.inactive,
      'completed' => ProjectStatus.completed,
      'onhold' => ProjectStatus.onHold,
      'cancelled' => ProjectStatus.cancelled,
      _ => ProjectStatus.active,
    };
  }

  ProjectPriority _mapProjectPriority(String? priority) {
    final lower = (priority ?? '').toLowerCase();
    return switch (lower) {
      'urgent' => ProjectPriority.urgent,
      'high' => ProjectPriority.high,
      'low' => ProjectPriority.low,
      _ => ProjectPriority.medium,
    };
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return null;
    }
  }
}

// // lib/features/project/data/repositories/project_repository_impl.dart
// // FINAL UPGRADED & PRODUCTION-READY VERSION - January 07, 2026
// // Fully aligned with latest dummy data + project_master table
// // Null-safe queries, efficient DISTINCT + joins
// // Local DB only (SQLite), future API branch commented
// // Clean, no debug prints, optimized for performance

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/projects/data/repository/project_repository.dart';
// import 'package:appattendance/features/projects/domain/models/project_model.dart';

// class ProjectRepositoryImpl implements ProjectRepository {
//   @override
//   Future<List<MappedProject>> getMappedProjects(String empId) async {
//     final db = await DBHelper.instance.database;

//     // Employee ke mapped active projects
//     final mappedRows = await db.query(
//       'employee_mapped_projects',
//       where: 'emp_id = ? AND mapping_status = ?',
//       whereArgs: [empId, 'active'],
//     );

//     final List<MappedProject> result = [];

//     for (var mapped in mappedRows) {
//       final projectId = mapped['project_id'] as String? ?? '';
//       if (projectId.isEmpty) continue;

//       final projectRows = await db.query(
//         'project_master',
//         where: 'project_id = ?',
//         whereArgs: [projectId],
//       );

//       if (projectRows.isNotEmpty) {
//         final project = projectFromDB(projectRows.first);
//         result.add(
//           MappedProject(
//             empId: empId,
//             projectId: projectId,
//             mappingStatus: mapped['mapping_status'] as String? ?? 'active',
//             project: project,
//             createdAt: _parseDate(mapped['created_at'] as String?),
//             updatedAt: _parseDate(mapped['updated_at'] as String?),
//           ),
//         );
//       }
//     }

//     return result;
//   }

//   @override
//   Future<List<ProjectModel>> getTeamProjects(String mgrEmpId) async {
//     final db = await DBHelper.instance.database;

//     // Manager ke team ke employees
//     final teamMembers = await db.query(
//       'employee_master',
//       where: 'reporting_manager_id = ?',
//       whereArgs: [mgrEmpId],
//     );

//     if (teamMembers.isEmpty) return [];

//     final empIds = teamMembers
//         .map((m) => m['emp_id'] as String?)
//         .whereType<String>()
//         .toList();

//     if (empIds.isEmpty) return [];

//     final placeholders = List.filled(empIds.length, '?').join(',');

//     // Unique active project_ids from team members
//     final mappedRows = await db.rawQuery('''
//       SELECT DISTINCT project_id
//       FROM employee_mapped_projects
//       WHERE emp_id IN ($placeholders) AND mapping_status = 'active'
//       ''', empIds);

//     final projectIds = mappedRows
//         .map((row) => row['project_id'] as String?)
//         .whereType<String>()
//         .toList();

//     if (projectIds.isEmpty) return [];

//     final placeholdersProjects = List.filled(projectIds.length, '?').join(',');

//     // Fetch unique projects (latest first)
//     final projectRows = await db.rawQuery('''
//       SELECT *
//       FROM project_master
//       WHERE project_id IN ($placeholdersProjects)
//       ORDER BY created_at DESC
//       ''', projectIds);

//     return projectRows.map(projectFromDB).toList();
//   }

//   @override
//   Future<ProjectModel?> getProjectById(String projectId) async {
//     final db = await DBHelper.instance.database;
//     final rows = await db.query(
//       'project_master',
//       where: 'project_id = ?',
//       whereArgs: [projectId],
//     );
//     return rows.isNotEmpty ? projectFromDB(rows.first) : null;
//   }

//   // Null-safe DB row to ProjectModel (fully aligned with latest dummy + table)
//   ProjectModel projectFromDB(Map<String, dynamic> row) {
//     return ProjectModel(
//       projectId: row['project_id'] as String? ?? '',
//       orgShortName: row['org_short_name'] as String? ?? 'NUTANTEK',
//       projectName: row['project_name'] as String? ?? 'Unnamed Project',
//       projectSite: row['project_site'] as String?,
//       clientName: row['client_name'] as String?,
//       clientLocation: row['client_location'] as String?,
//       clientContact: row['client_contact'] as String?,
//       mngName: row['mng_name'] as String?,
//       mngEmail: row['mng_email'] as String?,
//       mngContact: row['mng_contact'] as String?,
//       projectDescription: row['project_description'] as String?,
//       projectTechstack: row['project_techstack'] as String?,
//       projectAssignedDate: row['project_assigned_date'] as String?,
//       estdStartDate: row['estd_start_date'] as String?,
//       estdEndDate: row['estd_end_date'] as String?,
//       estdEffort: row['estd_effort'] as String?,
//       estdCost: row['estd_cost'] as String?,
//       status: _mapProjectStatus(row['status'] as String? ?? 'active'),
//       priority: _mapProjectPriority(row['priority'] as String? ?? 'HIGH'),
//       progress: (row['progress'] as num?)?.toDouble() ?? 0.0,
//       teamSize: row['team_size'] as int? ?? 0,
//       totalTasks: row['total_tasks'] as int? ?? 0,
//       completedTasks: row['completed_tasks'] as int? ?? 0,
//       daysLeft: row['days_left'] as int? ?? 0,
//       teamMemberIds: [], // Populate from join query if needed
//       teamMemberNames: [], // Populate from join query if needed
//       startDate: _parseDate(row['start_date'] as String?),
//       endDate: _parseDate(row['end_date'] as String?),
//       createdAt: _parseDate(row['created_at'] as String?),
//       updatedAt: _parseDate(row['updated_at'] as String?),
//     );
//   }

//   ProjectStatus _mapProjectStatus(String? status) {
//     final lower = (status ?? '').toLowerCase();
//     return switch (lower) {
//       'inactive' => ProjectStatus.inactive,
//       'completed' => ProjectStatus.completed,
//       'onhold' => ProjectStatus.onHold,
//       'cancelled' => ProjectStatus.cancelled,
//       _ => ProjectStatus.active,
//     };
//   }

//   ProjectPriority _mapProjectPriority(String? priority) {
//     final lower = (priority ?? '').toLowerCase();
//     return switch (lower) {
//       'urgent' => ProjectPriority.urgent,
//       'medium' => ProjectPriority.medium,
//       'low' => ProjectPriority.low,
//       _ => ProjectPriority.high,
//     };
//   }

//   DateTime? _parseDate(String? dateStr) {
//     if (dateStr == null) return null;
//     try {
//       return DateTime.parse(dateStr);
//     } catch (_) {
//       return null;
//     }
//   }

//   // Future: API mode (uncomment when backend ready)
//   /*
//   Future<List<ProjectModel>> getTeamProjectsApi(String mgrEmpId) async {
//     if (dio == null) throw Exception('Dio not initialized');
//     final response = await dio!.get('/projects/team', queryParameters: {'mgrId': mgrEmpId});
//     return (response.data as List).map((json) => ProjectModel.fromJson(json)).toList();
//   }
//   */
// }
// // lib/features/project/data/repositories/project_repository_impl.dart
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/projects/data/repository/project_repository.dart';
// import 'package:appattendance/features/projects/domain/models/project_model.dart';

// class ProjectRepositoryImpl implements ProjectRepository {
//   @override
//   Future<List<MappedProject>> getMappedProjects(String empId) async {
//     final db = await DBHelper.instance.database;

//     final mappedRows = await db.query(
//       'employee_mapped_projects',
//       where: 'emp_id = ? AND mapping_status = ?',
//       whereArgs: [empId, 'active'],
//     );

//     final List<MappedProject> result = [];

//     for (var mapped in mappedRows) {
//       final projectId = mapped['project_id'] as String;
//       final projectRows = await db.query(
//         'project_master',
//         where: 'project_id = ?',
//         whereArgs: [projectId],
//       );

//       if (projectRows.isNotEmpty) {
//         final project = ProjectModel.fromJson(projectRows.first);
//         result.add(
//           MappedProject(
//             empId: empId,
//             projectId: projectId,
//             mappingStatus: mapped['mapping_status'] as String,
//             project: project,
//             createdAt: DateTime.parse(mapped['created_at'] as String),
//             updatedAt: DateTime.parse(mapped['updated_at'] as String),
//           ),
//         );
//       }
//     }

//     return result;
//   }

//   @override
//   Future<List<ProjectModel>> getTeamProjects(String mgrEmpId) async {
//     final db = await DBHelper.instance.database;

//     // Team members
//     final teamMembers = await db.query(
//       'employee_master',
//       where: 'reportingManagerId = ?',
//       whereArgs: [mgrEmpId],
//     );

//     if (teamMembers.isEmpty) return [];

//     final empIds = teamMembers.map((m) => m['emp_id'] as String).toList();

//     // Unique project_ids from mapped
//     final mappedRows = await db.query(
//       'employee_mapped_projects',
//       where:
//           'emp_id IN (${List.filled(empIds.length, '?').join(',')}) AND mapping_status = ?',
//       whereArgs: [...empIds, 'active'],
//     );

//     final projectIds = mappedRows
//         .map((m) => m['project_id'] as String)
//         .toSet()
//         .toList();

//     if (projectIds.isEmpty) return [];

//     final projects = await db.query(
//       'project_master',
//       where: 'project_id IN (${List.filled(projectIds.length, '?').join(',')})',
//       whereArgs: projectIds,
//     );

//     return projects.map(ProjectModel.fromJson).toList();
//   }

//   @override
//   Future<ProjectModel?> getProjectById(String projectId) async {
//     final db = await DBHelper.instance.database;
//     final rows = await db.query(
//       'project_master',
//       where: 'project_id = ?',
//       whereArgs: [projectId],
//     );
//     return rows.isNotEmpty ? ProjectModel.fromJson(rows.first) : null;
//   }
// }
