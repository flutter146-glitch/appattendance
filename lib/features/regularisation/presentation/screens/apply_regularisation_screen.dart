// lib/features/regularisation/presentation/screens/apply_regularisation_screen.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ApplyRegularisationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;

  const ApplyRegularisationScreen({super.key, required this.user});

  @override
  ConsumerState<ApplyRegularisationScreen> createState() =>
      _ApplyRegularisationScreenState();
}

class _ApplyRegularisationScreenState
    extends ConsumerState<ApplyRegularisationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String _selectedType = 'Full Day';
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _regularisationTypes = [
    'Full Day',
    'Check-in Only',
    'Check-out Only',
    'Half Day',
    'Shortfall',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  // Dynamic date validation as per your rules
  bool _isDateAllowed(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    if (selected.isAfter(today)) {
      return false; // No future dates
    }

    // Rule 1: Current day
    if (selected.isAtSameMomentAs(today)) {
      // TODO: Real attendance check from API/attendance table
      // Placeholder: assume for demo (replace with actual logic)
      final hasCheckInOut = true; // Real: check if check-in & check-out exist
      final hasShortfall = true; // Real: shortfall > 0
      return hasCheckInOut && hasShortfall;
    }

    // Rule 2: Previous month
    final firstOfCurrentMonth = DateTime(now.year, now.month, 1);
    final lastOfPreviousMonth = firstOfCurrentMonth.subtract(
      const Duration(days: 1),
    );

    if (selected.month == lastOfPreviousMonth.month &&
        selected.year == lastOfPreviousMonth.year) {
      // Allowed only on last day of previous or 1st day of current
      return selected.isAtSameMomentAs(lastOfPreviousMonth) ||
          selected.isAtSameMomentAs(firstOfCurrentMonth);
    }

    // Rule 3: Current month (except current day which has extra check)
    return true;
  }

  String _getDateErrorMessage(DateTime date) {
    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Future dates are not allowed';
    }
    if (date.isAtSameMomentAs(now)) {
      return 'Current day can only be regularised after check-in/out with shortfall';
    }
    return 'This date is not allowed for regularisation';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Regularisation'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker
              const Text(
                'Date for Regularisation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 1),
                    ),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    helpText: 'Select the date you missed/were late',
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    if (_isDateAllowed(picked)) {
                      setState(() => _selectedDate = picked);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_getDateErrorMessage(picked))),
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              if (_selectedDate == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: const Text(
                    'Date is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 24),

              // Type Selection
              const Text(
                'Regularisation Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _regularisationTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _selectedType == type,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedType = type);
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: isDark
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: _selectedType == type
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Reason
              const Text(
                'Reason / Justification',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reasonController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Explain why you need regularisation...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Reason is required';
                  if (value.trim().length < 20)
                    return 'Reason must be at least 20 characters';
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a valid date'),
                        ),
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      final newRequest = RegularisationRequest(
                        empId: widget.user['emp_id'],
                        empName: widget.user['emp_name'] ?? 'Unknown',
                        designation: widget.user['emp_role'] ?? 'Employee',
                        appliedDate: DateFormat(
                          'yyyy-MM-dd',
                        ).format(DateTime.now()),
                        forDate: DateFormat(
                          'yyyy-MM-dd',
                        ).format(_selectedDate!),
                        justification: _reasonController.text.trim(),
                        status: 'pending',
                        type: _selectedType,
                        checkinTime: null,
                        checkoutTime: null,
                        shortfall: null,
                        projectNames:
                            [], // Future: load from employee projects API
                      );

                      ref
                          .read(regularisationProvider.notifier)
                          .addRequest(newRequest);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Regularisation request submitted successfully!',
                          ),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // lib/features/regularisation/presentation/screens/apply_regularisation_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class ApplyRegularisationScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> user;

//   const ApplyRegularisationScreen({super.key, required this.user});

//   @override
//   ConsumerState<ApplyRegularisationScreen> createState() =>
//       _ApplyRegularisationScreenState();
// }

// class _ApplyRegularisationScreenState
//     extends ConsumerState<ApplyRegularisationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _selectedDate;
//   String _selectedType = 'Full Day'; // Default
//   final TextEditingController _reasonController = TextEditingController();

//   // Dynamic types (future mein API se aa sakte hain)
//   final List<String> _regularisationTypes = [
//     'Full Day',
//     'Check-in Only',
//     'Check-out Only',
//     'Half Day',
//   ];

//   @override
//   void dispose() {
//     _reasonController.dispose();
//     super.dispose();
//   }

//   // Check if date is allowed as per rules
//   bool _isDateAllowed(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final selected = DateTime(date.year, date.month, date.day);

//     if (selected.isAfter(today)) {
//       return false; // Future dates not allowed
//     }

//     if (selected.isAtSameMomentAs(today)) {
//       // Current day: check-in + check-out done aur shortfall > 0
//       // TODO: Attendance API se check karo (placeholder logic)
//       // Assume current day ka data available hai
//       final hasCheckInOut = true; // Replace with real check
//       final hasShortfall = true; // Replace with real check
//       return hasCheckInOut && hasShortfall;
//     }

//     // Previous month
//     final firstOfCurrentMonth = DateTime(now.year, now.month, 1);
//     final lastOfPreviousMonth = firstOfCurrentMonth.subtract(Duration(days: 1));

//     if (selected.isBefore(firstOfCurrentMonth) &&
//         selected.isAfter(lastOfPreviousMonth.subtract(Duration(days: 1)))) {
//       // Last day of previous month ya 1st day of current month tak allowed
//       return true;
//     }

//     // Older than previous month → not allowed
//     return false;
//   }

//   String _getDateErrorMessage(DateTime date) {
//     if (date.isAfter(DateTime.now())) {
//       return 'Future dates are not allowed';
//     }
//     if (date.isAtSameMomentAs(DateTime.now())) {
//       return 'Current day can only be regularised after check-in/out with shortfall';
//     }
//     return 'This date is not allowed for regularisation';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Apply Regularisation'),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Date Picker
//               Text(
//                 'Date for Regularisation',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 12),
//               InkWell(
//                 onTap: () async {
//                   final DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now().subtract(Duration(days: 1)),
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime.now(),
//                     helpText: 'Select the date you missed/were late',
//                     builder: (context, child) {
//                       return Theme(
//                         data: Theme.of(context).copyWith(
//                           colorScheme: ColorScheme.light(
//                             primary: AppColors.primary,
//                           ),
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
//                   if (picked != null && _isDateAllowed(picked)) {
//                     setState(() => _selectedDate = picked);
//                   } else if (picked != null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(_getDateErrorMessage(picked))),
//                     );
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey[400]!),
//                     borderRadius: BorderRadius.circular(12),
//                     color: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.calendar_today, color: AppColors.primary),
//                       SizedBox(width: 12),
//                       Text(
//                         _selectedDate == null
//                             ? 'Select Date'
//                             : DateFormat('dd/MM/yyyy').format(_selectedDate!),
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Spacer(),
//                       Icon(Icons.arrow_drop_down),
//                     ],
//                   ),
//                 ),
//               ),
//               if (_selectedDate == null)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8),
//                   child: Text(
//                     'Date is required',
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),

