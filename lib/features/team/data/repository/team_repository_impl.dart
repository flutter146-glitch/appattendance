// lib/features/team/data/repositories/team_repository_impl.dart
// FIXED & UPGRADED - January 12, 2026
// Fixes: Queries match dummy_data (reporting_manager_id)
// Added logging for debug (what's fetched)
// Safe null handling
// Team members with attendance & projects joined

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/domain/models/user_role.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/data/repository/team_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class TeamRepositoryImpl implements TeamRepository {
  final DBHelper dbHelper;

  TeamRepositoryImpl(this.dbHelper);

  @override
  Future<List<TeamMember>> getTeamMembers(String managerEmpId) async {
    final db = await dbHelper.database;

    // Fetch team members with join for projects & recent attendance
    final rows = await db.rawQuery(
      '''
      SELECT 
        e.emp_id,
        e.emp_name AS name,
        e.designation,
        e.emp_email AS email,
        e.emp_phone AS phone,
        e.emp_status AS status,
        e.emp_joining_date AS dateOfJoining,
        GROUP_CONCAT(p.project_id) AS projectIds,
        GROUP_CONCAT(p.project_name) AS projectNames
      FROM employee_master e
      LEFT JOIN employee_mapped_projects emp ON e.emp_id = emp.emp_id
      LEFT JOIN project_master p ON emp.project_id = p.project_id
      WHERE e.reporting_manager_id = ? AND e.emp_status = 'active'
      GROUP BY e.emp_id
    ''',
      [managerEmpId],
    );

    if (kDebugMode) {
      print('Fetched ${rows.length} team members for manager $managerEmpId');
    }

    final List<TeamMember> members = [];
    for (var row in rows) {
      final empId = row['emp_id'] as String;

      // Fetch recent attendance for this member (last 7 days)
      final recentAttendance = await _getRecentAttendance(db, empId, days: 7);

      members.add(
        TeamMember(
          empId: empId,
          name: row['name'] as String? ?? 'Unknown',
          designation: row['designation'] as String?,
          email: row['email'] as String?,
          phone: row['phone'] as String?,
          status: mapStatus(row['status'] as String?),
          dateOfJoining: DateTime.tryParse(
            row['dateOfJoining'] as String? ?? '',
          ),
          projectIds: (row['projectIds'] as String?)?.split(',') ?? [],
          projectNames: (row['projectNames'] as String?)?.split(',') ?? [],
          recentAttendanceHistory: recentAttendance,
          attendanceRatePercentage: _calculateAttendanceRate(recentAttendance),
        ),
      );
    }

    return members;
  }

  @override
  Future<TeamMember?> getTeamMemberDetails(
    String empId, {
    int recentDays = 30,
  }) async {
    final db = await dbHelper.database;

    // Fetch member details with joins
    final rows = await db.rawQuery(
      '''
      SELECT 
        e.*,
        GROUP_CONCAT(p.project_id) AS projectIds,
        GROUP_CONCAT(p.project_name) AS projectNames
      FROM employee_master e
      LEFT JOIN employee_mapped_projects emp ON e.emp_id = emp.emp_id
      LEFT JOIN project_master p ON emp.project_id = p.project_id
      WHERE e.emp_id = ?
      GROUP BY e.emp_id
    ''',
      [empId],
    );

    if (rows.isEmpty) {
      if (kDebugMode) print('No member found for empId $empId');
      return null;
    }

    final row = rows.first;

    // Fetch recent attendance
    final recentAttendance = await _getRecentAttendance(
      db,
      empId,
      days: recentDays,
    );

    return TeamMember(
      empId: empId,
      name: row['emp_name'] as String? ?? 'Unknown',
      designation: row['designation'] as String?,
      email: row['emp_email'] as String?,
      phone: row['emp_phone'] as String?,
      department: row['emp_department'] as String?,
      status: mapStatus(row['emp_status'] as String?),
      dateOfJoining: DateTime.tryParse(
        row['emp_joining_date'] as String? ?? '',
      ),
      projectIds: (row['projectIds'] as String?)?.split(',') ?? [],
      projectNames: (row['projectNames'] as String?)?.split(',') ?? [],
      recentAttendanceHistory: recentAttendance,
      attendanceRatePercentage: _calculateAttendanceRate(recentAttendance),
    );
  }

  @override
  Future<List<TeamMember>> searchTeamMembers(
    String managerEmpId,
    String query,
  ) async {
    final db = await dbHelper.database;

    final rows = await db.rawQuery(
      '''
      SELECT 
        e.emp_id,
        e.emp_name AS name,
        e.designation,
        e.emp_email AS email,
        e.emp_phone AS phone,
        e.emp_status AS status,
        e.emp_joining_date AS dateOfJoining,
        GROUP_CONCAT(p.project_id) AS projectIds,
        GROUP_CONCAT(p.project_name) AS projectNames
      FROM employee_master e
      LEFT JOIN employee_mapped_projects emp ON e.emp_id = emp.emp_id
      LEFT JOIN project_master p ON emp.project_id = p.project_id
      WHERE e.reporting_manager_id = ?
        AND (e.emp_name LIKE ? OR e.emp_email LIKE ? OR e.designation LIKE ? OR e.emp_phone LIKE ?)
        AND e.emp_status = 'active'
      GROUP BY e.emp_id
    ''',
      [managerEmpId, '%$query%', '%$query%', '%$query%', '%$query%'],
    );

    if (kDebugMode) {
      print('Search returned ${rows.length} members for query "$query"');
    }

    final List<TeamMember> members = [];
    for (var row in rows) {
      final empId = row['emp_id'] as String;

      // Fetch recent attendance
      final recentAttendance = await _getRecentAttendance(db, empId, days: 7);

      members.add(
        TeamMember(
          empId: empId,
          name: row['name'] as String? ?? 'Unknown',
          designation: row['designation'] as String?,
          email: row['email'] as String?,
          phone: row['phone'] as String?,
          status: mapStatus(row['status'] as String?),
          dateOfJoining: DateTime.tryParse(
            row['dateOfJoining'] as String? ?? '',
          ),
          projectIds: (row['projectIds'] as String?)?.split(',') ?? [],
          projectNames: (row['projectNames'] as String?)?.split(',') ?? [],
          recentAttendanceHistory: recentAttendance,
          attendanceRatePercentage: _calculateAttendanceRate(recentAttendance),
        ),
      );
    }

    return members;
  }

  // Helper: Fetch recent attendance for a member
  Future<List<AttendanceModel>> _getRecentAttendance(
    Database db,
    String empId, {
    int days = 7,
  }) async {
    final startDate = DateTime.now().subtract(Duration(days: days));
    final rows = await db.query(
      'employee_attendance',
      where: 'emp_id = ? AND att_date >= ?',
      whereArgs: [empId, startDate.toIso8601String().split('T')[0]],
      orderBy: 'att_date DESC',
    );

    return rows.map((row) => attendanceFromDB(row)).toList();
  }

  // Helper: Calculate attendance rate
  double _calculateAttendanceRate(List<AttendanceModel> history) {
    if (history.isEmpty) return 0.0;
    final presentCount = history.where((a) => a.isPresent).length;
    return (presentCount / history.length) * 100;
  }
}


