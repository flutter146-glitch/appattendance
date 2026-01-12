// lib/features/regularisation/presentation/providers/regularisation_notifier.dart
// FINAL UPGRADED VERSION - January 06, 2026
// Uses local DB + dummy data (no http/Dio)
// Role-based: Manager sees team requests, Employee sees own
// Null-safe, loading/error states, real DB fetch & update
// approve/reject with remarks + refresh

import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

class RegularisationRequest {
  final String regId;
  final String empId;
  final String empName;
  final String designation;
  final String appliedDate;
  final String forDate;
  final String justification;
  final String status;
  final String type;
  final String? checkinTime;
  final String? checkoutTime;
  final String? shortfall;
  final List<String> projectNames;
  final String? managerRemarks;

  const RegularisationRequest({
    required this.regId,
    required this.empId,
    required this.empName,
    required this.designation,
    required this.appliedDate,
    required this.forDate,
    required this.justification,
    required this.status,
    required this.type,
    this.checkinTime,
    this.checkoutTime,
    this.shortfall,
    this.projectNames = const [],
    this.managerRemarks,
  });

  factory RegularisationRequest.fromMap(Map<String, dynamic> map) {
    return RegularisationRequest(
      regId: map['reg_id'] as String? ?? '',
      empId: map['emp_id'] as String? ?? '',
      empName: map['emp_name'] as String? ?? 'Unknown',
      designation: map['designation'] as String? ?? 'Employee',
      appliedDate: map['reg_date_applied'] as String? ?? '',
      forDate: map['reg_applied_for_date'] as String? ?? '',
      justification: map['reg_justification'] as String? ?? '',
      status: map['reg_approval_status'] as String? ?? 'pending',
      type: map['type'] as String? ?? 'Full Day',
      checkinTime: map['reg_first_check_in'] as String?,
      checkoutTime: map['reg_last_check_out'] as String?,
      shortfall: map['shortfall_hrs'] as String?,
      projectNames: [], // Populate from join if needed
      managerRemarks: map['mgr_comments'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reg_id': regId,
      'emp_id': empId,
      'reg_date_applied': appliedDate,
      'reg_applied_for_date': forDate,
      'reg_justification': justification,
      'reg_approval_status': status,
      'type': type,
      'reg_first_check_in': checkinTime,
      'reg_last_check_out': checkoutTime,
      'shortfall_hrs': shortfall,
      'mgr_comments': managerRemarks,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}

class RegularisationStats {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  const RegularisationStats({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });
}

class RegularisationState {
  final List<RegularisationRequest> requests;
  final RegularisationStats stats;
  final bool isLoading;
  final String? error;

  const RegularisationState({
    this.requests = const [],
    this.stats = const RegularisationStats(
      total: 0,
      pending: 0,
      approved: 0,
      rejected: 0,
    ),
    this.isLoading = false,
    this.error,
  });

  RegularisationState copyWith({
    List<RegularisationRequest>? requests,
    RegularisationStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return RegularisationState(
      requests: requests ?? this.requests,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class RegularisationNotifier extends StateNotifier<RegularisationState> {
  final Ref ref;

  RegularisationNotifier(this.ref) : super(const RegularisationState()) {
    loadRequests();
  }

  Future<void> loadRequests() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final db = await DBHelper.instance.database;
      final user = ref.read(authProvider).value;

      if (user == null) throw Exception('No user logged in');

      String query;
      List<dynamic> args;

      if (user.isManagerial) {
        // Manager: Team requests
        query = '''
          SELECT r.*, e.emp_name, e.designation
          FROM employee_regularization r
          JOIN employee_master e ON r.emp_id = e.emp_id
          WHERE e.reporting_manager_id = ?
          ORDER BY r.created_at DESC
        ''';
        args = [user.empId];
      } else {
        // Employee: Own requests
        query = '''
          SELECT r.*, e.emp_name, e.designation
          FROM employee_regularization r
          JOIN employee_master e ON r.emp_id = e.emp_id
          WHERE r.emp_id = ?
          ORDER BY r.created_at DESC
        ''';
        args = [user.empId];
      }

      final rows = await db.rawQuery(query, args);

      final loadedRequests = rows.map(RegularisationRequest.fromMap).toList();

      // Stats from DB (efficient COUNT)
      final statsQuery = await db.rawQuery(
        '''
        SELECT 
          COUNT(*) as total,
          SUM(CASE WHEN reg_approval_status = 'pending' THEN 1 ELSE 0 END) as pending,
          SUM(CASE WHEN reg_approval_status = 'approved' THEN 1 ELSE 0 END) as approved,
          SUM(CASE WHEN reg_approval_status = 'rejected' THEN 1 ELSE 0 END) as rejected
        FROM employee_regularization
        WHERE ${user.isManagerial ? 'emp_id IN (SELECT emp_id FROM employee_master WHERE reporting_manager_id = ?)' : 'emp_id = ?'}
        ''',
        [user.empId],
      );

      final statsRow = statsQuery.first;

      state = state.copyWith(
        isLoading: false,
        requests: loadedRequests,
        stats: RegularisationStats(
          total: statsRow['total'] as int? ?? 0,
          pending: statsRow['pending'] as int? ?? 0,
          approved: statsRow['approved'] as int? ?? 0,
          rejected: statsRow['rejected'] as int? ?? 0,
        ),
      );
    } catch (e, stack) {
      state = state.copyWith(isLoading: false, error: 'Failed to load: $e');
    }
  }

  Future<void> addRequest(RegularisationRequest newRequest) async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final db = await DBHelper.instance.database;

      // Insert into DB
      await db.insert(
        'employee_regularization',
        newRequest.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Refresh state
      await loadRequests();
    } catch (e, stack) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add request: $e',
      );
    }
  }

  Future<void> approveRequest(String regId, String remarks) async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final db = await DBHelper.instance.database;
      await db.update(
        'employee_regularization',
        {
          'reg_approval_status': 'approved',
          'mgr_comments': remarks,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'reg_id = ?',
        whereArgs: [regId],
      );
      await loadRequests();
    } catch (e, stack) {
      state = state.copyWith(isLoading: false, error: 'Failed to approve: $e');
    }
  }

  Future<void> rejectRequest(String regId, String remarks) async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final db = await DBHelper.instance.database;
      await db.update(
        'employee_regularization',
        {
          'reg_approval_status': 'rejected',
          'mgr_comments': remarks,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'reg_id = ?',
        whereArgs: [regId],
      );
      await loadRequests();
    } catch (e, stack) {
      state = state.copyWith(isLoading: false, error: 'Failed to reject: $e');
    }
  }

