// lib/features/analytics/presentation/providers/analytics_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsState {
  final int present;
  final int absent;
  final int late;
  final double avgHours;

  AnalyticsState({
    required this.present,
    required this.absent,
    required this.late,
    required this.avgHours,
  });
}

class AnalyticsNotifier extends StateNotifier<AsyncValue<AnalyticsState>> {
  AnalyticsNotifier() : super(const AsyncLoading()) {
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncData(
      AnalyticsState(present: 22, absent: 3, late: 5, avgHours: 8.5),
    );
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsState>>((ref) {
      return AnalyticsNotifier();
    });
