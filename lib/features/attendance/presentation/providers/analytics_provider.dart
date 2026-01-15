// lib/features/attendance/presentation/providers/analytics_provider.dart
// Providers only - contains all Riverpod providers

import 'dart:async';
import 'package:appattendance/core/database/database_provider.dart';
import 'package:appattendance/features/attendance/data/repositories/analytics_repository.dart';
import 'package:appattendance/features/attendance/data/repositories/analytics_repository_impl.dart';
import 'package:appattendance/features/attendance/data/repositories/attendance_analytics_repository_impl.dart';
import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/analytics_notifier.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Repository Provider ─────────────────────────────────────────────────────
final attendanceAnalyticsRepositoryProvider =
    Provider<AttendanceAnalyticsRepository>((ref) {
      final dbHelper = ref.watch(dbHelperProvider);
      return AttendanceAnalyticsRepositoryImpl(dbHelper);
    });

// ── Period Selector Provider ────────────────────────────────────────────────
final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>(
  (ref) => AnalyticsPeriod.daily,
);

// ── Selected Date Provider (for period selector) ───────────────────────────
final selectedDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(), // Default to current date
);

// ── View Toggle Provider (for manager/employee toggle) ────────────────────
enum AnalyticsView { mergeGraph, employeeOverview, activeProjects }

final analyticsViewProvider = StateProvider<AnalyticsView>(
  (ref) => AnalyticsView.mergeGraph,
);

// ── Main Analytics Provider (AutoDispose) ───────────────────────────────────
final analyticsProvider =
    StateNotifierProvider.autoDispose<
      AnalyticsNotifier,
      AsyncValue<AnalyticsModel>
    >((ref) => AnalyticsNotifier(ref));

// ── Individual Employee Analytics (Family Provider) ─────────────────────────
// Use in team member detail screen (manager taps on employee)
final individualAnalyticsProvider =
    FutureProvider.family<AnalyticsModel, String>((ref, empId) async {
      final repo = ref.read(attendanceAnalyticsRepositoryProvider);
      return await repo.getAnalytics(
        period: AnalyticsPeriod.monthly, // Default or from selector
        empId: empId, // Employee's ID
        includeTeamBreakdown: false, // Personal only
      );
    });

// ── Project Analytics Provider (for active projects toggle) ────────────────
final projectAnalyticsProvider = FutureProvider<List<ProjectAnalytics>>((
  ref,
) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return [];

  // TODO: Implement project analytics fetch
  return [];
});

// Temporary ProjectAnalytics class (define in analytics_model.dart or here)
class ProjectAnalytics {
  final String projectId;
  final String name;
  final String description;
  final double progress;
  final int teamSize;
  final int daysLeft;

  ProjectAnalytics({
    required this.projectId,
    required this.name,
    required this.description,
    required this.progress,
    required this.teamSize,
    required this.daysLeft,
  });
}
// // lib/features/attendance/presentation/providers/analytics_provider.dart
// // FINAL & BEST PRACTICE VERSION - January 09, 2026
// // Features:
// // - AutoDispose for memory efficiency
// // - Role-based loading (employee personal vs manager team)
// // - Period selector with auto-refresh
// // - Debounced refresh (pull-to-refresh spam protection)
// // - Error handling with user-friendly messages
// // - Single source for all analytics (merged graph, team stats, insights)
// // - Easy to extend for individual employee graphs

// import 'dart:async';

// import 'package:appattendance/core/database/database_provider.dart';
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository_impl.dart';
// import 'package:appattendance/features/attendance/data/repositories/attendance_analytics_repository_impl.dart';
// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/analytics_notifier.dart';
// import 'package:appattendance/features/auth/domain/models/user_extension.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // ── Period Selector Provider ────────────────────────────────────────────────
// final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>(
//   (ref) => AnalyticsPeriod.daily,
// );

