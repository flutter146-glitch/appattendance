// lib/features/regularisation/presentation/widgets/month_filter_widget.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthFilterWidget extends StatelessWidget {
  final String selectedMonth;
  final ValueChanged<String> onMonthChanged;

  const MonthFilterWidget({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Live: only previous + current month
    final months = _getLiveMonths();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: months.map((month) {
            final isSelected = month == selectedMonth;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onMonthChanged(month),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(30),
                    border: isSelected
                        ? null
                        : Border.all(color: theme.dividerColor),
                  ),
                  child: Text(
                    month,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<String> _getLiveMonths() {
    final now = DateTime.now();
    final current = DateFormat('MMMM yyyy').format(now);
    final previous = DateFormat(
      'MMMM yyyy',
    ).format(DateTime(now.year, now.month - 1, 1));
    return [previous, current];
  }
}
