// lib/features/attendance/presentation/screens/attendance_analytics_screen.dart
// FIXED ROLE-BASED + TOGGLE WORKING - January 15, 2026

import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/active_projects.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/employee_overview_widget.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/graph_toggle.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/merged_graph_widget.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/period_selector_widget.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/personal_overview_widget.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/statistics_cards.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        title: const Text('Attendance Analytics'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(analyticsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Please login first'));
          }

          final isManager = user.isManagerial;

          // Manager ke liye default Merge Graph set karo
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (isManager &&
          //       ref.read(analyticsViewProvider) != AnalyticsView.mergeGraph) {
          //     ref.read(analyticsViewProvider.notifier).state =
          //         AnalyticsView.mergeGraph;
          //   }
          // });

          return Column(
            children: [
              PeriodSelectorWidget(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Stats Cards → Only Manager
                      if (isManager) const StatsCardsWidget(),

                      const SizedBox(height: 16),

                      // Toggle → 3 for manager, 2 for employee
                      ToggleWidget(ref: ref, isManager: isManager),

                      const SizedBox(height: 16),

                      // Dynamic Content → Toggle se connected
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildDynamicContent(ref, isManager),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stk) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text('Error loading user: $err', textAlign: TextAlign.center),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  onPressed: () => ref.invalidate(authProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicContent(WidgetRef ref, bool isManager) {
    final view = ref.watch(analyticsViewProvider);

    // Employee ko Merge Graph nahi dikhana
    if (view == AnalyticsView.mergeGraph && !isManager) {
      return const SizedBox.shrink();
    }

    return ref
        .watch(analyticsProvider)
        .when(
          data: (analytics) {
            switch (view) {
              case AnalyticsView.mergeGraph:
                return MergedGraphWidget();

              case AnalyticsView.employeeOverview:
                return isManager
                    ? const EmployeeOverviewWidget() // Manager: Team list
                    : const PersonalEmployeeOverviewWidget(); // Employee: Personal pie + stats

              case AnalyticsView.activeProjects:
                return const ActiveProjectsWidget(); // Active projects cards
            }
          },

          loading: () => SizedBox(
            height: 400,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (_, __) => Container(
                  height: 180,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),

          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 60,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text('Failed to load: $err', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    onPressed: () =>
                        ref.read(analyticsProvider.notifier).refresh(),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
