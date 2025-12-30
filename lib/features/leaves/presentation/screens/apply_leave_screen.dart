// lib/features/leaves/presentation/screens/apply_leave_screen.dart
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
import 'package:appattendance/features/leaves/presentation/utils/apply_leave_validators.dart';
import 'package:appattendance/features/leaves/presentation/widgets/apply_leaves_widgets/apply_leave_date_time_section.dart';
import 'package:appattendance/features/leaves/presentation/widgets/apply_leaves_widgets/apply_leave_handover_section.dart';
import 'package:appattendance/features/leaves/presentation/widgets/apply_leaves_widgets/apply_leave_notes_section.dart';
import 'package:appattendance/features/leaves/presentation/widgets/apply_leaves_widgets/apply_leave_submit_button.dart';
import 'package:appattendance/features/leaves/presentation/widgets/apply_leaves_widgets/apply_leave_type_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ApplyLeaveScreen extends ConsumerStatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  ConsumerState<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends ConsumerState<ApplyLeaveScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  LeaveType _selectedType = LeaveType.casual;
  final TextEditingController _notesController = TextEditingController();
  bool _isHalfDayFrom = false;
  bool _isHalfDayTo = false;
  final TextEditingController _handoverNameController = TextEditingController();
  final TextEditingController _handoverEmailController =
  TextEditingController();
  final TextEditingController _handoverPhoneController =
  TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    _handoverNameController.dispose();
    _handoverEmailController.dispose();
    _handoverPhoneController.dispose();
    super.dispose();
  }

  // Define _pickDate method
  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom)
          _fromDate = picked;
        else
          _toDate = picked;
      });
    }
  }

  // Define _pickTime method
  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom)
          _fromTime = picked;
        else
          _toTime = picked;
      });
    }
  }

  Future<void> _submitLeave() async {
    // Validation (moved to utils)
    if (!_validateForm()) return;

    final user = ref.read(authProvider).value;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      final newLeave = LeaveModel(
        leaveId: const Uuid().v4(),
        empId: user.empId,
        mgrEmpId:
        user.reportingManagerId ?? '', // TODO: Real mgr_emp_id from DB
        leaveFromDate: _fromDate!,
        leaveToDate: _toDate!,
        leaveType: _selectedType,
        leaveJustification: _notesController.text.trim(),
        leaveApprovalStatus: LeaveStatus.pending,
        managerComments: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fromTime: _fromTime != null ? _fromTime!.format(context) : null,
        toTime: _toTime != null ? _toTime!.format(context) : null,
      );

      final repo = ref.read(leaveRepositoryProvider);
      await repo.applyLeave(newLeave);

      ref.read(myLeavesProvider.notifier).loadLeaves();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave request submitted successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // apply_leave_validator.dart
  bool _validateForm() {
    final dateError = ApplyLeaveValidators.validateDates(
      _fromDate,
      _toDate,
      context,
    );
    if (dateError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(dateError)));
      return false;
    }

    final notesError = ApplyLeaveValidators.validateNotes(
      _notesController.text,
    );
    if (notesError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(notesError)));
      return false;
    }

    final timeError = ApplyLeaveValidators.validateTime(
      _fromTime,
      _toTime,
      _isHalfDayFrom,
      _isHalfDayTo,
    );
    if (timeError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(timeError)));
      return false;
    }

    final typeError = ApplyLeaveValidators.validateLeaveType(_selectedType);
    if (typeError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(typeError)));
      return false;
    }

    final emailError = ApplyLeaveValidators.validateEmail(
      _handoverEmailController.text,
    );
    if (emailError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(emailError)));
      return false;
    }

    final phoneError = ApplyLeaveValidators.validatePhone(
      _handoverPhoneController.text,
    );
    if (phoneError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(phoneError)));
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Leave'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApplyLeaveDateTimeSection(
              fromDate: _fromDate,
              toDate: _toDate,
              fromTime: _fromTime,
              toTime: _toTime,
              isHalfDayFrom: _isHalfDayFrom,
              isHalfDayTo: _isHalfDayTo,
              onFromDateTap: () => _pickDate(true),
              onToDateTap: () => _pickDate(false),
              onFromTimeTap: () => _pickTime(true),
              onToTimeTap: () => _pickTime(false),
              onHalfDayFromChanged: (val) =>
                  setState(() => _isHalfDayFrom = val),
              onHalfDayToChanged: (val) => setState(() => _isHalfDayTo = val),
            ),
            const SizedBox(height: 24),
            ApplyLeaveTypeSection(
              selectedType: _selectedType,
              onTypeChanged: (type) => setState(() => _selectedType = type),
            ),
            const SizedBox(height: 24),
            ApplyLeaveNotesSection(controller: _notesController),
            const SizedBox(height: 24),
            ApplyLeaveHandoverSection(
              nameController: _handoverNameController,
              emailController: _handoverEmailController,
              phoneController: _handoverPhoneController,
            ),
            const SizedBox(height: 32),
            ApplyLeaveSubmitButton(
              isSubmitting: _isSubmitting,
              onPressed: _submitLeave,
            ),
          ],
        ),
      ),
    );
  }
}

