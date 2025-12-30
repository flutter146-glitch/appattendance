// lib/features/analytics/presentation/providers/analytics_provider.dart

import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/analytics_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AsyncValue<AnalyticsModel>>(
      (ref) => AnalyticsNotifier(ref),
    );