// // lib/features/team/data/repositories/team_repository_impl.dart
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
// import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
// import 'package:appattendance/features/team/data/repository/team_repository.dart';
// import 'package:appattendance/features/team/domain/models/team_member.dart';
// import 'package:sqflite/sqflite.dart';

// class TeamRepositoryImpl implements TeamRepository {
//   final DBHelper _dbHelper;

//   TeamRepositoryImpl(this._dbHelper);

//   @override
//   Future<List<TeamMember>> getTeamMembers(String managerEmpId) async {
//     final db = await _dbHelper.database;

//     final teamMembers = await db.query(
//       'employee_master',
//       where: 'reporting_manager_id = ?',
//       whereArgs: [managerEmpId],
//     );

//     final rows = await db.rawQuery(
//       '''
//       SELECT 
//         e.emp_id,
//         e.emp_name AS fullName,
//         e.emp_email AS email,
//         e.emp_phone AS phone,
//         e.designation,
//         e.department,
//         e.emp_status AS status,
//         e.profile_photo AS profilePhotoUrl,
//         e.join_date AS dateOfJoining,
//         GROUP_CONCAT(DISTINCT p.project_name) AS projectNames,
//         GROUP_CONCAT(DISTINCT p.project_id) AS projectIds
//       FROM employee_master e
//       LEFT JOIN employee_mapped_projects emp ON e.emp_id = emp.emp_id
//       LEFT JOIN project_master p ON emp.project_id = p.project_id
//       WHERE e.reporting_to = ? 
//         AND e.emp_status = 'active'
//       GROUP BY e.emp_id
//       ORDER BY e.emp_name ASC
//     ''',
//       [managerEmpId],
//     );

//     return rows.map((row) {
//       final statusStr = row['status'] as String? ?? 'active';
//       final status = UserStatus.values.firstWhere(
//         (s) => s.name == statusStr,
//         orElse: () => UserStatus.active,
//       );

//       return TeamMember(
//         empId: row['emp_id'] as String,
//         name: row['emp_name'] as String? ?? 'Unknown',
//         email: row['emp_email'] as String?,
//         phone: row['emp_phone'] as String?,
//         profilePhotoUrl: row['profilePhotoUrl'] as String?,
//         designation: row['designation'] as String?,
//         department: row['department'] as String?,
//         status: UserStatus.values.firstWhere(
//           (s) => s.name == (row['emp_status'] as String? ?? 'active'),
//           orElse: () => UserStatus.active,
//         ),
//         dateOfJoining: DateTime.tryParse(
//           row['emp_joining_date'] as String? ?? '',
//         ),
//         projectIds: (row['project_id'] as String?)?.split(',') ?? [],
//         projectNames: (row['project_name'] as String?)?.split(',') ?? [],
//       );
//     }).toList();
//   }

