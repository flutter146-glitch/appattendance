// lib/features/dashboard/presentation/widgets/employeewidgets/check_in_out_widget.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CheckInOutWidget extends StatelessWidget {
  final bool hasCheckedInToday;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final bool isInGeofence;

  const CheckInOutWidget({
    super.key,
    required this.hasCheckedInToday,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.isInGeofence,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 200,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      // color: isDark ? Colors.grey.shade800 : Colors.white,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            // Geofence Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isInGeofence ? Icons.location_on : Icons.location_off,
                  color: isInGeofence ? AppColors.primaryDark : Colors.red,
                  size: 28,
                ),
                SizedBox(width: 12),
                Text(
                  isInGeofence
                      ? "You are in range of Nutantek"
                      : "You Are Not In Range Of Nutantek",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isInGeofence ? AppColors.primaryDark : Colors.red,
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),

            // Check-in / Check-out Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isInGeofence && !hasCheckedInToday
                        ? onCheckIn
                        : null,
                    icon: Icon(Icons.login, size: 20),
                    label: Text(
                      "CHECK IN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.limeAccent,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isInGeofence && hasCheckedInToday
                        ? onCheckOut
                        : null,
                    icon: Icon(Icons.logout, size: 20),
                    label: Text(
                      "CHECK OUT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