// // ── Repository Provider ─────────────────────────────────────────────────────
// // Injects DBHelper automatically
// final attendanceAnalyticsRepositoryProvider =
//     Provider<AttendanceAnalyticsRepository>((ref) {
//       final dbHelper = ref.watch(dbHelperProvider);
//       return AttendanceAnalyticsRepositoryImpl(dbHelper);
//     });

// // ── Main Analytics Provider (AutoDispose) ───────────────────────────────────
// final analyticsProvider =
//     StateNotifierProvider.autoDispose<
//       AnalyticsNotifier,
//       AsyncValue<AnalyticsModel>
//     >((ref) => AnalyticsNotifier(ref));

// class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsModel>> {
//   final Ref ref;
//   Timer? _debounceTimer;

//   AnalyticsNotifier(this.ref) : super(const AsyncLoading()) {
//     loadAnalytics();
//   }

//   Future<void> loadAnalytics() async {
//     if (state.isLoading) return;

//     state = const AsyncLoading();
//     print('Analytics loading started...');

//     try {
//       final user = ref.read(authProvider).value;
//       if (user == null) {
//         state = AsyncError(
//           'Please login to view analytics',
//           StackTrace.current,
//         );
//         print('No user logged in');
//         return;
//       }

//       print(
//         'Loading analytics for user: ${user.empId} (Manager: ${user.isManagerial})',
//       );

//       final period = ref.read(analyticsPeriodProvider);
//       final repo = ref.read(attendanceAnalyticsRepositoryProvider);
//       final analytics = await repo.getAnalytics(
//         period: period,
//         empId: user.empId,
//         includeTeamBreakdown: user.isManagerial,
//         limit: user.isManagerial ? 50 : null,
//       );

//       print(
//         'Analytics loaded: ${analytics.teamStats['team']} team members, ${analytics.presentDays} present, ${analytics.leaveDays} leave',
//       );
//       state = AsyncData(analytics);
//     } catch (e, stack) {
//       print('Analytics load error: $e');
//       print(stack);
//       state = AsyncError(
//         'Failed to load analytics data. Please check your connection.',
//         stack,
//       );
//     }
//   }

//   // Future<void> loadAnalytics() async {
//   //   if (state.isLoading) return; // Prevent duplicate calls

//   //   state = const AsyncLoading();

//   //   try {
//   //     final user = ref.read(authProvider).value;
//   //     if (user == null) {
//   //       state = AsyncError(
//   //         'Please login to view analytics',
//   //         StackTrace.current,
//   //       );
//   //       return;
//   //     }

//   //     final period = ref.read(analyticsPeriodProvider);
//   //     final isManager = user.isManagerial;

//   //     final repo = ref.read(attendanceAnalyticsRepositoryProvider);
//   //     final analytics = await repo.getAnalytics(
//   //       period: period,
//   //       empId: user.empId,
//   //       includeTeamBreakdown: isManager, // Manager → team aggregate + breakdown
//   //       limit: isManager ? 50 : null, // Limit breakdown for performance
//   //     );

//   //     state = AsyncData(analytics);
//   //   } catch (e, stack) {
//   //     state = AsyncError(
//   //       'Unable to load analytics data. Please try again.',
//   //       stack,
//   //     );
//   //   }
//   // }

//   /// Pull-to-refresh / manual refresh with debounce
//   Future<void> refresh() async {
//     _debounceTimer?.cancel();
//     _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
//       await loadAnalytics();
//     });
//   }

//   /// Change period & auto-reload
//   void changePeriod(AnalyticsPeriod newPeriod) {
//     ref.read(analyticsPeriodProvider.notifier).state = newPeriod;
//     refresh();
//   }

//   @override
//   void dispose() {
//     _debounceTimer?.cancel();
//     super.dispose();
//   }
// }

// // ── Optional: Individual Employee Analytics (Family Provider) ───────────────
// // Use in team member detail screen (manager taps on employee)
// final individualAnalyticsProvider =
//     FutureProvider.family<AnalyticsModel, String>((ref, empId) async {
//       final repo = ref.read(attendanceAnalyticsRepositoryProvider);
//       return await repo.getAnalytics(
//         period: AnalyticsPeriod.monthly, // Default or from selector
//         empId: empId, // Employee's ID
//         includeTeamBreakdown: false, // Personal only
//       );
//     });

