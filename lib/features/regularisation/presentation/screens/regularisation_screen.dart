// lib/features/regularisation/presentation/screens/regularisation_screen.dart

import 'package:appattendance/core/constants/role_constants.dart';
import 'package:appattendance/core/providers/bottom_nav_providers.dart';
import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/theme/bottom_navigation.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:appattendance/features/leaves/presentation/screens/leave_screen.dart';
import 'package:appattendance/features/regularisation/presentation/screens/apply_regularisation_screen.dart';
import 'package:appattendance/features/regularisation/presentation/screens/manager_regularisation_screen.dart';
import 'package:appattendance/features/regularisation/presentation/screens/employee_regularisation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegularisationScreen extends ConsumerWidget {
  const RegularisationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authProvider);
    final viewMode = ref.watch(viewModeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Regularisation'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.dashboard(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        child: SafeArea(
          child: userAsync.when(
            data: (user) {
              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final roleName = user.role.name;
              final isManagerRole = RoleConstants.canViewTeamRequests(roleName);
              final isEmployeeViewMode = viewMode == ViewMode.employee;

              // Body content based on role + view mode
              final Widget bodyContent;
              if (RoleConstants.isEmployee(roleName) || isEmployeeViewMode) {
                // Employee view (or manager toggled to employee)
                bodyContent = EmployeeRegularisationScreen(user: user.toJson());
              } else if (isManagerRole) {
                // Manager view
                bodyContent = ManagerRegularisationScreen(
                  user: user.toJson(),
                  canApproveReject: RoleConstants.canApproveReject(roleName),
                );
              } else {
                bodyContent = Center(
                  child: Text(
                    "Access Denied",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                );
              }

              final bool showFAB =
                  RoleConstants.isEmployee(roleName) || isEmployeeViewMode;

              return Stack(
                children: [
                  bodyContent,
                  if (showFAB)
                    Positioned(
                      bottom: 80,
                      right: 20,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApplyRegularisationScreen(
                                user: user.toJson(),
                              ),
                            ),
                          );
                        },
                        label: const Text('Apply New'),
                        icon: const Icon(Icons.add),
                        backgroundColor: AppColors.primary,
                        elevation: 8,
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error loading user: $err',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigation(
          currentIndex: 1, // Regularisation tab
          onTabChanged: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;

            // Navigation logic: pushReplacement to avoid stack buildup
            final screens = [
              const DashboardScreen(), // Index 0
              null, // Index 1 (current - RegularisationScreen, no push needed)
              const LeaveScreen(), // Index 2
              // const TimesheetScreen(), // Index 3 (add when ready)
            ];

            if (index != 1 && screens[index] != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => screens[index]!),
              );
            }
          },
        ),
      ),
    );
  }
}
