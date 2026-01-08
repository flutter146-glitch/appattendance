// lib/features/leaves/data/repositories/leave_repository_impl.dart
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/leaves/data/repositories/leave_repository.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:sqflite/sqflite.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  @override
  Future<List<LeaveModel>> getLeavesByEmployee(String empId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(
      'employee_leaves',
      where: 'emp_id = ?',
      whereArgs: [empId],
      orderBy: 'created_at DESC',
    );

    return rows.map((row) => LeaveModel.fromJson(row)).toList();
  }

  @override
  Future<List<LeaveModel>> getPendingLeavesForManager(String mgrEmpId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(
      'employee_leaves',
      where: 'mgr_emp_id = ? AND leave_approval_status = ?',
      whereArgs: [mgrEmpId, LeaveStatus.pending.name],
      orderBy: 'created_at DESC',
    );
    return rows.map(LeaveModel.fromJson).toList();
  }

  @override
  Future<List<LeaveModel>> getAllLeavesForManager(String mgrEmpId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query(
      'employee_leaves',
      where: 'mgr_emp_id = ?',
      whereArgs: [mgrEmpId],
      orderBy: 'created_at DESC',
    );
    return rows.map((row) => LeaveModel.fromJson(row)).toList();
  }

  @override
  Future<void> applyLeave(LeaveModel leave) async {
    final db = await DBHelper.instance.database;
    await db.insert('employee_leaves', {
      'leave_id': leave.leaveId,
      'emp_id': leave.empId,
      'mgr_emp_id': leave.mgrEmpId,
      'leave_from_date': leave.leaveFromDate.toIso8601String(),
      'leave_to_date': leave.leaveToDate.toIso8601String(),
      'leave_type': leave.leaveType.name,
      'leave_justification': leave.leaveJustification,
      'leave_approval_status': leave.leaveApprovalStatus.name,
      'manager_comments': leave.managerComments,
      'from_time': leave.fromTime,
      'to_time': leave.toTime,
      'created_at':
          leave.createdAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'updated_at':
          leave.updatedAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateLeaveStatus({
    required String leaveId,
    required LeaveStatus newStatus,
    String? managerComments,
  }) async {
    final db = await DBHelper.instance.database;
    await db.update(
      'employee_leaves',
      {
        'leave_approval_status': newStatus.name,
        'manager_comments': managerComments,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'leave_id = ?',
      whereArgs: [leaveId],
    );
  }

  @override
  Future<int> getPendingLeavesCount(String mgrEmpId) async {
    final db = await DBHelper.instance.database;
    final count =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM employee_leaves WHERE mgr_emp_id = ? AND leave_approval_status = ?',
            [mgrEmpId, LeaveStatus.pending.name],
          ),
        ) ??
        0;
    return count;
  }
}

// // lib/features/leave/data/repositories/leave_repository_impl.dart
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/leaves/data/repository/leave_repository.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:sqflite/sqflite.dart';

// class LeaveRepositoryImpl implements LeaveRepository {
//   @override
//   Future<List<LeaveModel>> getLeavesByEmployee(String empId) async {
//     final db = await DBHelper.instance.database;
//     final rows = await db.query(
//       'employee_leaves',
//       where: 'emp_id = ?',
//       whereArgs: [empId],
//       orderBy: 'created_at DESC',
//     );

//     return rows
//         .map(
//           (row) => LeaveModel(
//             leaveId: row['leave_id'] as String,
//             empId: row['emp_id'] as String,
//             mgrEmpId: row['mgr_emp_id'] as String,
//             leaveFromDate: DateTime.parse(row['leave_from_date'] as String),
//             leaveToDate: DateTime.parse(row['leave_to_date'] as String),
//             leaveType: LeaveType.values.byName(row['leave_type'] as String),
//             leaveJustification: row['leave_justification'] as String?,
//             leaveApprovalStatus: LeaveStatus.values.byName(
//               row['leave_approval_status'] as String,
//             ),
//             managerComments: row['manager_comments'] as String?,
//             createdAt: DateTime.parse(row['created_at'] as String),
//             updatedAt: DateTime.parse(row['updated_at'] as String),
//           ),
//         )
//         .toList();
//   }

//   @override
//   Future<List<LeaveModel>> getPendingLeavesForManager(String mgrEmpId) async {
//     final db = await DBHelper.instance.database;
//     final rows = await db.query(
//       'employee_leaves',
//       where: 'mgr_emp_id = ? AND leave_approval_status = ?',
//       whereArgs: [mgrEmpId, LeaveStatus.pending.name],
//       orderBy: 'created_at DESC',
//     );
//     return rows.map(LeaveModel.fromJson).toList();
//   }

//   @override
//   Future<void> applyLeave(LeaveModel leave) async {
//     final db = await DBHelper.instance.database;
//     await db.insert('employee_leaves', {
//       'leave_id': leave.leaveId,
//       'emp_id': leave.empId,
//       'mgr_emp_id': leave.mgrEmpId,
//       'leave_from_date': leave.leaveFromDate.toIso8601String(),
//       'leave_to_date': leave.leaveToDate.toIso8601String(),
//       'leave_type': leave.leaveType.name,
//       'leave_justification': leave.leaveJustification,
//       'leave_approval_status': leave.leaveApprovalStatus.name,
//       'manager_comments': leave.managerComments,
//       'from_time': leave.fromTime,
//       'to_time': leave.toTime,
//       'created_at':
//           leave.createdAt?.toIso8601String() ??
//           DateTime.now().toIso8601String(),
//       'updated_at':
//           leave.updatedAt?.toIso8601String() ??
//           DateTime.now().toIso8601String(),
//     });
//   }

//   @override
//   Future<void> updateLeaveStatus({
//     required String leaveId,
//     required LeaveStatus newStatus,
//     String? managerComments,
//   }) async {
//     final db = await DBHelper.instance.database;
//     await db.update(
//       'employee_leaves',
//       {
//         'leave_approval_status': newStatus.name,
//         'manager_comments': managerComments,
//         'updated_at': DateTime.now().toIso8601String(),
//       },
//       where: 'leave_id = ?',
//       whereArgs: [leaveId],
//     );
//   }

//   @override
//   Future<int> getPendingLeavesCount(String mgrEmpId) async {
//     final db = await DBHelper.instance.database;
//     final count =
//         Sqflite.firstIntValue(
//           await db.rawQuery(
//             'SELECT COUNT(*) FROM employee_leaves WHERE mgr_emp_id = ? AND leave_approval_status = ?',
//             [mgrEmpId, LeaveStatus.pending.name],
//           ),
//         ) ??
//         0;
//     return count;
//   }
// }
