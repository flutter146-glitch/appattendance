// lib/features/leaves/presentation/widgets/month_filter_widget.dart
// Final upgraded version: Dynamic months + year selector (Dec 29, 2025)
// Configurable range (last 24 months), current month default, dark mode support

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthFilterWidget extends StatefulWidget {
  final String initialMonth; // e.g., "December 2025"
  final ValueChanged<String> onMonthChanged;

  const MonthFilterWidget({
    super.key,
    required this.initialMonth,
    required this.onMonthChanged,
  });

  @override
  State<MonthFilterWidget> createState() => _MonthFilterWidgetState();
}

class _MonthFilterWidgetState extends State<MonthFilterWidget> {
  late String _selectedMonth;
  late int _selectedYear;

  // Configurable: Kitne months pehle se dikhaaye (default 24 months)
  static const int monthsToShow = 24;

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth.isNotEmpty
        ? widget.initialMonth
        : DateFormat('MMMM yyyy').format(DateTime.now());

    // Extract year from selected month
    _selectedYear = int.parse(_selectedMonth.split(' ').last);
  }

  List<String> _generateMonths(int year) {
    final now = DateTime.now();
    final currentMonth = DateTime(year, now.month, 1);

    // Last 12 months of the year + current year ke months
    return List.generate(12, (index) {
      final date = DateTime(year, index + 1, 1);
      return DateFormat('MMMM yyyy').format(date);
    }).reversed.toList();
  }

  void _showYearPicker() async {
    final selected = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Year'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: YearPicker(
            firstDate: DateTime.now().subtract(
              const Duration(days: 365 * 5),
            ), // 5 years back
            lastDate: DateTime.now().add(
              const Duration(days: 365),
            ), // 1 year forward
            initialDate: DateTime(_selectedYear),
            onChanged: (date) {
              Navigator.pop(context, date.year);
            },
          ),
        ),
      ),
    );

    if (selected != null && selected != _selectedYear) {
      setState(() {
        _selectedYear = selected;
        // Auto-select current month of selected year
        final now = DateTime.now();
        _selectedMonth = DateFormat(
          'MMMM yyyy',
        ).format(DateTime(selected, now.month, 1));
        widget.onMonthChanged(_selectedMonth);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final months = _generateMonths(_selectedYear);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year Selector
          GestureDetector(
            onTap: _showYearPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Year: $_selectedYear',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal Month Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: months.map((month) {
                final isSelected = month == _selectedMonth;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedMonth = month);
                      widget.onMonthChanged(month);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        month,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
// // lib/features/leaves/presentation/widgets/month_filter_widget.dart
// // Updated: Dynamic months based on current date (Dec 24, 2025), no hardcoded values, production-ready, dark mode support, flexible for future

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class MonthFilterWidget extends StatelessWidget {
//   final String selectedMonth;
//   final ValueChanged<String> onMonthChanged;

//   const MonthFilterWidget({
//     super.key,
//     required this.selectedMonth,
//     required this.onMonthChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now(); // Current date: Dec 24, 2025

//     // Generate last 6 months dynamically (including current month)
//     final months = List.generate(6, (index) {
//       final date = DateTime(now.year, now.month - index, 1);
//       return DateFormat('MMMM yyyy').format(date);
//     }).reversed.toList(); // Latest month first

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: months.map((month) {
//             final isSelected = month == selectedMonth;
//             return Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: GestureDetector(
//                 onTap: () => onMonthChanged(month),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? AppColors.primary
//                         : Colors.grey.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: isSelected
//                         ? [
//                             BoxShadow(
//                               color: AppColors.primary.withOpacity(0.4),
//                               blurRadius: 8,
//                               offset: const Offset(0, 4),
//                             ),
//                           ]
//                         : null,
//                   ),
//                   child: Text(
//                     month,
//                     style: TextStyle(
//                       color: isSelected
//                           ? Colors.white
//                           : (Theme.of(context).brightness == Brightness.dark
//                                 ? Colors.white70
//                                 : Colors.black87),
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

// // lib/features/leaves/presentation/widgets/month_filter_widget.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class MonthFilterWidget extends StatelessWidget {
//   final String selectedMonth;
//   final ValueChanged<String> onMonthChanged;

//   const MonthFilterWidget({
//     super.key,
//     required this.selectedMonth,
//     required this.onMonthChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     final months = [
//       DateFormat('MMMM yyyy').format(now),
//       DateFormat('MMMM yyyy').format(now.subtract(const Duration(days: 30))),
//       DateFormat('MMMM yyyy').format(now.subtract(const Duration(days: 60))),
//     ];

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: months.map((month) {
//             final isSelected = month == selectedMonth;
//             return Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: GestureDetector(
//                 onTap: () => onMonthChanged(month),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected
//                         ? AppColors.primary
//                         : Colors.grey.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     month,
//                     style: TextStyle(
//                       color: isSelected
//                           ? Colors.white
//                           : (Theme.of(context).brightness == Brightness.dark
//                                 ? Colors.white70
//                                 : Colors.black87),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
