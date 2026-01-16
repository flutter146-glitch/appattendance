// lib/features/dashboard/presentation/widgets/common/app_drawer.dart

import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_model_import.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  final UserModel? user;

  const AppDrawer({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isManagerial = user?.isManagerial ?? false;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900.withOpacity(0.95),
              Colors.purple.shade800.withOpacity(0.9),
              Colors.deepPurple.shade900.withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with Avatar & User Info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      // Avatar with glow
                      Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.cyan.shade400.withOpacity(0.8),
                                  Colors.blue.shade400.withOpacity(0.8),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyan.shade400.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: 5,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 3,
                                ),
                                //   image: DecorationImage(
                                //     image: NetworkImage(
                                //       user?.avatarUrl ??
                                //           'https://ui-avatars.com/api/?name=User',
                                //     ),
                                //     fit: BoxFit.cover,
                                //   ),
                              ),

                              child: const Center(
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // Online dot
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.green.shade400,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.shade400.withOpacity(
                                      0.8,
                                    ),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        (user?.shortName ?? 'User').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.empId ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.department ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isManagerial
                              ? Colors.green.shade600
                              : Colors.orange.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isManagerial ? "MANAGER" : "EMPLOYEE",
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

                // View Mode Switch (only for managerial roles)
                if (isManagerial)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.swap_horiz_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "View Mode",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value:
                                ref.watch(viewModeProvider) ==
                                ViewMode.employee,
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.orange,
                            onChanged: (value) {
                              final newMode = value
                                  ? ViewMode.employee
                                  : ViewMode.manager;
                              ref.read(viewModeProvider.notifier).state =
                                  newMode;

                              // IMPORTANT: Toggle change pe dashboard refresh
                              ref.invalidate(dashboardProvider);
                            },
                          ),

                          // Switch(
                          //   value:
                          //       ref.watch(viewModeProvider) ==
                          //       ViewMode.employee,
                          //   activeColor: Colors.green,
                          //   inactiveThumbColor: Colors.orange,
                          //   onChanged: (value) {
                          //     ref.read(viewModeProvider.notifier).state = value
                          //         ? ViewMode.employee
                          //         : ViewMode.manager;
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),

                // Menu Section
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade900.withOpacity(0.9)
                        : Colors.white.withOpacity(0.95),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan.shade400,
                                    Colors.blue.shade400,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "NAVIGATION",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.cyan.shade300
                                    : Colors.blue.shade800,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Menu Items
                      _menuItem(
                        Icons.dashboard_rounded,
                        "DASHBOARD",
                        Colors.cyan.shade400,
                        () => Navigator.pop(context),
                      ),
                      _menuItem(
                        Icons.calendar_today_rounded,
                        "ATTENDANCE",
                        Colors.blue.shade400,
                        () {},
                      ),
                      if (isManagerial)
                        _menuItem(
                          Icons.group_rounded,
                          "TEAM MEMBERS",
                          Colors.green.shade400,
                          () {},
                        ),
                      _menuItem(
                        Icons.settings_rounded,
                        "APP SETTING",
                        Colors.purple.shade400,
                        () {},
                      ),

                      const SizedBox(height: 30),

                      // Logout Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade600,
                                Colors.orange.shade600,
                              ],
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                // 1. Logout from auth notifier
                                await ref.read(authProvider.notifier).logout();

                                // 2. Clear view mode (optional)
                                ref.read(viewModeProvider.notifier).state =
                                    ViewMode.employee;

                                // 3. Invalidate all providers to force fresh state
                                ref.invalidate(authProvider);
                                ref.invalidate(dashboardProvider);
                                ref.invalidate(viewModeProvider);
                                // Add more providers if needed (e.g., projectProvider, etc.)

                                // 4. Navigate to login and remove all previous routes
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.logout_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    const Text(
                                      "LOGOUT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // lib/features/dashboard/presentation/widgets/common/app_drawer.dart

// import 'package:appattendance/core/providers/view_mode_provider.dart';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_notifier.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AppDrawer extends ConsumerWidget {
//   final Map<String, dynamic> user;

//   const AppDrawer({super.key, required this.user});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final role = (user['emp_role'] ?? '').toLowerCase();
//     final isManager = role.contains('manager') || role.contains('admin');

//     return Drawer(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue.shade900.withOpacity(0.95),
//               Colors.purple.shade800.withOpacity(0.9),
//               Colors.deepPurple.shade900.withOpacity(0.95),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Header
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//                   child: Column(
//                     children: [
//                       // Avatar with glow
//                       Stack(
//                         children: [
//                           Container(
//                             width: 110,
//                             height: 110,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.cyan.shade400.withOpacity(0.8),
//                                   Colors.blue.shade400.withOpacity(0.8),
//                                 ],
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.cyan.shade400.withOpacity(0.4),
//                                   blurRadius: 20,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: 5,
//                             left: 5,
//                             child: Container(
//                               width: 100,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.black.withOpacity(0.3),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.4),
//                                   width: 3,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.person_rounded,
//                                   size: 50,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Online dot
//                           Positioned(
//                             bottom: 10,
//                             right: 10,
//                             child: Container(
//                               width: 20,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade400,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.white,
//                                   width: 3,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.green.shade400.withOpacity(
//                                       0.8,
//                                     ),
//                                     blurRadius: 10,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         (user['emp_name'] ?? 'User').toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         user['emp_id'] ?? '',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         user['emp_department'] ?? '',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         user['emp_email'] ?? '',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isManager
//                               ? Colors.green.shade600
//                               : Colors.orange.shade600,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           isManager ? "MANAGER" : "EMPLOYEE",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // app_drawer.dart mein — Header ke neeche
//                 if (isManager)
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.swap_horiz_rounded,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               SizedBox(width: 12),
//                               Text(
//                                 "View Mode",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Switch(
//                             value:
//                                 ref.watch(viewModeProvider) ==
//                                 ViewMode.employee,
//                             activeColor: Colors.green,
//                             inactiveThumbColor: Colors.orange,
//                             onChanged: (value) {
//                               ref.read(viewModeProvider.notifier).state = value
//                                   ? ViewMode.employee
//                                   : ViewMode.manager;
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                 // Menu Section
//                 Container(
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? Colors.grey.shade900.withOpacity(0.9)
//                         : Colors.white.withOpacity(0.95),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 25),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 25),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.cyan.shade400,
//                                     Colors.blue.shade400,
//                                   ],
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.menu_rounded,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Text(
//                               "NAVIGATION",
//                               style: TextStyle(
//                                 color: isDark
//                                     ? Colors.cyan.shade300
//                                     : Colors.blue.shade800,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 15),

//                       // Menu Items
//                       _menuItem(
//                         Icons.dashboard_rounded,
//                         "DASHBOARD",
//                         Colors.cyan.shade400,
//                         () => Navigator.pop(context),
//                       ),
//                       _menuItem(
//                         Icons.calendar_today_rounded,
//                         "ATTENDANCE",
//                         Colors.blue.shade400,
//                         () {},
//                       ),
//                       if (isManager)
//                         _menuItem(
//                           Icons.group_rounded,
//                           "TEAM MEMBERS",
//                           Colors.green.shade400,
//                           () {},
//                         ),
//                       _menuItem(
//                         Icons.settings_rounded,
//                         "APP SETTING",
//                         Colors.purple.shade400,
//                         () {},
//                       ),

//                       SizedBox(height: 30),

//                       // Logout Button
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.red.shade600,
//                                 Colors.orange.shade600,
//                               ],
//                             ),
//                           ),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: () async {
//                                 await ref.read(authProvider.notifier).logout();

//                                 if (context.mounted) {
//                                   Navigator.pushNamedAndRemoveUntil(
//                                     context,
//                                     '/login',
//                                     (route) => false,
//                                   );
//                                 }
//                               },
//                               borderRadius: BorderRadius.circular(15),
//                               child: Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 45,
//                                       height: 45,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.2),
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Icon(
//                                         Icons.logout_rounded,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(width: 15),
//                                     Text(
//                                       "LOGOUT",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w800,
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Icon(
//                                       Icons.arrow_forward_ios_rounded,
//                                       color: Colors.white.withOpacity(0.8),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _menuItem(
//     IconData icon,
//     String title,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         gradient: LinearGradient(
//           colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
//         ),
//         border: Border.all(color: color.withOpacity(0.2), width: 1.5),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(15),
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 SizedBox(width: 15),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),
//                 Spacer(),
//                 Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // lib/features/dashboard/presentation/widgets/common/app_drawer.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';

// class AppDrawer extends StatelessWidget {
//   final Map<String, dynamic> user;
//   final VoidCallback onLogout;

//   const AppDrawer({super.key, required this.user, required this.onLogout});

//   @override
//   Widget build(BuildContext context) {
//     final isManager = (user['emp_role'] ?? '').toLowerCase() == 'manager';
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Drawer(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue.shade900.withOpacity(0.95),
//               Colors.purple.shade800.withOpacity(0.9),
//               Colors.deepPurple.shade900.withOpacity(0.95),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Header
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//                   child: Column(
//                     children: [
//                       // Avatar with glow
//                       Stack(
//                         children: [
//                           Container(
//                             width: 110,
//                             height: 110,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.cyan.shade400.withOpacity(0.8),
//                                   Colors.blue.shade400.withOpacity(0.8),
//                                 ],
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.cyan.shade400.withOpacity(0.4),
//                                   blurRadius: 20,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: 5,
//                             left: 5,
//                             child: Container(
//                               width: 100,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.black.withOpacity(0.3),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.4),
//                                   width: 3,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.person_rounded,
//                                   size: 50,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Online dot
//                           Positioned(
//                             bottom: 10,
//                             right: 10,
//                             child: Container(
//                               width: 20,
//                               height: 20,
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade400,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.white,
//                                   width: 3,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.green.shade400.withOpacity(
//                                       0.8,
//                                     ),
//                                     blurRadius: 10,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         user['emp_name'].toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         user['emp_id'],
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         user['emp_department'],
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         user['emp_email'],
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 8),

//                       Text(
//                         isManager ? "MANAGER" : "EMPLOYEE",
//                         style: TextStyle(
//                           color: Colors.cyan.shade300,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       // SizedBox(height: 15),
//                       // Badge
//                       // Container(
//                       //   padding: EdgeInsets.symmetric(
//                       //     horizontal: 20,
//                       //     vertical: 8,
//                       //   ),
//                       //   decoration: BoxDecoration(
//                       //     gradient: LinearGradient(
//                       //       colors: [
//                       //         Colors.cyan.shade400.withOpacity(0.3),
//                       //         Colors.blue.shade400.withOpacity(0.2),
//                       //       ],
//                       //     ),
//                       //     borderRadius: BorderRadius.circular(20),
//                       //     border: Border.all(
//                       //       color: Colors.white.withOpacity(0.3),
//                       //       width: 1.5,
//                       //     ),
//                       //   ),
//                       //   child: Text(
//                       //     isManager ? "MANAGER" : "EMPLOYEE",
//                       //     style: TextStyle(
//                       //       color: Colors.white,
//                       //       fontSize: 12,
//                       //       fontWeight: FontWeight.w800,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),

//                 // Menu Section
//                 Container(
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? Colors.grey.shade900.withOpacity(0.9)
//                         : Colors.white.withOpacity(0.95),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 25),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 25),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.cyan.shade400,
//                                     Colors.blue.shade400,
//                                   ],
//                                 ),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.menu_rounded,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Text(
//                               "NAVIGATION",
//                               style: TextStyle(
//                                 color: isDark
//                                     ? Colors.cyan.shade300
//                                     : Colors.blue.shade800,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 15),

//                       // Menu Items
//                       _menuItem(
//                         Icons.dashboard_rounded,
//                         "DASHBOARD",
//                         Colors.cyan.shade400,
//                         () => Navigator.pop(context),
//                       ),
//                       _menuItem(
//                         Icons.calendar_today_rounded,
//                         "ATTENDANCE",
//                         Colors.blue.shade400,
//                         () {},
//                       ),
//                       if (isManager)
//                         _menuItem(
//                           Icons.group_rounded,
//                           "TEAM MEMBERS",
//                           Colors.green.shade400,
//                           () {},
//                         ),
//                       _menuItem(
//                         Icons.settings_rounded,
//                         "APP SETTING",
//                         Colors.purple.shade400,
//                         () {},
//                       ),

//                       SizedBox(height: 20),

//                       // Logout
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.red.shade600,
//                                 Colors.orange.shade600,
//                               ],
//                             ),
//                           ),
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: onLogout,
//                               borderRadius: BorderRadius.circular(15),
//                               child: Padding(
//                                 padding: EdgeInsets.all(16),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 45,
//                                       height: 45,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.2),
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Icon(
//                                         Icons.logout_rounded,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(width: 15),
//                                     Text(
//                                       "LOGOUT",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w800,
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Icon(
//                                       Icons.arrow_forward_ios_rounded,
//                                       color: Colors.white.withOpacity(0.8),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _menuItem(
//     IconData icon,
//     String title,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         gradient: LinearGradient(
//           colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
//         ),
//         border: Border.all(color: color.withOpacity(0.2), width: 1.5),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(15),
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 SizedBox(width: 15),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),
//                 Spacer(),
//                 Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
