// lib/features/leaves/presentation/screens/leave_screen.dart

import 'package:appattendance/core/providers/bottom_nav_providers.dart';
import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/theme/bottom_navigation.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:appattendance/features/leaves/presentation/screens/apply_leave_screen.dart';
import 'package:appattendance/features/leaves/presentation/screens/employee_leave_screen.dart';
import 'package:appattendance/features/leaves/presentation/screens/manager_leave_screen.dart';
import 'package:appattendance/features/regularisation/presentation/screens/regularisation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// lib/features/leaves/presentation/screens/leave_screen.dart
class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authProvider);
    final viewMode = ref.watch(viewModeProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Leave'),
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

              final isManagerial = user.isManagerial;
              final isEmployeeViewMode = viewMode == ViewMode.employee;

              // Choose screen based on role + view mode
              final Widget content;
              if (!isManagerial || isEmployeeViewMode) {
                content = EmployeeLeaveScreen(user: user.toJson());
              } else {
                content = ManagerLeaveScreen(
                  user: user.toJson(),
                  canApproveReject: true, // or user.canApproveLeaves ?? false
                );
              }

              final bool showFAB = !isManagerial || isEmployeeViewMode;

              return Stack(
                children: [
                  content,
                  if (showFAB)
                    Positioned(
                      bottom: 80,
                      right: 20,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ApplyLeaveScreen(user: user.toJson()),
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
              child: Text(
                'Error loading user: $err',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigation(
          currentIndex: 2, // Leave tab
          onTabChanged: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;

            // Navigation logic: pushReplacement to avoid stack buildup
            final screens = [
              const DashboardScreen(), // Index 0
              const RegularisationScreen(), // Index 1
              null, // Index 2 (current - LeaveScreen, no push needed)
              // const TimesheetScreen(), // Index 3 (add when ready)
            ];

            if (index != 2 && screens[index] != null) {
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

// // lib/features/leaves/presentation/screens/leave_screen.dart
// import 'package:appattendance/core/constants/role_constants.dart';
// import 'package:appattendance/core/providers/bottom_nav_provider.dart';
// import 'package:appattendance/core/providers/bottom_nav_providers.dart';
// import 'package:appattendance/core/theme/bottom_navigation.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/leaves/presentation/screens/employee_leave_screen.dart';
// import 'package:appattendance/features/leaves/presentation/screens/manager_leave_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LeaveScreen extends ConsumerWidget {
//   const LeaveScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(authProvider).value;
//     if (user == null)
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     final roleName = (user['emp_role'] ?? '').toLowerCase();
//     final isManager = RoleConstants.canViewTeamRequests(roleName);
//     final canApproveReject = RoleConstants.canApproveReject(roleName);

//     final Widget body = isManager
//         ? ManagerLeaveScreen(user: user, canApproveReject: canApproveReject)
//         : EmployeeLeaveScreen(user: user);

//     final bool showFAB = !isManager || RoleConstants.isEmployee(roleName);

//     return Scaffold(
//       body: body,
//       floatingActionButton: showFAB
//           ? FloatingActionButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => ApplyLeaveScreen(user: user)),
//               ),
//               child: const Icon(Icons.add),
//               tooltip: 'Apply Leave',
//             )
//           : null,
//       bottomNavigationBar: BottomNavigation(
//         currentIndex: 2, // Leave tab
//         onTabChanged: (index) {
//           ref.read(bottomNavIndexProvider.notifier).state = index;
//           if (index == 0) Navigator.popUntil(context, (route) => route.isFirst);
//         },
//       ),
//     );
//   }
// }