//   @override
//   Future<TeamMember?> getTeamMemberDetails(
//     String empId, {
//     int recentDays = 30,
//   }) async {
//     final db = await _dbHelper.database;

//     // Member base info
//     final memberRows = await db.query(
//       'employee_master',
//       where: 'emp_id = ?',
//       whereArgs: [empId],
//       limit: 1,
//     );

//     if (memberRows.isEmpty) return null;
//     final member = memberRows.first;

//     // Recent attendance
//     final startDate = DateTime.now().subtract(Duration(days: recentDays));
//     final startDateStr = startDate.toIso8601String().split('T')[0];

//     final attendanceRows = await db.query(
//       'employee_attendance',
//       where: 'emp_id = ? AND att_date >= ?',
//       whereArgs: [empId, startDateStr],
//       orderBy: 'att_date DESC',
//     );

//     final recentAttendance = attendanceRows
//         .map((row) => AttendanceModel.fromJson(row))
//         .toList();

//     // Projects
//     final projectRows = await db.rawQuery(
//       '''
//       SELECT 
//         GROUP_CONCAT(DISTINCT p.project_name) AS projectNames,
//         GROUP_CONCAT(DISTINCT p.project_id) AS projectIds
//       FROM employee_mapped_projects emp
//       JOIN project_master p ON emp.project_id = p.project_id
//       WHERE emp.emp_id = ?
//     ''',
//       [empId],
//     );

//     final projectData = projectRows.isNotEmpty ? projectRows.first : {};

//     return TeamMember(
//       empId: member['emp_id'] as String,
//       name: member['emp_name'] as String? ?? 'Unknown',
//       email: member['emp_email'] as String?,
//       phone: member['emp_phone'] as String?,
//       profilePhotoUrl: member['profile_photo'] as String?,
//       designation: member['designation'] as String?,
//       department: member['department'] as String?,
//       status: UserStatus.values.firstWhere(
//         (s) => s.name == (member['emp_status'] as String? ?? 'active'),
//         orElse: () => UserStatus.active,
//       ),
//       dateOfJoining: member['join_date'] != null
//           ? DateTime.tryParse(member['join_date'] as String)
//           : null,
//       projectIds: (projectData['projectIds'] as String?)?.split(',') ?? [],
//       projectNames: (projectData['projectNames'] as String?)?.split(',') ?? [],
//       recentAttendanceHistory: recentAttendance,
//     );
//   }

//   @override
//   Future<List<TeamMember>> searchTeamMembers(
//     String managerEmpId,
//     String query,
//   ) async {
//     if (query.trim().isEmpty) {
//       return getTeamMembers(managerEmpId);
//     }

//     final db = await _dbHelper.database;
//     final searchPattern = '%${query.trim().toLowerCase()}%';

//     final rows = await db.rawQuery(
//       '''
//       SELECT 
//         e.emp_id,
//         e.emp_name AS fullName,
//         e.emp_email AS email,
//         e.emp_phone AS phone,
//         e.designation,
//         e.department,
//         e.emp_status AS status,
//         e.profile_photo AS profilePhotoUrl,
//         e.join_date AS dateOfJoining,
//         GROUP_CONCAT(DISTINCT p.project_name) AS projectNames,
//         GROUP_CONCAT(DISTINCT p.project_id) AS projectIds
//       FROM employee_master e
//       LEFT JOIN employee_mapped_projects emp ON e.emp_id = emp.emp_id
//       LEFT JOIN project_master p ON emp.project_id = p.project_id
//       WHERE e.reporting_to = ? 
//         AND e.emp_status = 'active'
//         AND (
//           LOWER(e.emp_name) LIKE ? 
//           OR LOWER(e.emp_email) LIKE ? 
//           OR LOWER(e.designation) LIKE ?
//         )
//       GROUP BY e.emp_id
//       ORDER BY e.emp_name ASC
//     ''',
//       [managerEmpId, searchPattern, searchPattern, searchPattern],
//     );

//     // Same mapping as getTeamMembers
//     return rows.map((row) {
//       final statusStr = row['status'] as String? ?? 'active';
//       final status = UserStatus.values.firstWhere(
//         (s) => s.name == statusStr,
//         orElse: () => UserStatus.active,
//       );

//       return TeamMember(
//         empId: row['emp_id'] as String,
//         name: row['fullName'] as String? ?? 'Unknown',
//         email: row['email'] as String?,
//         phone: row['phone'] as String?,
//         profilePhotoUrl: row['profilePhotoUrl'] as String?,
//         designation: row['designation'] as String?,
//         department: row['department'] as String?,
//         status: status,
//         dateOfJoining: row['dateOfJoining'] != null
//             ? DateTime.tryParse(row['dateOfJoining'] as String)
//             : null,
//         projectIds: (row['projectIds'] as String?)?.split(',') ?? [],
//         projectNames: (row['projectNames'] as String?)?.split(',') ?? [],
//       );
//     }).toList();
//   }
// }
