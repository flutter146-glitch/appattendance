// lib/features/dashboard/presentation/providers/dashboard_provider.dart
// Riverpod Provider for Dashboard state
// Exposes DashboardNotifier to all screens

import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardState>>(
      (ref) => DashboardNotifier(ref),
    );
