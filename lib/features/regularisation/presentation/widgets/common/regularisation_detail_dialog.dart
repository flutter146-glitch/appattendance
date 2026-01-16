import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegularisationDetailDialog extends StatefulWidget {
  final RegularisationRequest request;
  final bool
  isManager; // true = manager view (approve/reject + remarks), false = employee view only

  const RegularisationDetailDialog({
    super.key,
    required this.request,
    this.isManager = false,
  });

  @override
  State<RegularisationDetailDialog> createState() =>
      _RegularisationDetailDialogState();
}

class _RegularisationDetailDialogState
    extends State<RegularisationDetailDialog> {
  final TextEditingController _remarksController = TextEditingController();
  int _remarksLength = 0;

  @override
  void initState() {
    super.initState();
    _remarksController.addListener(() {
      setState(() {
        _remarksLength = _remarksController.text.trim().length;
      });
    });
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Map<String, int> _getDummyMonthlyStats(String empId) {
    // empId ke basis pe thoda variation (demo ke liye)
    final hash = empId.hashCode % 10;
    return {
      'total': 25 + hash,
      'pending': 6 + (hash % 3),
      'approved': 15 + (hash % 5),
      'rejected': 3 + (hash % 2),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = widget.request.status == 'pending'
        ? Colors.orange
        : widget.request.status == 'approved'
        ? Colors.green
        : Colors.red;

    // TODO: Kal API se real monthly stats fetch karo (empId ke basis pe)
    final monthlyStats = _getDummyMonthlyStats(widget.request.empId);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Request Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Overview
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.blue,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Monthly Overview - ${DateFormat('MMMM yyyy').format(DateTime.now())}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat(
                        'Total',
                        monthlyStats['total'].toString(),
                        Colors.blue,
                      ),
                      _buildStat(
                        'Pending',
                        monthlyStats['pending'].toString(),
                        Colors.orange,
                      ),
                      _buildStat(
                        'Approved',
                        monthlyStats['approved'].toString(),
                        Colors.green,
                      ),
                      _buildStat(
                        'Rejected',
                        monthlyStats['rejected'].toString(),
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Employee Info + Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: statusColor,
                    child: Text(
                      widget.request.empName
                          .split(' ')
                          .map((e) => e[0])
                          .take(2)
                          .join(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.request.empName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.request.designation ?? 'Senior Developer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      widget.request.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Projects
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.request.projectNames.map((p) {
                  return Chip(
                    label: Text(p),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    avatar: const Icon(Icons.folder, color: Colors.blue),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Working Time + Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.lock_clock, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(
                    'Working Time: ${widget.request.type}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Punch IN-OUT + Shortfall (Dynamic from request)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Punch IN - OUT',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          '${widget.request.checkinTime ?? '--'} - ${widget.request.checkoutTime ?? '--'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Shortfall Hrs',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          widget.request.shortfall ?? '--',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Reason
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reason',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.request.justification,
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Remarks Input (only for pending + manager)
            if (widget.isManager && widget.request.status == 'pending')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Remarks *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _remarksController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter your detailed remarks here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        counterText: '$_remarksLength/200',
                        counterStyle: TextStyle(
                          color: _remarksLength >= 200
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _remarksLength = value.trim().length;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Minimum 200 characters required',
                      style: TextStyle(
                        fontSize: 12,
                        color: _remarksLength >= 200
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // Action Buttons (only for Manager + Pending)
            if (widget.isManager && widget.request.status == 'pending')
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_remarksLength < 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Remarks must be at least 200 characters',
                              ),
                            ),
                          );
                          return;
                        }
                        // TODO: Reject API call with _remarksController.text
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_remarksLength < 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Remarks must be at least 200 characters',
                              ),
                            ),
                          );
                          return;
                        }
                        // TODO: Query API call with _remarksController.text
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Query'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_remarksLength < 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Remarks must be at least 200 characters',
                              ),
                            ),
                          );
                          return;
                        }
                        // TODO: Approve API call with _remarksController.text
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