//               SizedBox(height: 24),

//               // Type Selection (dynamic list)
//               Text(
//                 'Regularisation Type',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 12),
//               Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: _regularisationTypes.map((type) {
//                   return ChoiceChip(
//                     label: Text(type),
//                     selected: _selectedType == type,
//                     onSelected: (selected) {
//                       if (selected) setState(() => _selectedType = type);
//                     },
//                     selectedColor: AppColors.primary,
//                     backgroundColor: isDark
//                         ? Colors.grey.shade700
//                         : Colors.grey.shade200,
//                     labelStyle: TextStyle(
//                       color: _selectedType == type
//                           ? Colors.white
//                           : (isDark ? Colors.white70 : Colors.black87),
//                     ),
//                   );
//                 }).toList(),
//               ),

//               SizedBox(height: 24),

//               // Reason
//               Text(
//                 'Reason / Justification',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 12),
//               TextFormField(
//                 controller: _reasonController,
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   hintText: 'Explain why you need regularisation...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: AppColors.primary, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty)
//                     return 'Reason is required';
//                   if (value.trim().length < 20)
//                     return 'Reason must be at least 20 characters';
//                   return null;
//                 },
//               ),

//               SizedBox(height: 32),

//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_selectedDate == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Please select a valid date')),
//                       );
//                       return;
//                     }
//                     if (_formKey.currentState!.validate()) {
//                       final newRequest = RegularisationRequest(
//                         empId: widget.user['emp_id'],
//                         empName: widget.user['emp_name'] ?? 'Unknown',
//                         designation: widget.user['emp_role'] ?? 'Employee',
//                         appliedDate: DateFormat(
//                           'yyyy-MM-dd',
//                         ).format(DateTime.now()),
//                         forDate: DateFormat(
//                           'yyyy-MM-dd',
//                         ).format(_selectedDate!),
//                         justification: _reasonController.text.trim(),
//                         status: 'pending',
//                         type: _selectedType,
//                         checkinTime: null,
//                         checkoutTime: null,
//                         shortfall: null,
//                         projectNames: [], // Future mein load from API
//                       );

//                       ref
//                           .read(regularisationProvider.notifier)
//                           .addRequest(newRequest);

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Regularisation request submitted successfully!',
//                           ),
//                         ),
//                       );

//                       Navigator.pop(context);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: EdgeInsets.symmetric(vertical: 18),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: Text(
//                     'Submit Request',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/screens/apply_regularisation_screen.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/domain/models/regularisation_model.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class ApplyRegularisationScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> user;

//   const ApplyRegularisationScreen({super.key, required this.user});

