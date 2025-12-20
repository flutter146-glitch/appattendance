// lib/utils/week_month_utils.dart

import 'package:intl/intl.dart';

class WeekMonthUtils {
  static String getCurrentMonthYear() {
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }

  static int getDaysInCurrentMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  static String getWeekRange() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return "${DateFormat('d MMM').format(startOfWeek)} - ${DateFormat('d MMM yyyy').format(endOfWeek)}";
  }

  static List<String> getWeekDays() {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }
}
