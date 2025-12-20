// lib/features/regularisation/presentation/providers/regularisation_notifier.dart

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegularisationRequest {
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

  const RegularisationRequest({
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
    this.projectNames = const [], // const empty list
  });
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
  final String error;

  const RegularisationState({
    this.requests = const [],
    this.stats = const RegularisationStats(
      total: 0,
      pending: 0,
      approved: 0,
      rejected: 0,
    ),
    this.isLoading = false,
    this.error = '',
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
  RegularisationNotifier() : super(const RegularisationState()) {
    loadRequests();
  }

  Future<void> loadRequests() async {
    state = state.copyWith(isLoading: true, error: '');

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/dummy_data.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);

      final List<dynamic> regList = data['employee_regularization'] ?? [];

      final List<RegularisationRequest> allRequests = regList.map((json) {
        List<String> projects = [];
        final mapped = data['employee_mapped_projects'] as List<dynamic>? ?? [];
        final projectMaster = data['project_master'] as List<dynamic>? ?? [];

        for (var mapping in mapped) {
          if (mapping['emp_id'] == json['emp_id']) {
            final proj = projectMaster.firstWhere(
              (p) => p['project_id'] == mapping['project_id'],
              orElse: () => {'project_name': 'Unknown Project'},
            );
            projects.add(proj['project_name']);
          }
        }

        final empMaster = data['employee_master'] as List<dynamic>? ?? [];
        final emp = empMaster.firstWhere(
          (e) => e['emp_id'] == json['emp_id'],
          orElse: () => {
            'emp_name': 'Unknown Employee',
            'emp_role': 'Employee',
          },
        );

        return RegularisationRequest(
          empId: json['emp_id'],
          empName: emp['emp_name'],
          designation: emp['emp_role'],
          appliedDate: json['reg_date_applied'],
          forDate: json['reg_applied_for_date'],
          justification: json['reg_justification'],
          status: json['reg_approval_status'],
          type: 'Full Day',
          projectNames: projects,
        );
      }).toList();

      final int total = allRequests.length;
      final int pending = allRequests
          .where((r) => r.status == 'pending')
          .length;
      final int approved = allRequests
          .where((r) => r.status == 'approved')
          .length;
      final int rejected = allRequests
          .where((r) => r.status == 'rejected')
          .length;

      state = state.copyWith(
        isLoading: false,
        requests: allRequests,
        stats: RegularisationStats(
          total: total,
          pending: pending,
          approved: approved,
          rejected: rejected,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data: $e',
      );
    }
  }

  List<RegularisationRequest> getOwnRequests(String currentEmpId) {
    return state.requests.where((r) => r.empId == currentEmpId).toList();
  }
}

final regularisationProvider =
    StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
      return RegularisationNotifier();
    });

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
//   final String? shortfall;
//   final List<String> projectNames; // Empty list allowed

//   RegularisationRequest({
//     required this.empId,
//     required this.empName,
//     required this.designation,
//     required this.appliedDate,
//     required this.forDate,
//     required this.justification,
//     required this.status,
//     required this.type,
//     this.checkinTime,
//     this.shortfall,
//     this.projectNames = const [], // Default empty list
//   });
// }

// class RegularisationStats {
//   final int total;
//   final int pending;
//   final int approved;
//   final int rejected;

//   RegularisationStats({
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
//         'assets/dummy_data.json',
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

//         return RegularisationRequest(
//           empId: json['emp_id'],
//           empName: emp['emp_name'],
//           designation: emp['emp_role'],
//           appliedDate: json['reg_date_applied'],
//           forDate: json['reg_applied_for_date'],
//           justification: json['reg_justification'],
//           status: json['reg_approval_status'],
//           type: 'Full Day',
//           projectNames: projects, // Pass kiya, empty bhi allowed
//         );
//       }).toList();

//       // Stats
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

//   List<RegularisationRequest> getOwnRequests(String currentEmpId) {
//     return state.requests.where((r) => r.empId == currentEmpId).toList();
//   }
// }

// final regularisationProvider =
//     StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
//       return RegularisationNotifier();
//     });

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
//   final String? shortfall;
//   final List<String> projectNames;

