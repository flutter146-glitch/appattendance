// lib/features/regularisation/presentation/widgets/month_filter_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthFilterWidget extends StatelessWidget {
  final String selectedMonthYear;
  final ValueChanged<String> onMonthSelected;
  final List<String>
  availableMonths; // Dynamic list (API se aayega future mein)

  const MonthFilterWidget({
    super.key,
    required this.selectedMonthYear,
    required this.onMonthSelected,
    this.availableMonths = const [], // Default empty, future mein API se fill
  });

  @override
  Widget build(BuildContext context) {
    // Agar availableMonths empty hai toh default previous + current month use karo (fallback)
    final months = availableMonths.isEmpty
        ? _getDefaultMonths()
        : availableMonths;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: months.map((month) {
            final isSelected = month == selectedMonthYear;
            return Padding(
              padding: EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => onMonthSelected(month),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Icon(Icons.check_circle, color: Colors.white, size: 18),
                      SizedBox(width: isSelected ? 8 : 0),
                      Text(
                        month,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Fallback: previous + current month (API nahi aaya toh yeh use hoga)
  List<String> _getDefaultMonths() {
    final now = DateTime.now();
    final current = DateFormat('MMM yyyy').format(now);
    final previous = DateFormat(
      'MMM yyyy',
    ).format(DateTime(now.year, now.month - 1, 1));
    return [previous, current];
  }
}

// // lib/features/regularisation/presentation/widgets/month_filter_widget.dart

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
//     // Dynamic previous + current month (no hardcode)
//     final currentDate = DateTime.now();
//     final currentMonth = DateFormat('MMM yyyy').format(currentDate);
//     final previousMonth = DateFormat(
//       'MMM yyyy',
//     ).format(DateTime(currentDate.year, currentDate.month - 1, 1));

//     final months = [previousMonth, currentMonth];

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: months.map((month) {
//           final isSelected = month == selectedMonth;
//           return GestureDetector(
//             onTap: () => onMonthChanged(month),
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: isSelected
//                     ? [
//                         BoxShadow(
//                           color: Colors.blue.withOpacity(0.4),
//                           blurRadius: 8,
//                         ),
//                       ]
//                     : null,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (isSelected)
//                     Icon(Icons.check_circle, color: Colors.white, size: 18),
//                   SizedBox(width: isSelected ? 8 : 0),
//                   Text(
//                     month,
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black87,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
