// lib/features/leaves/presentation/screens/leave_screen.dart
// Final upgraded version: Riverpod authAsync.when + freezed UserModel + privileges safe
// Dec 30, 2025 - Production-ready, no raw Map, no string role check

import 'package:appattendance/core/providers/bottom_nav_providers.dart';
import 'package:appattendance/core/theme/bottom_navigation.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/leaves/presentation/screens/apply_leave_screen.dart';
import 'package:appattendance/features/leaves/presentation/screens/employee_leave_screen.dart';
import 'package:appattendance/features/leaves/presentation/screens/manager_leave_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);

    return authAsync.when(
      loading: () =>
      const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please login to view leaves',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        }

        final isManagerial = user.isManagerial;
        final canApproveReject = user.canApproveLeaves;

        final Widget body = isManagerial
            ? ManagerLeaveScreen(canApproveReject: canApproveReject)
            : const EmployeeLeaveScreen();

        final bool showFAB = !isManagerial || !user.isManagerial;

        return Scaffold(
          body: body,
          floatingActionButton: showFAB
              ? FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApplyLeaveScreen()),
            ),
            child: const Icon(Icons.add),
            tooltip: 'Apply Leave',
          )
              : null,
          bottomNavigationBar: BottomNavigation(
            currentIndex: 2, // Leave tab
            onTabChanged: (index) {
              ref.read(bottomNavIndexProvider.notifier).state = index;
              if (index == 0) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
        );
      },
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