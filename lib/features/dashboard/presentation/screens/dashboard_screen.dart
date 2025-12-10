import 'dart:async';
import 'dart:io';
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/database/db_helper.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../core/widgets/common/custom_button.dart';
import '../../../core/widgets/common/menu_drawer.dart';
import '../../../features/auth/domain/models/user_model.dart';
import '../../attendance/presentation/screens/attendance_analytics_screen.dart';
import '../../attendance/presentation/screens/face_detection_screen.dart';
import '../../projects/presentation/screens/project_details_screen.dart';
import '../../attendance/presentation/screens/auth_verification_screen.dart';
import '../../../core/providers/role_provider.dart'; // Assuming role is managed here
import '../../../core/services/location_service.dart';
import '../../../core/services/geofencing_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/widgets/dashboard_widgets/custom_stat_row.dart';
import '../../../main.dart'; // For cameras

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _countdownTimer;
  Duration? _remainingTime;
  bool _verificationAlertShowing = false;
  UserModel? user; // Loaded from DB

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserAndInitialize();
    _setupNotificationHandler();
  }

  Future<void> _loadUserAndInitialize() async {
    final userData = await DBHelper.instance.getUser();
    if (userData != null) {
      setState(() {
        user = UserModel.fromJson(userData);
      });
      _initializeApp();
    }
  }

  void _initializeApp() {
    // Common init for both roles
    _startCountdownTimer();
    _checkPendingVerification();
    // Role-specific init if needed
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ... (Keep all methods from employee dashboard: _startCountdownTimer, _formatCountdown, _setupNotificationHandler, _handleNotificationTap, etc.)

  // Modified build to handle hybrid UI
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBody(),
          if (user!.isEmployee && _verificationAlertShowing)
            _buildVerificationBanner(), // Employee-specific
        ],
      ),
      bottomNavigationBar: _buildBottomNav(), // Hybrid bottom nav
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryBlue, AppColors.primaryBlue],
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh data based on role
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopBar(),
                _buildProfileSection(),
                if (user!.isEmployee)
                  _buildEmployeeContent()
                else
                  _buildManagerContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    // Common top bar with menu, sync, notifications
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textLight, size: 26),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.sync,
                  color: AppColors.textLight,
                  size: 26,
                ),
                onPressed: () => {}, // Sync logic
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textLight,
                  size: 26,
                ),
                onPressed: () => {}, // Notifications
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    // Common profile section
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Column(
        children: [
          CircleAvatar(radius: 50, child: Icon(Icons.person, size: 55)),
          const SizedBox(height: 5),
          Text(
            user!.name,
            style: const TextStyle(
              fontSize: 22,
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${user!.role.name} - ${user!.department}',
            style: const TextStyle(fontSize: 14, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeContent() {
    // Employee-specific UI from employee dashboard
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimeStatus(), // With check-in time and countdown
            _buildCheckInOutButtons(),
            _buildMyAttendanceSection(), // Pie chart and stats
            _buildStatsContainer(), // Daily/Monthly avg
            _buildMappedProjects(),
          ],
        ),
      ),
    );
  }

  Widget _buildManagerContent() {
    // Manager-specific UI from manager dashboard
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateTimeSectionManager(), // Live time for manager
            _buildPresentDashboardCardSection(),
            _buildMetricsCounter(),
            _buildDashboardCardsSection(),
          ],
        ),
      ),
    );
  }

  // ... (Include all employee methods: _buildDateTimeStatus, _buildCheckInOutButtons, _buildMyAttendanceSection, _buildStatsContainer, _buildMappedProjects)

  // ... (Include all manager methods: _buildDateTimeSectionManager from _buildDateTimeSection, _buildPresentDashboardCardSection from presentdashboard, _buildMetricsCounter from matrix_counter, _buildDashboardCardsSection from dashboard_cards)

  Widget _buildBottomNav() {
    // Hybrid bottom nav - same for both, but onTap navigates based on role
    return BottomNavigationBar(
      currentIndex: 0, // Dashboard is 0
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Regularisation',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.beach_access), label: 'Leave'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timesheet'),
      ],
      onTap: (index) {
        // Role-based navigation
        if (user!.isManager) {
          // Manager navigation
        } else {
          // Employee navigation
        }
      },
    );
  }
}

