// lib/features/dashboard/presentation/screens/dashboard_screen.dart

import 'dart:async';

import 'package:appattendance/core/providers/bottom_nav_providers.dart';
import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/theme/bottom_navigation.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/attendance/domain/models/attendance_model.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/dashboard/presentation/screens/dashboard_imports.dart';
import 'package:appattendance/features/leaves/presentation/screens/leave_screen.dart';
import 'package:appattendance/features/projects/presentation/widgets/projectwidgets/mapped_projects_widget.dart';
import 'package:appattendance/features/regularisation/presentation/screens/regularisation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final viewMode = ref.watch(viewModeProvider);
    final userAsync = ref.watch(authProvider);
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: dashboardAsync.when(
          data: (state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome${state.user?.isManagerial == true ? '' : ' back'},",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                state.user?.name ?? 'User',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                state.user?.department ?? '',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          loading: () =>
              const Text('Loading...', style: TextStyle(color: Colors.white)),
          error: (_, __) =>
              const Text('Error', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          dashboardAsync.when(
            data: (state) => state.user?.isManagerial == true
                ? const SizedBox.shrink()
                : IconButton(
                    icon: Icon(
                      true
                          ? Icons.location_on
                          : Icons.location_off, // Replace with real geofence
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Toggle geofence if needed
                    },
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
              const Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    "3",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
          ),
        ],
      ),
      drawer: dashboardAsync.when(
        data: (state) => AppDrawer(user: state.user),
        loading: () =>
            const Drawer(child: Center(child: CircularProgressIndicator())),
        error: (_, __) =>
            const Drawer(child: Center(child: Text('Error loading user'))),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.dashboard(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
            child: dashboardAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $err'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(dashboardProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (state) {
                final user = state.user;
                if (user == null) {
                  return const Center(child: Text('User not found'));
                }

                final isManagerial = user.isManagerial;
                final effectiveIsManager =
                    isManagerial && viewMode == ViewMode.manager;

                final hasCheckedInToday = state.todayAttendance.any(
                  (a) => a.isCheckIn,
                );
                final isInGeofence =
                    true; // Replace with real geofence provider later

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Live Time & Date Card
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat(
                                    'EEEE, d MMMM yyyy',
                                  ).format(DateTime.now()),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _currentTime,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan.shade400.withOpacity(0.3),
                                    Colors.blue.shade400.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                user.displayRole,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Employee: Check-in / Check-out
                      if (!effectiveIsManager)
                        CheckInOutWidget(
                          // hasCheckedInToday: hasCheckedInToday,
                          // isInGeofence: isInGeofence,
                        ),

                      // Common Sections
                      PresentDashboardCardSection(),
                      if (!effectiveIsManager)
                        const AttendanceBreakdownSection(),
                      // Manager-specific
                      if (effectiveIsManager) ...[
                        MetricsCounter(),

                        // ManagerDashboardContent(),
                      ],

                      // Projects (for both)
                      const MappedProjectsWidget(),

                      if (effectiveIsManager) ManagerQuickActions(user: user),
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTabChanged: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;

          if (index != 0) {
            final screens = [
              null,
              RegularisationScreen(),
              LeaveScreen(),
              // TimesheetScreen(),
            ];
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => screens[index]!),
            );
          }
        },
      ),
    );
  }
}



/**************************************************************************
 * 
 *         vainyala code
 * 
 ***************************************************************************/



// // lib/features/dashboard/presentation/screens/dashboard_screen.dart
// // Final production-ready Dashboard Screen (December 29, 2025)
// // Uses DashboardNotifier + projectProvider for real data
// // Role-based UI + pull-to-refresh + all widgets integrated

// // lib/features/dashboard/presentation/screens/dashboard_screen.dart

// import 'package:appattendance/core/providers/bottom_nav_providers.dart';
// import 'package:appattendance/core/providers/view_mode_provider.dart';
// import 'package:appattendance/core/theme/app_gradients.dart';
// import 'package:appattendance/core/theme/bottom_navigation.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/AttendancePeriodStatsWidget.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/app_drawer.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/attendance_breakdown_section.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/attendance_calendar_widget.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/metrics_counter.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/common/present_dashboard_card_section.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/employeewidgets/check_in_out.dart';
// import 'package:appattendance/features/dashboard/presentation/widgets/managerwidgets/manager_quick_actions.dart';
// import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
// import 'package:appattendance/features/projects/presentation/widgets/projectwidgets/mapped_projects_widget.dart';
// import 'package:appattendance/features/regularisation/presentation/screens/regularisation_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// import '../../data/dashboard_repository.dart';
// import '../widgets/common/stored_data_widget.dart';
// import '../widgets/common/working_hours_section.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authProvider);
//     final dashboardAsync = ref.watch(dashboardProvider);
//     final currentIndex = ref.watch(bottomNavIndexProvider);
//     final viewMode = ref.watch(viewModeProvider);

