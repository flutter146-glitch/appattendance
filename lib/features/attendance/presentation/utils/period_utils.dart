// lib/features/attendance/presentation/utils/period_utils.dart
// Utility for period selector UI

import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:flutter/material.dart';

class PeriodUtils {
  // Get list of dates for period selector (last 1 year)
  static List<DateTime> getDatesForPeriodSelector() {
    final List<DateTime> dates = [];
    final now = DateTime.now();

    // Add dates for last 365 days
    for (int i = 0; i < 365; i++) {
      dates.add(now.subtract(Duration(days: i)));
    }

    return dates;
  }

  // Get list of weeks for weekly selector
  static List<DateTimeRange> getWeeksForLastYear() {
    final List<DateTimeRange> weeks = [];
    final now = DateTime.now();

    for (int i = 0; i < 52; i++) {
      // 52 weeks in a year
      final end = now.subtract(Duration(days: i * 7));
      final start = end.subtract(const Duration(days: 6));
      weeks.add(DateTimeRange(start: start, end: end));
    }

    return weeks;
  }

  // Get list of months for monthly selector
  static List<DateTime> getMonthsForLastYear() {
    final List<DateTime> months = [];
    final now = DateTime.now();

    for (int i = 0; i < 12; i++) {
      months.add(DateTime(now.year, now.month - i, 1));
    }

    return months;
  }

  // Get list of quarters for quarterly selector
  static List<DateTimeRange> getQuartersForLastYear() {
    final List<DateTimeRange> quarters = [];
    final now = DateTime.now();

    for (int i = 0; i < 4; i++) {
      // Last 4 quarters
      final quarterMonth = ((now.month - 1) ~/ 3 - i) * 3 + 1;
      final year = now.year + (quarterMonth <= 0 ? -1 : 0);
      final adjustedMonth = quarterMonth <= 0
          ? quarterMonth + 12
          : quarterMonth;

      final start = DateTime(year, adjustedMonth, 1);
      final end = DateTime(year, adjustedMonth + 3, 0);
      quarters.add(DateTimeRange(start: start, end: end));
    }

    return quarters;
  }

  // Format date for display
  static String formatDateForDisplay(DateTime date, AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.daily:
        return '${_formatDay(date.day)} ${_getMonthName(date.month)} ${date.year}';
      case AnalyticsPeriod.weekly:
        final start = date.subtract(const Duration(days: 6));
        return '${_formatDay(start.day)} ${_getMonthName(start.month)} - ${_formatDay(date.day)} ${_getMonthName(date.month)} ${date.year}';
      case AnalyticsPeriod.monthly:
        return '${_getMonthName(date.month)} ${date.year}';
      case AnalyticsPeriod.quarterly:
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return 'Q$quarter ${date.year}';
    }
  }

  static String _formatDay(int day) => day.toString().padLeft(2, '0');

  static String _getMonthName(int month) {
    const monthNames = [
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
    return monthNames[month - 1];
  }
}
