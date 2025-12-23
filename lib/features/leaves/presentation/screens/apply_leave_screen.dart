// lib/features/leaves/presentation/screens/apply_leave_screen.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ApplyLeaveScreen extends ConsumerStatefulWidget {
  final String userId;

  const ApplyLeaveScreen({super.key, required this.userId});

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

  @override
  void dispose() {
    _notesController.dispose();
    _handoverNameController.dispose();
    _handoverEmailController.dispose();
    _handoverPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom)
          _fromDate = picked;
        else
          _toDate = picked;
      });
    }
  }

  Future<void> _pickTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFrom)
          _fromTime = picked;
        else
          _toTime = picked;
      });
    }
  }

  Future<void> _submitLeave() async {
    if (_fromDate == null ||
        _toDate == null ||
        _fromTime == null ||
        _toTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select dates and times')),
      );
      return;
    }

    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reason is required')));
      return;
    }

    final newLeave = LeaveModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.userId,
      fromDate: _fromDate!,
      toDate: _toDate!,
      fromTime: _fromTime!,
      toTime: _toTime!,
      leaveType: _selectedType,
      notes: _notesController.text.trim(),
      isHalfDayFrom: _isHalfDayFrom,
      isHalfDayTo: _isHalfDayTo,
      status: LeaveStatus.pending,
      appliedDate: DateTime.now(),
      handoverPersonName: _handoverNameController.text.trim().isEmpty
          ? null
          : _handoverNameController.text.trim(),
      handoverPersonEmail: _handoverEmailController.text.trim().isEmpty
          ? null
          : _handoverEmailController.text.trim(),
      handoverPersonPhone: _handoverPhoneController.text.trim().isEmpty
          ? null
          : _handoverPhoneController.text.trim(),
      totalDays: _calculateTotalDays(),
    );

    // TODO: Local DB save + future API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Leave request submitted successfully!')),
    );

    Navigator.pop(context);
  }

  int _calculateTotalDays() {
    if (_fromDate == null || _toDate == null) return 0;
    final difference = _toDate!.difference(_fromDate!).inDays + 1;
    if (_isHalfDayFrom || _isHalfDayTo) return difference - 0.5.toInt();
    return difference;
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
            // From Date
            _buildDatePicker('From Date', _fromDate, () => _pickDate(true)),
            const SizedBox(height: 16),

            // From Time + Half Day
            _buildTimePicker('From Time', _fromTime, () => _pickTime(true)),
            SwitchListTile(
              title: const Text('Half Day From'),
              value: _isHalfDayFrom,
              onChanged: (val) => setState(() => _isHalfDayFrom = val),
            ),
            const SizedBox(height: 16),

            // To Date
            _buildDatePicker('To Date', _toDate, () => _pickDate(false)),
            const SizedBox(height: 16),

            // To Time + Half Day
            _buildTimePicker('To Time', _toTime, () => _pickTime(false)),
            SwitchListTile(
              title: const Text('Half Day To'),
              value: _isHalfDayTo,
              onChanged: (val) => setState(() => _isHalfDayTo = val),
            ),
            const SizedBox(height: 24),

            // Leave Type Dropdown
            DropdownButtonFormField<LeaveType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Leave Type',
                border: OutlineInputBorder(),
              ),
              items: LeaveType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
            const SizedBox(height: 24),

            // Notes
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Reason / Notes *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Handover Person (Optional)
            const Text(
              'Handover Person (Optional)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _handoverNameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _handoverEmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _handoverPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitLeave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Leave Request',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          date == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(date),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          time == null ? 'Select Time' : time.format(context),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
