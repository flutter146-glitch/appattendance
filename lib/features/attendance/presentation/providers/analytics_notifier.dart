// lib/features/analytics/presentation/providers/analytics_notifier.dart

import 'package:appattendance/features/attendance/data/repositories/analytics_repository.dart';
import 'package:appattendance/features/attendance/data/repositories/analytics_repository_impl.dart';
import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsModel>> {
  final Ref ref;

  AnalyticsNotifier(this.ref) : super(const AsyncLoading()) {
    loadAnalytics(AnalyticsPeriod.monthly); // Default monthly
  }

  Future<void> loadAnalytics(AnalyticsPeriod period) async {
    state = const AsyncLoading();

    try {
      final user = ref.read(authProvider).value;
      if (user == null) {
        state = AsyncError('Not logged in', StackTrace.current);
        return;
      }

      final repository = ref.read(analyticsRepositoryProvider);

      // Calculate start/end based on period
      final now = DateTime.now();
      DateTime start;
      DateTime end;

      switch (period) {
        case AnalyticsPeriod.daily:
          start = DateTime(now.year, now.month, now.day);
          end = start.add(const Duration(days: 1));
          break;
        case AnalyticsPeriod.weekly:
          start = now.subtract(Duration(days: now.weekday - 1));
          end = start.add(const Duration(days: 7));
          break;
        case AnalyticsPeriod.monthly:
          start = DateTime(now.year, now.month, 1);
          end = DateTime(now.year, now.month + 1, 1);
          break;
        case AnalyticsPeriod.quarterly:
          final quarterStartMonth = ((now.month - 1) ~/ 3) * 3 + 1;
          start = DateTime(now.year, quarterStartMonth, 1);
          end = DateTime(now.year, quarterStartMonth + 3, 1);
          break;
      }

      final analytics = await repository.getAnalytics(
        empId: user.empId,
        period: period,
        startDate: start,
        endDate: end,
      );

      state = AsyncData(analytics);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  // Repository provider (SQLite impl abhi)
  final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
    return AnalyticsRepositoryImpl();
  });
}

// // lib/features/analytics/presentation/providers/analytics_notifier.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AnalyticsState {
//   final int present;
//   final int absent;
//   final int late;
//   final double avgHours;

//   AnalyticsState({
//     required this.present,
//     required this.absent,
//     required this.late,
//     required this.avgHours,
//   });
// }

// class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsState>> {
//   AnalyticsNotifier() : super(const AsyncLoading()) {
//     loadAnalytics();
//   }

//   Future<void> loadAnalytics() async {
//     await Future.delayed(const Duration(seconds: 1));
//     state = AsyncData(
//       AnalyticsState(present: 22, absent: 3, late: 5, avgHours: 8.5),
//     );
//   }
// }

// final analyticsProvider =
//     StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsState>>((ref) {
//       return AnalyticsNotifier();
//     });
