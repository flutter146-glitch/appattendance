// lib/core/extensions/date_time_extension.dart
// Ya attendance_model.dart ke end mein add kar do
import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  /// Checks if two DateTime objects are on the same calendar date (ignores time)
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Checks if this date is today
  bool get isToday {
    final now = DateTime.now();
    return isSameDate(now);
  }

  /// Formatted string for display (e.g., "09 Jan 2026")
  String get formattedDate => DateFormat('dd MMM yyyy').format(this);

  /// Day name (e.g., "Thursday")
  String get dayName => DateFormat('EEEE').format(this);
}