// // lib/features/leaves/presentation/screens/apply_leave_screen.dart
// // Final upgraded version: Riverpod sync + freezed LeaveModel + real DB submit
// // Dec 30, 2025 - Production-ready, validation, loading state, dark mode

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/data/repositories/leave_repository.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

// class ApplyLeaveScreen extends ConsumerStatefulWidget {
//   const ApplyLeaveScreen({super.key});

//   @override
//   ConsumerState<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
// }

// class _ApplyLeaveScreenState extends ConsumerState<ApplyLeaveScreen> {
//   DateTime? _fromDate;
//   DateTime? _toDate;
//   TimeOfDay? _fromTime;
//   TimeOfDay? _toTime;
//   LeaveType _selectedType = LeaveType.casual;
//   final TextEditingController _notesController = TextEditingController();
//   bool _isHalfDayFrom = false;
//   bool _isHalfDayTo = false;
//   final TextEditingController _handoverNameController = TextEditingController();
//   final TextEditingController _handoverEmailController =
//       TextEditingController();
//   final TextEditingController _handoverPhoneController =
//       TextEditingController();

//   bool _isSubmitting = false;

//   @override
//   void dispose() {
//     _notesController.dispose();
//     _handoverNameController.dispose();
//     _handoverEmailController.dispose();
//     _handoverPhoneController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate(bool isFrom) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null && mounted) {
//       setState(() {
//         if (isFrom)
//           _fromDate = picked;
//         else
//           _toDate = picked;
//       });
//     }
//   }

//   Future<void> _pickTime(bool isFrom) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null && mounted) {
//       setState(() {
//         if (isFrom)
//           _fromTime = picked;
//         else
//           _toTime = picked;
//       });
//     }
//   }

//   Future<void> _submitLeave() async {
//     if (_fromDate == null || _toDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select from and to dates')),
//       );
//       return;
//     }

//     if (_fromDate!.isAfter(_toDate!)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('From date cannot be after To date')),
//       );
//       return;
//     }

//     if (_notesController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Reason is required')));
//       return;
//     }

//     final user = ref.read(authProvider).value;
//     if (user == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Not logged in')));
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     try {
//       final newLeave = LeaveModel(
//         leaveId: const Uuid().v4(),
//         empId: user.empId,
//         mgrEmpId:
//             user.mgrEmpId ??
//             '', // TODO: Get real mgr_emp_id from DB or user model
//         leaveFromDate: _fromDate!,
//         leaveToDate: _toDate!,
//         leaveType: _selectedType,
//         leaveJustification: _notesController.text.trim(),
//         leaveApprovalStatus: LeaveStatus.pending,
//         managerComments: null,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//         fromTime: _fromTime != null ? _fromTime!.format(context) : null,
//         toTime: _toTime != null ? _toTime!.format(context) : null,
//       );

//       final repo = ref.read(leaveRepositoryProvider);
//       await repo.applyLeave(newLeave);

//       // Refresh leaves list
//       ref.read(myLeavesProvider.notifier).loadLeaves();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Leave request submitted successfully!')),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to submit: $e')));
//     } finally {
//       if (mounted) setState(() => _isSubmitting = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Apply Leave'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // From Date
//             _buildDatePicker('From Date', _fromDate, () => _pickDate(true)),
//             const SizedBox(height: 16),

//             // From Time + Half Day
//             _buildTimePicker('From Time', _fromTime, () => _pickTime(true)),
//             SwitchListTile(
//               title: const Text('Half Day From'),
//               value: _isHalfDayFrom,
//               onChanged: (val) => setState(() => _isHalfDayFrom = val),
//             ),
//             const SizedBox(height: 16),

//             // To Date
//             _buildDatePicker('To Date', _toDate, () => _pickDate(false)),
//             const SizedBox(height: 16),

//             // To Time + Half Day
//             _buildTimePicker('To Time', _toTime, () => _pickTime(false)),
//             SwitchListTile(
//               title: const Text('Half Day To'),
//               value: _isHalfDayTo,
//               onChanged: (val) => setState(() => _isHalfDayTo = val),
//             ),
//             const SizedBox(height: 24),

//             // Leave Type Dropdown
//             DropdownButtonFormField<LeaveType>(
//               value: _selectedType,
//               decoration: const InputDecoration(
//                 labelText: 'Leave Type',
//                 border: OutlineInputBorder(),
//               ),
//               items: LeaveType.values.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type.name.toUpperCase()),
//                 );
//               }).toList(),
//               onChanged: (val) {
//                 if (val != null) setState(() => _selectedType = val);
//               },
//             ),
//             const SizedBox(height: 24),

//             // Notes
//             TextFormField(
//               controller: _notesController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 labelText: 'Reason / Notes *',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Handover Person (Optional)
//             const Text(
//               'Handover Person (Optional)',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             TextFormField(
//               controller: _handoverNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: _handoverEmailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: _handoverPhoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 32),

//             // Submit Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isSubmitting ? null : _submitLeave,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _isSubmitting
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         'Submit Leave Request',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         child: Text(
//           date == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(date),
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         child: Text(
//           time == null ? 'Select Time' : time.format(context),
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }