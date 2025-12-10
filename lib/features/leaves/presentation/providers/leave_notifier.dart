// lib/features/leaves/presentation/providers/leave_notifier.dart
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveNotifier extends StateNotifier<AsyncValue<List<LeaveModel>>> {
  LeaveNotifier() : super(const AsyncLoading()) {
    loadLeaves();
  }

  Future<void> loadLeaves() async {
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData([
      LeaveModel(
        id: "1",
        userId: "1",
        fromDate: DateTime.now().add(const Duration(days: 5)),
        toDate: DateTime.now().add(const Duration(days: 7)),
        fromTime: const TimeOfDay(hour: 9, minute: 0),
        toTime: const TimeOfDay(hour: 18, minute: 0),
        leaveType: LeaveType.casual,
        notes: "Family function",
        appliedDate: DateTime.now(),
      ),
    ]);
  }
}

final leaveProvider =
    StateNotifierProvider<LeaveNotifier, AsyncValue<List<LeaveModel>>>((ref) {
      return LeaveNotifier();
    });
