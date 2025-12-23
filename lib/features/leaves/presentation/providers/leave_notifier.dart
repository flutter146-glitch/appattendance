// lib/features/leaves/presentation/providers/leave_notifier.dart

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LeaveState {
  final List<LeaveModel> leaves;
  final bool isLoading;
  final String? error;
  final LeaveBalance? balance;

  LeaveState({
    this.leaves = const [],
    this.isLoading = false,
    this.error,
    this.balance,
  });

  LeaveState copyWith({
    List<LeaveModel>? leaves,
    bool? isLoading,
    String? error,
    LeaveBalance? balance,
  }) {
    return LeaveState(
      leaves: leaves ?? this.leaves,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      balance: balance ?? this.balance,
    );
  }
}

class LeaveNotifier extends StateNotifier<AsyncValue<LeaveState>> {
  LeaveNotifier() : super(const AsyncLoading());

  // Load leaves based on role (own or team)
  Future<void> loadLeaves(String userId, bool isManager) async {
    state = const AsyncLoading();

    try {
      final db = await DBHelper.instance.database;

      List<Map<String, dynamic>> rawLeaves;

      if (isManager) {
        // Manager: Load all pending team leaves
        rawLeaves = await db.query(
          'employee_leaves',
          where: 'leave_approval_status = ?',
          whereArgs: ['Pending'],
          orderBy: 'created_at DESC',
        );
      } else {
        // Employee: Load own leaves
        rawLeaves = await db.query(
          'employee_leaves',
          where: 'emp_id = ?',
          whereArgs: [userId],
          orderBy: 'created_at DESC',
        );
      }

      final leaves = rawLeaves.map((json) {
        // Map DB column names to model fields
        return LeaveModel(
          leaveId: json['leave_id'] as String,
          empId: json['emp_id'] as String,
          mgrEmpId: json['mgr_emp_id'] as String?,
          leaveFromDate: DateTime.parse(json['leave_from_date'] as String),
          leaveToDate: DateTime.parse(json['leave_to_date'] as String),
          fromTime: _timeOfDayFromString(json['from_time'] as String),
          toTime: _timeOfDayToString(json['to_time'] as String),
          leaveType: LeaveType.values.firstWhere(
            (e) => e.name == json['leave_type'],
            orElse: () => LeaveType.casual,
          ),
          justification: json['leave_justification'] as String? ?? '',
          approvalStatus: json['leave_approval_status'] as String? ?? 'Pending',
          appliedDate: DateTime.parse(json['created_at'] as String),
          managerComments: json['manager_comments'] as String?,
          updatedAt: json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
          totalDays: json['total_days'] as int?,
        );
      }).toList();

      // Fetch balance (dummy for now)
      final balance = await _getLeaveBalance(userId);

      state = AsyncData(LeaveState(leaves: leaves, balance: balance));
    } catch (e, stack) {
      state = AsyncError('Failed to load leaves: $e', stack);
    }
  }

  // Dummy balance (replace with real DB query later)
  Future<LeaveBalance> _getLeaveBalance(String userId) async {
    return LeaveBalance(
      employeeId: userId,
      leaveType: LeaveType.casual,
      totalDays: 20,
      usedDays: 5,
      year: DateTime.now().year,
    );
  }

  // Apply new leave request
  Future<void> applyLeave(LeaveModel newLeave) async {
    state = state.whenData((s) => s.copyWith(isLoading: true));

    try {
      final db = await DBHelper.instance.database;

      await db.insert('employee_leaves', {
        'leave_id': newLeave.leaveId,
        'emp_id': newLeave.empId,
        'mgr_emp_id': newLeave.mgrEmpId,
        'leave_from_date': DateFormat(
          'yyyy-MM-dd',
        ).format(newLeave.leaveFromDate),
        'leave_to_date': DateFormat('yyyy-MM-dd').format(newLeave.leaveToDate),
        'from_time': '${newLeave.fromTime.hour}:${newLeave.fromTime.minute}',
        'to_time': '${newLeave.toTime.hour}:${newLeave.toTime.minute}',
        'leave_type': newLeave.leaveType.name,
        'leave_justification': newLeave.justification,
        'leave_approval_status': 'Pending',
        'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });

      // Reload leaves
      await loadLeaves(newLeave.empId, false);

      state = state.whenData((s) => s.copyWith(isLoading: false));
    } catch (e, stack) {
      state = AsyncError('Failed to apply leave: $e', stack);
    }
  }

  // Manager approve/reject
  Future<void> updateLeaveStatus(
    String leaveId,
    LeaveStatus newStatus,
    String? remarks,
    String userId,
  ) async {
    state = state.whenData((s) => s.copyWith(isLoading: true));

    try {
      final db = await DBHelper.instance.database;

      await db.update(
        'employee_leaves',
        {
          'leave_approval_status':
              newStatus.name[0].toUpperCase() + newStatus.name.substring(1),
          'manager_comments': remarks,
          'updated_at': DateFormat(
            'yyyy-MM-dd HH:mm:ss',
          ).format(DateTime.now()),
        },
        where: 'leave_id = ?',
        whereArgs: [leaveId],
      );

      // Reload leaves
      await loadLeaves(userId, true);

      state = state.whenData((s) => s.copyWith(isLoading: false));
    } catch (e, stack) {
      state = AsyncError('Failed to update leave status: $e', stack);
    }
  }
}

final leaveProvider =
    StateNotifierProvider<LeaveNotifier, AsyncValue<LeaveState>>((ref) {
      return LeaveNotifier();
    });

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