//   RegularisationRequest({
//     required this.empId,
//     required this.empName,
//     required this.designation,
//     required this.appliedDate,
//     required this.forDate,
//     required this.justification,
//     required this.status,
//     required this.type,
//     this.checkinTime,
//     this.shortfall,
//     required this.projectNames,
//   });
// }

// class RegularisationStats {
//   final int total;
//   final int pending;
//   final int approved;
//   final int rejected;

//   RegularisationStats({
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
//       // Load dummy_data.json from assets
//       final String jsonString = await rootBundle.loadString(
//         'assets/dummy_data.json',
//       );
//       final Map<String, dynamic> data = jsonDecode(jsonString);

//       final List<dynamic> regList = data['employee_regularization'] ?? [];

//       // Map to RegularisationRequest
//       final List<RegularisationRequest> allRequests = regList.map((json) {
//         // Projects mapping (from employee_mapped_projects + project_master)
//         final List<String> projects = [];
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
//           orElse: () => {'emp_name': 'Unknown', 'emp_role': 'Employee'},
//         );

//         return RegularisationRequest(
//           empId: json['emp_id'],
//           empName: emp['emp_name'],
//           designation: emp['emp_role'],
//           appliedDate: json['reg_date_applied'],
//           forDate: json['reg_applied_for_date'],
//           justification: json['reg_justification'],
//           status: json['reg_approval_status'],
//           type: 'Full Day', // Can be enhanced later
//           projects: projects,
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

//   // Filter for Employee view (only own requests)
//   List<RegularisationRequest> getOwnRequests(String currentEmpId) {
//     return state.requests.where((r) => r.empId == currentEmpId).toList();
//   }
// }

// final regularisationProvider =
//     StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
//       return RegularisationNotifier();
//     });

// // lib/features/regularisation/presentation/providers/regularisation_notifier.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RegularisationState {
//   final List<Map<String, dynamic>> requests;
//   final bool isLoading;

//   const RegularisationState({this.requests = const [], this.isLoading = false});

//   // YE METHOD ADD KAR DE — copyWith()
//   RegularisationState copyWith({
//     List<Map<String, dynamic>>? requests,
//     bool? isLoading,
//   }) {
//     return RegularisationState(
//       requests: requests ?? this.requests,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }

// final regularisationProvider =
//     StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
//       return RegularisationNotifier();
//     });

// class RegularisationNotifier extends StateNotifier<RegularisationState> {
//   RegularisationNotifier() : super(const RegularisationState()) {
//     loadRequests();
//   }

//   Future<void> loadRequests() async {
//     state = state.copyWith(isLoading: true); // AB YE CHALEGA!

//     await Future.delayed(const Duration(seconds: 1));

//     state = state.copyWith(
//       isLoading: false,
//       requests: [
//         {
//           'id': 'R001',
//           'date': DateTime.now().subtract(const Duration(days: 2)),
//           'type': 'Late Check-in',
//           'status': 'Pending',
//           'reason': 'Traffic jam',
//         },
//         {
//           'id': 'R002',
//           'date': DateTime.now().subtract(const Duration(days: 1)),
//           'type': 'Early Checkout',
//           'status': 'Approved',
//           'reason': 'Doctor appointment',
//         },
//       ],
//     );
//   }
// }

// // lib/features/regularisation/presentation/providers/regularisation_notifier.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RegularisationState {
//   final List<Map<String, dynamic>> requests;
//   final bool isLoading;

//   RegularisationState({this.requests = const [], this.isLoading = false});
// }

// final regularisationProvider =
//     StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
//       return RegularisationNotifier();
//     });

// class RegularisationNotifier extends StateNotifier<RegularisationState> {
//   RegularisationNotifier() : super(RegularisationState()) {
//     loadRequests();
//   }

//   Future<void> loadRequests() async {
//     state = state.copyWith(isLoading: true);
//     await Future.delayed(const Duration(seconds: 1));
//     state = RegularisationState(
//       requests: [
//         {
//           'id': 'R001',
//           'date': DateTime.now().subtract(const Duration(days: 2)),
//           'type': 'Late Check-in',
//           'status': 'Pending',
//           'reason': 'Traffic jam',
//         },
//       ],
//     );
//   }
// }