  Future<void> refresh() async {
    await loadRequests();
  }
}

// // lib/features/regularisation/presentation/providers/regularisation_notifier.dart

// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RegularisationRequest {
//   final String empId;
//   final String empName;
//   final String designation;
//   final String appliedDate;
//   final String forDate;
//   final String justification;
//   final String status;
//   final String type;
//   final String? checkinTime;
//   final String? checkoutTime;
//   final String? shortfall;
//   final List<String> projectNames;
//   final String? managerRemarks;

//   const RegularisationRequest({
//     required this.empId,
//     required this.empName,
//     required this.designation,
//     required this.appliedDate,
//     required this.forDate,
//     required this.justification,
//     required this.status,
//     required this.type,
//     this.checkinTime,
//     this.checkoutTime,
//     this.shortfall,
//     this.projectNames = const [],
//     this.managerRemarks,
//   });
// }

// class RegularisationStats {
//   final int total;
//   final int pending;
//   final int approved;
//   final int rejected;

//   const RegularisationStats({
//     required this.total,
//     required this.pending,
//     required this.approved,
//     required this.rejected,
//   });
// }

// class RegularisationState {
//   final List<RegularisationRequest> requests;
//   final RegularisationStats stats;
//   final bool isLoading;
//   final String error;

//   const RegularisationState({
//     this.requests = const [],
//     this.stats = const RegularisationStats(
//       total: 0,
//       pending: 0,
//       approved: 0,
//       rejected: 0,
//     ),
//     this.isLoading = false,
//     this.error = '',
//   });

//   RegularisationState copyWith({
//     List<RegularisationRequest>? requests,
//     RegularisationStats? stats,
//     bool? isLoading,
//     String? error,
//   }) {
//     return RegularisationState(
//       requests: requests ?? this.requests,
//       stats: stats ?? this.stats,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }

// class RegularisationNotifier extends StateNotifier<RegularisationState> {
//   RegularisationNotifier() : super(const RegularisationState()) {
//     loadRequests();
//   }

//   Future<void> loadRequests() async {
//     state = state.copyWith(isLoading: true, error: '');

//     try {
//       final String jsonString = await rootBundle.loadString(
//         'assets/data/dummy_data.json',
//       );
//       final Map<String, dynamic> data = jsonDecode(jsonString);

//       final List<dynamic> regList = data['employee_regularization'] ?? [];

//       final List<RegularisationRequest> allRequests = regList.map((json) {
//         // Projects mapping
//         List<String> projects = [];
//         final mapped = data['employee_mapped_projects'] as List<dynamic>? ?? [];
//         final projectMaster = data['project_master'] as List<dynamic>? ?? [];

