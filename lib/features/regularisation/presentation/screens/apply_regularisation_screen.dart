// lib/features/Regularization/presentation/screens/apply_Regularization_screen.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';

import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_provider.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/apply_regularisation_widgets/apply_regularisation_date_section.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/apply_regularisation_widgets/apply_regularisation_reason_section.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/apply_regularisation_widgets/apply_regularisation_submit_button.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/apply_regularisation_widgets/apply_regularisation_type_section.dart';
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
  DateTime? _selectedDate;
  String _selectedType = 'Full Day';
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a date')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(authProvider).value;
      if (user == null) return;

      final newRequest = RegularisationRequest(
        regId: 'REG${DateTime.now().millisecondsSinceEpoch}',
        empId: widget.user['emp_id'] as String? ?? '',
        empName: widget.user['emp_name'] as String? ?? 'Unknown',
        designation: widget.user['designation'] as String? ?? 'Employee',
        appliedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        forDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        justification: _reasonController.text.trim(),
        status: 'pending',
        type: _selectedType,
        projectNames: [],
      );

      await ref.read(regularisationProvider.notifier).addRequest(newRequest);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Regularization request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Apply Regularization'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Selection
              _buildSectionCard(
                child: ApplyRegularisationDateSection(
                  selectedDate: _selectedDate,
                  onDateTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: AppColors.primary,
                            brightness: Theme.of(context).brightness,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null && mounted) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Type Selection
              _buildSectionCard(
                child: ApplyRegularisationTypeSection(
                  selectedType: _selectedType,
                  onTypeChanged: (type) => setState(() => _selectedType = type),
                ),
              ),

              const SizedBox(height: 24),

              // Reason
              _buildSectionCard(
                child: ApplyRegularisationReasonSection(
                  controller: _reasonController,
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              ApplyRegularisationSubmitButton(
                isSubmitting: _isSubmitting,
                onPressed: _submitRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
