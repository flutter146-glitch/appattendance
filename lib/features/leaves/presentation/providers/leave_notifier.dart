// lib/features/leaves/presentation/providers/leave_notifier.dart
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveState {
  final List<LeaveModel> leaves;
  final bool isLoading;
  final String? error;

  LeaveState({this.leaves = const [], this.isLoading = false, this.error});

  LeaveState copyWith({
    List<LeaveModel>? leaves,
    bool? isLoading,
    String? error,
  }) {
    return LeaveState(
      leaves: leaves ?? this.leaves,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LeaveNotifier extends StateNotifier<AsyncValue<LeaveState>> {
  LeaveNotifier() : super(const AsyncLoading());

  Future<void> loadLeaves(String userId, bool isManager) async {
    state = const AsyncLoading();
    try {
      final db = await DBHelper.instance.database;
      List<Map<String, dynamic>> raw;

      if (isManager) {
        raw = await db.query('employee_leaves', orderBy: 'created_at DESC');
      } else {
        raw = await db.query(
          'employee_leaves',
          where: 'emp_id = ?',
          whereArgs: [userId],
          orderBy: 'created_at DESC',
        );
      }

      final leaves = raw.map((json) => LeaveModel.fromJson(json)).toList();
      state = AsyncData(LeaveState(leaves: leaves));
    } catch (e, s) {
      state = AsyncError('Failed to load leaves', s);
    }
  }

  Future<void> applyLeave(LeaveModel leave) async {
    try {
      final db = await DBHelper.instance.database;
      await db.insert('employee_leaves', leave.toJson());
      await loadLeaves(leave.empId, false);
    } catch (e, s) {
      state = AsyncError('Failed to apply leave', s);
    }
  }

  Future<void> updateLeaveStatus(
    String leaveId,
    LeaveStatus status,
    String? remarks,
  ) async {
    try {
      final db = await DBHelper.instance.database;
      await db.update(
        'employee_leaves',
        {
          'leave_approval_status':
              status.name[0].toUpperCase() + status.name.substring(1),
          'manager_comments': remarks,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'leave_id = ?',
        whereArgs: [leaveId],
      );
      // Reload after update
      state.whenData((s) => loadLeaves(s.leaves.first.empId, true));
    } catch (e, s) {
      state = AsyncError('Failed to update leave', s);
    }
  }
}

final leaveProvider =
    StateNotifierProvider<LeaveNotifier, AsyncValue<LeaveState>>(
      (ref) => LeaveNotifier(),
    );

// // lib/features/leaves/presentation/providers/leave_notifier.dart
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LeaveNotifier extends StateNotifier<AsyncValue<List<LeaveModel>>> {
//   LeaveNotifier() : super(const AsyncLoading()) {
//     loadLeaves();
//   }

//   Future<void> loadLeaves() async {
//     await Future.delayed(const Duration(seconds: 1));
//     state = AsyncData([
//       LeaveModel(
//         id: "1",
//         userId: "1",
//         fromDate: DateTime.now().add(const Duration(days: 5)),
//         toDate: DateTime.now().add(const Duration(days: 7)),
//         fromTime: const TimeOfDay(hour: 9, minute: 0),
//         toTime: const TimeOfDay(hour: 18, minute: 0),
//         leaveType: LeaveType.casual,
//         notes: "Family function",
//         appliedDate: DateTime.now(),
//       ),
//     ]);
//   }
// }

// final leaveProvider =
//     StateNotifierProvider<LeaveNotifier, AsyncValue<List<LeaveModel>>>((ref) {
//       return LeaveNotifier();
//     });