//         for (var mapping in mapped) {
//           if (mapping['emp_id'] == json['emp_id']) {
//             final proj = projectMaster.firstWhere(
//               (p) => p['project_id'] == mapping['project_id'],
//               orElse: () => {'project_name': 'Unknown Project'},
//             );
//             projects.add(proj['project_name']);
//           }
//         }

//         // Employee details
//         final empMaster = data['employee_master'] as List<dynamic>? ?? [];
//         final emp = empMaster.firstWhere(
//           (e) => e['emp_id'] == json['emp_id'],
//           orElse: () => {
//             'emp_name': 'Unknown Employee',
//             'emp_role': 'Employee',
//           },
//         );

//         // Type mapping
//         String type = 'Full Day';
//         final regType = json['reg_type']?.toString().toLowerCase();
//         if (regType == 'checkinonly' || regType == 'check-in only') {
//           type = 'Check-in Only';
//         } else if (regType == 'checkoutonly' || regType == 'check-out only') {
//           type = 'Check-out Only';
//         } else if (regType == 'halfday') {
//           type = 'Half Day';
//         }

//         return RegularisationRequest(
//           empId: json['emp_id'],
//           empName: emp['emp_name'],
//           designation: emp['emp_role'],
//           appliedDate: json['reg_date_applied'],
//           forDate: json['reg_applied_for_date'],
//           justification: json['reg_justification'],
//           status: json['reg_approval_status'],
//           type: type,
//           checkinTime: json['checkin_time'],
//           checkoutTime: json['checkout_time'],
//           shortfall: json['shortfall_time'],
//           projectNames: projects,
//           managerRemarks: json['manager_remarks'] as String?,
//         );
//       }).toList();

//       // Stats calculation
//       final int total = allRequests.length;
//       final int pending = allRequests
//           .where((r) => r.status == 'pending')
//           .length;
//       final int approved = allRequests
//           .where((r) => r.status == 'approved')
//           .length;
//       final int rejected = allRequests
//           .where((r) => r.status == 'rejected')
//           .length;

//       state = state.copyWith(
//         isLoading: false,
//         requests: allRequests,
//         stats: RegularisationStats(
//           total: total,
//           pending: pending,
//           approved: approved,
//           rejected: rejected,
//         ),
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: 'Failed to load data: $e',
//       );
//     }
//   }

//   // Add new request from Apply form
//   void addRequest(RegularisationRequest newRequest) {
//     final updatedRequests = [...state.requests, newRequest];

//     final int total = updatedRequests.length;
//     final int pending = updatedRequests
//         .where((r) => r.status == 'pending')
//         .length;
//     final int approved = updatedRequests
//         .where((r) => r.status == 'approved')
//         .length;
//     final int rejected = updatedRequests
//         .where((r) => r.status == 'rejected')
//         .length;

//     state = state.copyWith(
//       requests: updatedRequests,
//       stats: RegularisationStats(
//         total: total,
//         pending: pending,
//         approved: approved,
//         rejected: rejected,
//       ),
//     );
//   }

//   // Own requests filter
//   List<RegularisationRequest> getOwnRequests(String currentEmpId) {
//     return state.requests.where((r) => r.empId == currentEmpId).toList();
//   }

//   // Future: approve/reject with remarks
//   void approveRequest(String regId, String remarks) {
//     final updated = state.requests.map((r) {
//       if (r.empId == regId) {
//         // Assuming regId is unique, adjust if needed
//         return RegularisationRequest(
//           empId: r.empId,
//           empName: r.empName,
//           designation: r.designation,
//           appliedDate: r.appliedDate,
//           forDate: r.forDate,
//           justification: r.justification,
//           status: 'approved',
//           type: r.type,
//           checkinTime: r.checkinTime,
//           checkoutTime: r.checkoutTime,
//           shortfall: r.shortfall,
//           projectNames: r.projectNames,
//           managerRemarks: remarks, // ← Update remarks here
//         );
//       }
//       return r;
//     }).toList();

//     // Update state
//     state = state.copyWith(requests: updated);
//   }

//   void rejectRequest(String regId, String remarks) {
//     final updated = state.requests.map((r) {
//       if (r.empId == regId) {
//         return RegularisationRequest(
//           empId: r.empId,
//           empName: r.empName,
//           designation: r.designation,
//           appliedDate: r.appliedDate,
//           forDate: r.forDate,
//           justification: r.justification,
//           status: 'rejected',
//           type: r.type,
//           checkinTime: r.checkinTime,
//           checkoutTime: r.checkoutTime,
//           shortfall: r.shortfall,
//           projectNames: r.projectNames,
//           managerRemarks: remarks,
//         );
//       }
//       return r;
//     }).toList();

//     state = state.copyWith(requests: updated);
//   }
// }

// final regularisationProvider =
//     StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
//       return RegularisationNotifier();
//     });