//     // Auto logout if no user
//     if (authState.value == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacementNamed(context, '/login');
//       });
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final user = authState.value!;
//     debugPrint(" DashboardScreen user  : $user");

//     final isManagerial = user.isManagerial;
//     final effectiveIsManager =
//         isManagerial && viewMode == ViewMode.manager;

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Builder(
//           builder: (ctx) => IconButton(
//             icon: CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.white.withOpacity(0.2),
//               child: const Icon(Icons.person, color: Colors.white, size: 24),
//             ),
//             onPressed: () => Scaffold.of(ctx).openDrawer(),
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome${effectiveIsManager ? '' : ' back'},",
//               style: const TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//             Text(
//               user.shortName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               user.department ?? user.displayRole,
//               style: const TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//           ],
//         ),
//         actions: [
//           if (!effectiveIsManager)
//             IconButton(
//               icon: const Icon(Icons.location_on, color: Colors.white),
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Geofence enabled")),
//                 );
//               },
//             ),
//           IconButton(
//             icon: const Icon(Icons.notifications, color: Colors.white),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {
//               ref.read(dashboardProvider.notifier).refresh();
//               ref.read(mappedProjectProvider.notifier).loadMappedProjects();
//             },
//           ),
//         ],
//       ),
//       drawer: AppDrawer(user: user),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: AppGradients.dashboard(
//             Theme.of(context).brightness == Brightness.dark,
//           ),
//         ),
//         child: SafeArea(
//           child: dashboardAsync.when(
//             loading: () =>
//             const Center(child: CircularProgressIndicator()),

//             error: (err, _) =>
//                 Center(child: Text("Error loading dashboard: $err")),

//             data: (state) {
//               final analytics = state.analyticsData;
//               final workingHours = state.workingHoursData;

//               final dailyAvg = workingHours['dailyAvg'] ?? 0.0;
//               final monthlyAvg = workingHours['monthlyAvg'] ?? 0.0;

//               final present = analytics['present'] ?? 0;
//               final leave = analytics['leave'] ?? 0;
//               final absent = analytics['absent'] ?? 0;
//               final onTime = analytics['on_time'] ?? 0;
//               final late = analytics['late'] ?? 0;

//               return RefreshIndicator(
//                 onRefresh: () async {
//                   await ref
//                       .read(dashboardProvider.notifier)
//                       .refresh();
//                 },
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     children: [
//                       Card(
//                         color: Colors.transparent,
//                         elevation: 0,
//                         child: Padding(
//                           padding: const EdgeInsets.all(24),
//                           child: Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     DateFormat(
//                                       'EEEE, d MMMM yyyy',
//                                     ).format(DateTime.now()),
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     DateFormat('HH:mm:ss')
//                                         .format(DateTime.now()),
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 user.displayRole,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       if (!effectiveIsManager)
//                         CheckInOutWidget(
//                           hasCheckedInToday:
//                           state.hasCheckedInToday,
//                           isInGeofence: true,
//                         ),

//                       const SizedBox(height: 20),
//                       const PresentDashboardCardSection(),
//                       const SizedBox(height: 20),
//                       //AttendanceBreakdownSection(),
//                       const SizedBox(height: 20),
//                       WorkingHoursSection(
//                         dailyAvg: dailyAvg,
//                         monthlyAvg: monthlyAvg,
//                       ),
//                       const SizedBox(height: 20),
//                       const AttendanceCalendarWidget(),
//                       const SizedBox(height: 20),
//                       const AttendancePeriodStatsWidget(
//                         period: AttendancePeriod.quarterly,
//                       ),
//                       const SizedBox(height: 20),
//                       if (effectiveIsManager)
//                         MetricsCounter(),

//                      // const MappedProjectsWidget(),
//                       const SizedBox(height: 20),

// // ✅ Add this to show all stored data
//                       StoredDataWidget(
//                         allAttendance: state.allAttendance,
//                         allProjects: state.allProjects,
//                         allRegularization: state.allRegularization,
//                       ),
//                       if (effectiveIsManager)
//                         ManagerQuickActions(user: user),



//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigation(
//         currentIndex: currentIndex,
//         onTabChanged: (index) {
//           ref.read(bottomNavIndexProvider.notifier).state = index;
//           if (index != 0) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Feature coming soon")),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