// // ── Optional: Combined Analytics (Merged Graph Ready) ───────────────────────
// // Use when you need both personal + team in one view (e.g., dashboard)
// final combinedAnalyticsProvider = Provider<AsyncValue<AnalyticsModel>>((ref) {
//   final analyticsAsync = ref.watch(analyticsProvider);

//   if (analyticsAsync.isLoading) {
//     return const AsyncLoading();
//   }

//   if (analyticsAsync.hasError) {
//     return AsyncError(analyticsAsync.error!, analyticsAsync.stackTrace!);
//   }

//   return analyticsAsync;
// });

// final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

// // lib/features/attendance/presentation/providers/analytics_provider.dart
// // Riverpod Providers for Analytics

// import 'package:appattendance/core/database/database_provider.dart';
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository_impl.dart';
// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/analytics_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Repository Provider (switch to API impl later)
// final attendanceAnalyticsRepositoryProvider =
//     Provider<AttendanceAnalyticsRepository>((ref) {
//       final dbHelper = ref.watch(dbHelperProvider);
//       return AttendanceAnalyticsRepositoryImpl(dbHelper);
//     });

// // Analytics Period Provider (user can switch daily/weekly/etc.)
// final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>(
//   (ref) => AnalyticsPeriod.daily,
// );

// // Analytics State Notifier Provider
// final analyticsProvider =
//     StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsModel>>((ref) {
//       final repo = ref.watch(attendanceAnalyticsRepositoryProvider);
//       return AnalyticsNotifier(repo, ref);
//     });

// // lib/features/attendance/presentation/providers/analytics_provider.dart
// // Riverpod Providers for Analytics

// import 'package:appattendance/core/database/database_provider.dart';
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository_impl.dart';
// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/analytics_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Repository Provider (switch to API impl later)
// final attendanceAnalyticsRepositoryProvider =
//     Provider<AttendanceAnalyticsRepository>((ref) {
//       final dbHelper = ref.watch(dbHelperProvider);
//       return AttendanceAnalyticsRepositoryImpl(dbHelper);
//     });

// // Analytics Period Provider (user can switch daily/weekly/etc.)
// final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>(
//   (ref) => AnalyticsPeriod.daily,
// );

// // Analytics State Notifier Provider
// final analyticsProvider =
//     StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsModel>>((ref) {
//       final repo = ref.watch(attendanceAnalyticsRepositoryProvider);
//       return AnalyticsNotifier(repo, ref);
//     });

// // lib/features/attendance/presentation/providers/analytics_provider.dart
// // Riverpod Providers for Analytics

// import 'package:appattendance/core/database/database_provider.dart';
// import 'package:appattendance/core/database/db_helper.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository.dart';
// import 'package:appattendance/features/attendance/data/repositories/analytics_repository_impl.dart';
// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/analytics_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Repository Provider (switch to API impl later)
// final attendanceAnalyticsRepositoryProvider =
//     Provider<AttendanceAnalyticsRepository>((ref) {
//       final dbHelper = ref.watch(dbHelperProvider);
//       return AttendanceAnalyticsRepositoryImpl(dbHelper);
//     });

// // Analytics Period Provider (user can switch daily/weekly/etc.)
// final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>(
//   (ref) => AnalyticsPeriod.daily,
// );

// // Analytics State Notifier Provider
// final analyticsProvider =
//     StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsModel>>((ref) {
//       final repo = ref.watch(attendanceAnalyticsRepositoryProvider);
//       return AnalyticsNotifier(repo, ref);
//     });
// // lib/features/analytics/presentation/providers/analytics_provider.dart

// import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
// import 'package:appattendance/features/attendance/presentation/providers/analytics_notifier.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final analyticsProvider =
//     StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsModel>>(
//       (ref) => AnalyticsNotifier(ref),
//     );
