// lib/features/attendance/presentation/widgets/period_selector_widget.dart
// PRODUCTION-READY - 1-YEAR LIMITED + CONTEXTUAL CALENDARS
// Exact UX like your shared AttendanceApp code: chips + modal pickers + quick last options

import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PeriodSelectorWidget extends ConsumerWidget {
  const PeriodSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPeriod = ref.watch(analyticsPeriodProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    final periods = ['daily', 'weekly', 'monthly', 'quarterly'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.grey.shade800 : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: periods.map((period) {
          final isSelected = currentPeriod.name == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => _showContextualPicker(context, ref, period),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue
                      : (isDark ? Colors.grey.shade700 : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : (isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      period[0].toUpperCase() + period.substring(1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Show contextual picker based on selected period
  void _showContextualPicker(
    BuildContext context,
    WidgetRef ref,
    String period,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (period) {
      case 'daily':
        _showDatePicker(context, ref, isDark);
        break;
      case 'weekly':
        _showWeekPicker(context, ref, isDark);
        break;
      case 'monthly':
        _showMonthPicker(context, ref, isDark);
        break;
      case 'quarterly':
        _showQuarterPicker(context, ref, isDark);
        break;
    }
  }

  // Daily: Simple date picker (last 1 year only)
  void _showDatePicker(BuildContext context, WidgetRef ref, bool isDark) {
    final minDate = DateTime.now().subtract(const Duration(days: 365));
    final maxDate = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider),
      firstDate: minDate,
      lastDate: maxDate,
      builder: (context, child) => Theme(
        data: isDark
            ? Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  surface: Colors.grey.shade900,
                  onSurface: Colors.white,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
              )
            : Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
              ),
        child: child!,
      ),
    ).then((picked) {
      if (picked != null) {
        ref.read(selectedDateProvider.notifier).state = picked;
        ref.read(analyticsProvider.notifier).refresh();
      }
    });
  }

  // Weekly: Quick last 4 weeks list + week picker
  void _showWeekPicker(BuildContext context, WidgetRef ref, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SELECT WEEK',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Quick last 4 weeks
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LAST 4 WEEKS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(4, (i) {
                      final weekStart = DateTime.now().subtract(
                        Duration(days: (i * 7) + DateTime.now().weekday - 1),
                      );
                      final isCurrent = i == 0;

                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedDateProvider.notifier).state =
                              weekStart;
                          ref.read(analyticsProvider.notifier).refresh();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? Colors.blue.withOpacity(0.1)
                                : (isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCurrent
                                  ? Colors.blue
                                  : (isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                i == 0 ? 'THIS WEEK' : '${i}W AGO',
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.blue
                                      : (isDark
                                            ? Colors.white70
                                            : Colors.black87),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${DateFormat('dd MMM').format(weekStart)} - ${DateFormat('dd MMM').format(weekStart.add(const Duration(days: 6)))}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Monthly: Quick last 3 months + month picker
  void _showMonthPicker(BuildContext context, WidgetRef ref, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SELECT MONTH',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Quick last 3 months
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LAST 3 MONTHS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(3, (i) {
                      final monthDate = DateTime(
                        DateTime.now().year,
                        DateTime.now().month - i,
                      );
                      final isCurrent = i == 0;

                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedDateProvider.notifier).state =
                              monthDate;
                          ref.read(analyticsProvider.notifier).refresh();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? Colors.blue.withOpacity(0.1)
                                : (isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCurrent
                                  ? Colors.blue
                                  : (isDark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                i == 0 ? 'THIS MONTH' : '${i}M AGO',
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.blue
                                      : (isDark
                                            ? Colors.white70
                                            : Colors.black87),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                DateFormat('MMMM yyyy').format(monthDate),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quarterly: Custom quarter picker with year navigation
  void _showQuarterPicker(BuildContext context, WidgetRef ref, bool isDark) {
    int currentYear = DateTime.now().year;
    final minYear = DateTime.now().subtract(const Duration(days: 365)).year;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Select Qrtly'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Year navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_left),
                  //   onPressed: currentYear > minYear
                  //       ? () => setDialogState(() => currentYear--)
                  //       : null,
                  // ),
                  // Text(
                  //   '$currentYear',
                  //   style: const TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_right),
                  //   onPressed: () => setDialogState(() => currentYear++),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              // Quarter buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(4, (i) {
                  final quarter = i + 1;
                  final startMonth = (quarter - 1) * 3 + 1;
                  final quarterStart = DateTime(currentYear, startMonth, 1);
                  final quarterEnd = DateTime(
                    currentYear,
                    startMonth + 2,
                    DateTime(currentYear, startMonth + 3, 0).day,
                  );

                  // Month range string (e.g., "Jan - Mar 2026")
                  final monthRange =
                      '${DateFormat('MMM').format(quarterStart)} - ${DateFormat('MMM').format(quarterEnd)} $currentYear';

                  final isCurrentQuarter =
                      currentYear == DateTime.now().year &&
                      quarter == ((DateTime.now().month - 1) ~/ 3 + 1);

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedDateProvider.notifier).state =
                          quarterStart;
                      ref.read(analyticsProvider.notifier).refresh();
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentQuarter
                            ? Colors.blue.withOpacity(0.15)
                            : (isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrentQuarter
                              ? Colors.blue
                              : (isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade300),
                          width: 1.5,
                        ),
                        boxShadow: isCurrentQuarter
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.25),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Q$quarter $currentYear',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isCurrentQuarter
                                  ? Colors.blue
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            monthRange,
                            style: TextStyle(
                              fontSize: 12,
                              color: isCurrentQuarter
                                  ? Colors.blue.withOpacity(0.8)
                                  : (isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600),
                            ),
                          ),
                          if (isCurrentQuarter) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.blue,
                                size: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
