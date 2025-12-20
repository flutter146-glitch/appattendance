// lib/features/regularisation/presentation/providers/regularisation_provider.dart

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
  final String? shortfall;
  final List<String> projects;

  RegularisationRequest({
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
    this.shortfall,
    required this.projects,
  });
}

class RegularisationStats {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  RegularisationStats({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });
}

class RegularisationNotifier extends StateNotifier<AsyncValue<void>> {
  RegularisationNotifier() : super(const AsyncData(null)) {
    loadData();
  }

  List<RegularisationRequest> requests = [];
  RegularisationStats stats = RegularisationStats(
    total: 0,
    pending: 0,
    approved: 0,
    rejected: 0,
  );
  bool isLoading = false;

  Future<void> loadData() async {
    state = const AsyncLoading();
    isLoading = true;

    try {
      // Fake API call — local JSON se
      final String response = await rootBundle.loadString(
        'assets/dummy_data.json',
      );
      final data = jsonDecode(response);

      final List<dynamic> reqList = data['employee_regularization'];
      requests = reqList
          .map(
            (json) => RegularisationRequest(
              regId: json['reg_id'],
              empId: json['emp_id'],
              empName: json['emp_name'],
              designation: json['emp_designation'],
              appliedDate: json['reg_date_applied'],
              forDate: json['reg_applied_for_date'],
              justification: json['reg_justification'],
              status: json['reg_approval_status'],
              type: json['reg_type'],
              checkinTime: json['checkin_time'],
              shortfall: json['shortfall_time'],
              projects: List<String>.from(json['projects']),
            ),
          )
          .toList();

      final statsJson = data['stats'];
      stats = RegularisationStats(
        total: statsJson['total'],
        pending: statsJson['pending'],
        approved: statsJson['approved'],
        rejected: statsJson['rejected'],
      );

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    } finally {
      isLoading = false;
    }
  }
}

final regularisationProvider =
    StateNotifierProvider<RegularisationNotifier, AsyncValue<void>>((ref) {
      return RegularisationNotifier();
    });
