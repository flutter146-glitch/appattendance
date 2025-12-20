// lib/utils/attendance_period_utils.dart

import 'package:appattendance/features/dashboard/presentation/widgets/common/AttendancePeriodStatsWidget.dart';
import 'package:intl/intl.dart';

class AttendancePeriodUtils {
  static DateTime getPeriodStart(AttendancePeriod period) {
    final now = DateTime.now();
    switch (period) {
      case AttendancePeriod.daily:
        return DateTime(now.year, now.month, now.day);
      case AttendancePeriod.weekly:
        return now.subtract(Duration(days: now.weekday - 1));
      case AttendancePeriod.monthly:
        return DateTime(now.year, now.month, 1);
      case AttendancePeriod.quarterly:
        final quarterStartMonth = ((now.month - 1) ~/ 3) * 3 + 1;
        return DateTime(now.year, quarterStartMonth, 1);
    }
  }

  static DateTime getPeriodEnd(AttendancePeriod period) {
    final now = DateTime.now();
    switch (period) {
      case AttendancePeriod.daily:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case AttendancePeriod.weekly:
        return now.add(Duration(days: 7 - now.weekday));
      case AttendancePeriod.monthly:
        return DateTime(now.year, now.month + 1, 0);
      case AttendancePeriod.quarterly:
        final quarterStartMonth = ((now.month - 1) ~/ 3) * 3 + 1;
        final quarterEndMonth = quarterStartMonth + 2;
        return DateTime(now.year, quarterEndMonth + 1, 0);
    }
  }

  static String getPeriodLabel(AttendancePeriod period) {
    switch (period) {
      case AttendancePeriod.daily:
        return "Today";
      case AttendancePeriod.weekly:
        return "This Week";
      case AttendancePeriod.monthly:
        return DateFormat('MMMM yyyy').format(DateTime.now());
      case AttendancePeriod.quarterly:
        final quarter = ((DateTime.now().month - 1) ~/ 3) + 1;
        return "Q$quarter ${DateTime.now().year}";
    }
  }
}