//   @override
//   ConsumerState<ApplyRegularisationScreen> createState() =>
//       _ApplyRegularisationScreenState();
// }

// class _ApplyRegularisationScreenState
//     extends ConsumerState<ApplyRegularisationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _selectedDate;
//   RegularisationType _selectedType = RegularisationType.fullDay;
//   final TextEditingController _reasonController = TextEditingController();

//   @override
//   void dispose() {
//     _reasonController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Apply Regularisation'),
//         centerTitle: true,
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Date Picker
//               Text(
//                 'Date for Regularisation',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 12),
//               InkWell(
//                 onTap: () async {
//                   final DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now().subtract(Duration(days: 1)),
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime.now(),
//                     helpText: 'Select the date you missed/were late',
//                     builder: (context, child) {
//                       return Theme(
//                         data: Theme.of(context).copyWith(
//                           colorScheme: ColorScheme.light(
//                             primary: AppColors.primary,
//                           ),
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
//                   if (picked != null) {
//                     setState(() {
//                       _selectedDate = picked;
//                     });
//                   }
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey[400]!),
//                     borderRadius: BorderRadius.circular(12),
//                     color: isDark ? Colors.grey.shade700 : Colors.grey.shade50,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.calendar_today, color: AppColors.primary),
//                       SizedBox(width: 12),
//                       Text(
//                         _selectedDate == null
//                             ? 'Select Date'
//                             : DateFormat('dd/MM/yyyy').format(_selectedDate!),
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       Spacer(),
//                       Icon(Icons.arrow_drop_down),
//                     ],
//                   ),
//                 ),
//               ),
//               if (_selectedDate == null)
//                 Padding(
//                   padding: EdgeInsets.only(top: 8),
//                   child: Text(
//                     'Date is required',
//                     style: TextStyle(color: Colors.red, fontSize: 12),
//                   ),
//                 ),

//               SizedBox(height: 24),

//               // Type Selection
//               Text(
//                 'Regularisation Type',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 12),
//               Wrap(
//                 spacing: 12,
//                 runSpacing: 12,
//                 children: RegularisationType.values.map((type) {
//                   return ChoiceChip(
//                     label: Text(type.displayName),
//                     selected: _selectedType == type,
//                     onSelected: (selected) {
//                       if (selected) {
//                         setState(() {
//                           _selectedType = type;
//                         });
//                       }
//                     },
//                     selectedColor: AppColors.primary,
//                     backgroundColor: isDark
//                         ? Colors.grey.shade700
//                         : Colors.grey.shade200,
//                     labelStyle: TextStyle(
//                       color: _selectedType == type
//                           ? Colors.white
//                           : (isDark ? Colors.white70 : Colors.black87),
//                     ),
//                   );
//                 }).toList(),
//               ),

//               SizedBox(height: 24),

//               // Reason
//               Text(
//                 'Reason / Justification',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 12),
//               TextFormField(
//                 controller: _reasonController,
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   hintText: 'Explain why you need regularisation...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: AppColors.primary, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Reason is required';
//                   }
//                   if (value.trim().length < 20) {
//                     return 'Reason must be at least 20 characters';
//                   }
//                   return null;
//                 },
//               ),

//               Spacer(),

//               // Submit Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   // apply_regularisation_screen.dart mein submit button ke andar
//                   onPressed: () {
//                     if (_selectedDate == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Please select a date')),
//                       );
//                       return;
//                     }
//                     if (_formKey.currentState!.validate()) {
//                       final newRequest = RegularisationRequest(
//                         empId: widget.user['emp_id'],
//                         empName: widget.user['emp_name'],
//                         designation: widget.user['emp_role'],
//                         appliedDate: DateFormat(
//                           'yyyy-MM-dd',
//                         ).format(DateTime.now()),
//                         forDate: DateFormat(
//                           'yyyy-MM-dd',
//                         ).format(_selectedDate!),
//                         justification: _reasonController.text.trim(),
//                         status: 'pending',
//                         type: _selectedType.displayName, // "Full Day" etc.
//                         checkinTime: null,
//                         checkoutTime: null,
//                         shortfall: null,
//                         projectNames:
//                             [], // future mein employee ke projects load kar sakte hain
//                       );

//                       // Add to notifier
//                       ref
//                           .read(regularisationProvider.notifier)
//                           .addRequest(newRequest);

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Regularisation request submitted successfully!',
//                           ),
//                         ),
//                       );

//                       Navigator.pop(context);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: EdgeInsets.symmetric(vertical: 18),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   child: Text(
//                     'Submit Request',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Extension for display name
// extension on RegularisationType {
//   String get displayName {
//     switch (this) {
//       case RegularisationType.fullDay:
//         return 'Full Day';
//       case RegularisationType.checkInOnly:
//         return 'Check-in Only';
//       case RegularisationType.checkOutOnly:
//         return 'Check-out Only';
//       case RegularisationType.halfDay:
//         return 'Half Day';
//     }
//   }
// }
