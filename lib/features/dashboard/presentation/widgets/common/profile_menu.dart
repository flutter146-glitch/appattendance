// lib/features/dashboard/presentation/widgets/common/profile_menu.dart

import 'package:flutter/material.dart';
import 'package:appattendance/core/utils/app_colors.dart';

void showEmployeeProfileMenu(BuildContext context, Map<String, dynamic> user) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Profile Header
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.blue.shade900, Colors.blue.shade800]
                      : [Colors.blue.shade600, Colors.blue.shade500],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['emp_name'] ?? 'Employee',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user['emp_email'] ?? '',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ID: ${user['emp_id'] ?? ''}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _menuSection("Attendance", isDark),
                  _menuItem(
                    context,
                    Icons.history,
                    "Attendance History",
                    "View past records",
                    Colors.purple,
                    isDark,
                  ),
                  _menuItem(
                    context,
                    Icons.location_on_outlined,
                    "Setup Geofence",
                    "Configure locations",
                    Colors.blue,
                    isDark,
                  ),

                  _menuSection("Communication", isDark),
                  _menuItem(
                    context,
                    Icons.campaign,
                    "Notices",
                    "Company announcements",
                    Colors.orange,
                    isDark,
                  ),
                  _menuItem(
                    context,
                    Icons.report_problem,
                    "Submit Grievance",
                    "Report concerns",
                    Colors.red,
                    isDark,
                  ),

                  _menuSection("Support & Settings", isDark),
                  _menuItem(
                    context,
                    Icons.help_outline,
                    "Help & Support",
                    "FAQs and support",
                    Colors.teal,
                    isDark,
                  ),
                  _menuItem(
                    context,
                    Icons.settings_outlined,
                    "Settings",
                    "App preferences",
                    Colors.grey,
                    isDark,
                  ),
                  _menuItem(
                    context,
                    Icons.info_outline,
                    "About App",
                    "Version 1.0.0",
                    Colors.indigo,
                    isDark,
                  ),

                  SizedBox(height: 30),
                  // Logout
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Logout logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 12),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _menuSection(String title, bool isDark) {
  return Padding(
    padding: EdgeInsets.only(top: 20, bottom: 10, left: 8),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        letterSpacing: 1.2,
      ),
    ),
  );
}

Widget _menuItem(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
  Color color,
  bool isDark,
) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 6),
    elevation: 4,
    color: isDark ? Colors.grey.shade800 : Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        // Navigation logic
      },
    ),
  );
}