// // lib/features/dashboard/presentation/screens/dashboard_screen.dart
// import 'package:appattendance/core/providers/role_provider.dart';
// import 'package:appattendance/core/providers/theme_notifier.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/domain/models/user_model.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
// import 'package:appattendance/features/projects/domain/models/project_model.dart';
// import 'package:appattendance/features/projects/presentation/providers/project_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:init/init.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(roleProvider);
//     if (user == null) {
//       ref.read(authProvider.notifier).logout();
//       return const SizedBox.shrink(); // Or show loading/error
//     }

//     final dashboardState = ref.watch(dashboardProvider);
//     final projects = ref.watch(projectProvider);
//     final isDark = ref.watch(themeProvider) == ThemeMode.dark;

//     return Scaffold(
//       drawer: _buildDrawer(context, ref, user, isDark),
//       appBar: AppBar(
//         title: Text(user.isManager ? 'Manager Dashboard' : 'My Dashboard'),
//         actions: [
//           IconButton(
//             icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () => ref.read(themeProvider.notifier).toggle(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => ref.read(authProvider.notifier).logout(),
//           ),
//         ],
//       ),
//       body: dashboardState.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text('Error: $err')),
//         data: (state) {
//           return RefreshIndicator(
//             onRefresh: () =>
//                 ref.read(dashboardProvider.notifier).loadDashboard(),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Welcome, ${user.name}',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Common Attendance Section
//                     const Text(
//                       'Attendance Overview',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     _buildAttendanceCard(
//                       user.isManager ? state.teamSize : 1,
//                       user.isManager
//                           ? state.presentToday
//                           : (state.checkInTime != null ? 1 : 0),
//                       isDark,
//                     ),

//                     const SizedBox(height: 20),

//                     // Role-specific sections
//                     if (user.isEmployee)
//                       ..._buildEmployeeSpecificSections(
//                         ref,
//                         state,
//                         projects,
//                         isDark,
//                       ),
//                     if (user.isManager)
//                       ..._buildManagerSpecificSections(
//                         ref,
//                         state,
//                         projects,
//                         isDark,
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: _buildBottomNav(ref, user.isManager),
//     );
//   }

//   Widget _buildDrawer(
//     BuildContext context,
//     WidgetRef ref,
//     UserModel user,
//     bool isDark,
//   ) {
//     return Drawer(
//       child: ListView(
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text(user.name), // ← const nahi
//             accountEmail: Text(user.email), // ← const nahi
//             currentAccountPicture: CircleAvatar(
//               child: Text(user.name[0].toUpperCase()),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.dashboard),
//             title: const Text('Dashboard'),
//             onTap: () => Navigator.pop(context),
//           ),
//           ListTile(
//             leading: const Icon(Icons.people),
//             title: Text(
//               user.isManager ? 'Team' : 'Profile',
//             ), // ← yahan const nahi
//             onTap: () {
//               // Navigate
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () => ref.read(authProvider.notifier).logout(),
//           ),
//         ],
//       ),
//     );
//   }
//   // Widget _buildDrawer(
//   //   BuildContext context,
//   //   WidgetRef ref,
//   //   UserModel user,
//   //   bool isDark,
//   // ) {
//   //   return Drawer(
//   //     child: ListView(
//   //       children: [
//   //         UserAccountsDrawerHeader(
//   //           accountName: Text(user.name),
//   //           accountEmail: Text(user.email),
//   //           currentAccountPicture: const CircleAvatar(
//   //             child: Icon(Icons.person),
//   //           ),
//   //         ),
//   //         ListTile(
//   //           leading: const Icon(Icons.dashboard),
//   //           title: const Text('Dashboard'),
//   //           onTap: () => Navigator.pop(context),
//   //         ),
//   //         ListTile(
//   //           leading: const Icon(Icons.people),
//   //           title: const Text(user.isManager ? 'Team' : 'Profile'),
//   //           onTap: () {
//   //             // Navigate to team or profile
//   //           },
//   //         ),
//   //         // Add more items
//   //         const Divider(),
//   //         ListTile(
//   //           leading: const Icon(Icons.logout),
//   //           title: const Text('Logout'),
//   //           onTap: () => ref.read(authProvider.notifier).logout(),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   List<Widget> _buildEmployeeSpecificSections(
//     WidgetRef ref,
//     DashboardState state,
//     AsyncValue<List<ProjectModel>> projects,
//     bool isDark,
//   ) {
//     return [
//       const Text(
//         'Your Projects',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10),
//       projects.when(
//         data: (proj) => _buildProjectsList(proj, isDark),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Text('Error: $err'),
//       ),
//       const SizedBox(height: 20),

