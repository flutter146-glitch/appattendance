// lib/features/dashboard/presentation/widgets/common/date_time_utils.dart

import 'package:intl/intl.dart';

class DateTimeUtils {
  static const List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String formatDateTime(DateTime dateTime) {
    return '${_days[dateTime.weekday - 1]} ${_months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  static String formatTimeOnly(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatFullTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  static String formatMonthYear(DateTime dateTime) {
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  static String formatDay(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime);
  }
}
