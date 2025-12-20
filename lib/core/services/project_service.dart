// // lib/core/services/project_service.dart

// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:sqflite/sqflite.dart';

// class ProjectService {
//   static Future<List<Map<String, dynamic>>> getMappedProjects({
//     required String currentEmpId,
//     required bool isManager,
//   }) async {
//     final db = await DBHelper.instance.database;
//     List<Map<String, dynamic>> projects = [];

//     if (isManager) {
//       // MANAGER: Team ke saare projects load karo
//       // Assume employee_master mein 'reporting_manager_id' field hai jo manager ka emp_id store karta hai
//       final teamMembers = await db.query(
//         'employee_master',
//         where: 'reporting_manager_id = ?',
//         whereArgs: [currentEmpId],
//       );

//       Set<String> teamProjectIds = {};

//       for (var member in teamMembers) {
//         final memberMapped = await db.query(
//           'employee_mapped_projects',
//           where: 'emp_id = ? AND mapping_status = ?',
//           whereArgs: [member['emp_id'], 'active'],
//         );

//         for (var mapping in memberMapped) {
//           teamProjectIds.add(mapping['project_id'] as String);
//         }
//       }

//       if (teamProjectIds.isNotEmpty) {
//         projects = await db.query(
//           'project_master',
//           where:
//               'project_id IN (${List.filled(teamProjectIds.length, '?').join(',')})',
//           whereArgs: teamProjectIds.toList(),
//         );

//         // Har project mein assigned employee ka name add karo
//         for (var project in projects) {
//           final mapping = await db.query(
//             'employee_mapped_projects',
//             where: 'project_id = ? AND mapping_status = ?',
//             whereArgs: [project['project_id'], 'active'],
//             limit: 1,
//           );

//           if (mapping.isNotEmpty) {
//             final empId = mapping.first['emp_id'] as String;
//             final employee = await db.query(
//               'employee_master',
//               where: 'emp_id = ?',
//               whereArgs: [empId],
//             );

//             if (employee.isNotEmpty) {
//               project['assigned_emp_name'] = employee.first['emp_name'];
//               project['assigned_emp_id'] = employee.first['emp_id'];
//             }
//           }
//         }
//       }
//     } else {
//       // EMPLOYEE: Sirf apne projects
//       final mapped = await db.query(
//         'employee_mapped_projects',
//         where: 'emp_id = ? AND mapping_status = ?',
//         whereArgs: [currentEmpId, 'active'],
//       );

//       if (mapped.isNotEmpty) {
//         final projectIds = mapped
//             .map((m) => m['project_id'] as String)
//             .toList();
//         projects = await db.query(
//           'project_master',
//           where:
//               'project_id IN (${List.filled(projectIds.length, '?').join(',')})',
//           whereArgs: projectIds,
//         );
//       }
//     }

//     return projects;
//   }
// }