//       const Text(
//         'Leave Summary',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10),
//       _buildLeaveCard(isDark),
//       const SizedBox(height: 20),

//       const Text(
//         'Timesheet',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10),
//       _buildTimesheetCard(isDark),
//     ];
//   }

//   List<Widget> _buildManagerSpecificSections(
//     WidgetRef ref,
//     DashboardState state,
//     AsyncValue<List<ProjectModel>> projects,
//     bool isDark,
//   ) {
//     return [
//       const Text(
//         'Team Projects',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10),
//       projects.when(
//         data: (proj) => _buildProjectsList(proj, isDark, isManager: true),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Text('Error: $err'),
//       ),
//       const SizedBox(height: 20),

//       const Text(
//         'Team Leaves',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10),
//       _buildTeamLeaveCard(state.teamSize, isDark),
//       const SizedBox(height: 20),

//       const Text(
//         'Team Timesheets',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 10),
//       _buildTeamTimesheetCard(isDark),
//     ];
//   }

//   Widget _buildAttendanceCard(int total, int present, bool isDark) {
//     return Card(
//       color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Today\'s Attendance',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               '$present / $total Present',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             // Add more stats like late, absent, etc.
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProjectsList(
//     List<ProjectModel> projects,
//     bool isDark, {
//     bool isManager = false,
//   }) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: projects.length,
//       itemBuilder: (context, index) {
//         final project = projects[index];
//         return Card(
//           color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//           child: ListTile(
//             leading: Icon(Icons.work, color: AppColors.primary),
//             title: Text(project.name),
//             subtitle: Text('Status: ${project.status}'),
//             trailing: const Icon(Icons.arrow_forward),
//             onTap: () {
//               // Navigate to project details
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLeaveCard(bool isDark) {
//     return Card(
//       color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Leave Summary',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // Add leave data like casual, sick, etc.
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTeamLeaveCard(int teamSize, bool isDark) {
//     return Card(
//       color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Team Leaves',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text('$teamSize Team Members'),
//             // Add team leave stats
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimesheetCard(bool isDark) {
//     return Card(
//       color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Timesheet',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // Add timesheet data
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTeamTimesheetCard(bool isDark) {
//     return Card(
//       color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Team Timesheets',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             // Add team timesheet stats
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNav(WidgetRef ref, bool isManager) {
//     return BottomNavigationBar(
//       items: isManager
//           ? const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.dashboard),
//                 label: 'Dashboard',
//               ),
//               BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Team'),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.work),
//                 label: 'Projects',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.timeline),
//                 label: 'Timeline',
//               ),
//             ]
//           : const [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.dashboard),
//                 label: 'Dashboard',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.calendar_today),
//                 label: 'Leaves',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.timer),
//                 label: 'Timesheet',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.description),
//                 label: 'Regularisation',
//               ),
//             ],
//       currentIndex: 0,
//       onTap: (index) {
//         // Handle navigation based on role and index
//       },
//       selectedItemColor: AppColors.primary,
//       unselectedItemColor: Colors.grey,
//     );
//   }
// }
