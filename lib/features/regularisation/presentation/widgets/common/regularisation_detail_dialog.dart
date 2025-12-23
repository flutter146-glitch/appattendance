// lib/features/regularisation/presentation/widgets/regularisation_detail_dialog.dart

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

// // lib/features/regularisation/presentation/widgets/regularisation_detail_dialog.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RegularisationDetailDialog extends StatefulWidget {
//   final RegularisationRequest request;
//   final bool
//   isManager; // true = manager view (approve/reject + remarks), false = employee view only

//   const RegularisationDetailDialog({
//     super.key,
//     required this.request,
//     this.isManager = false,
//   });

//   @override
//   State<RegularisationDetailDialog> createState() =>
//       _RegularisationDetailDialogState();
// }

// class _RegularisationDetailDialogState
//     extends State<RegularisationDetailDialog> {
//   final TextEditingController _remarksController = TextEditingController();
//   int _remarksLength = 0;

//   @override
//   void initState() {
//     super.initState();
//     _remarksController.addListener(() {
//       setState(() {
//         _remarksLength = _remarksController.text.trim().length;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _remarksController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = widget.request.status == 'pending'
//         ? Colors.orange
//         : widget.request.status == 'approved'
//         ? Colors.green
//         : Colors.red;

//     // Dummy monthly stats for this employee (future mein API se real data aayega)
//     // Yeh data request ke empId ke basis pe calculate hoga
//     final monthlyStats = {
//       'total': 28,
//       'pending': 8,
//       'approved': 16,
//       'rejected': 4,
//     };

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.9,
//         ),
//         decoration: BoxDecoration(
//           color: isDark ? Colors.grey.shade900 : Colors.white,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header with Back Arrow
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'Request Details',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Monthly Overview (Employee Specific)
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.grey.shade800
//                             : Colors.blue.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.calendar_month,
//                                 color: Colors.blue,
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Monthly Overview - ${DateFormat('MMMM yyyy').format(DateTime.now())}',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _buildStat(
//                                 'Total',
//                                 monthlyStats['total'].toString(),
//                                 Colors.blue,
//                               ),
//                               _buildStat(
//                                 'Pending',
//                                 monthlyStats['pending'].toString(),
//                                 Colors.orange,
//                               ),
//                               _buildStat(
//                                 'Approved',
//                                 monthlyStats['approved'].toString(),
//                                 Colors.green,
//                               ),
//                               _buildStat(
//                                 'Rejected',
//                                 monthlyStats['rejected'].toString(),
//                                 Colors.red,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Employee Info
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 28,
//                           backgroundColor: statusColor,
//                           child: Text(
//                             widget.request.empName
//                                 .split(' ')
//                                 .map((e) => e[0])
//                                 .take(2)
//                                 .join(),
//                             style: const TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.request.empName,
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 widget.request.designation ??
//                                     'Senior Developer',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Text(
//                             widget.request.status.toUpperCase(),
//                             style: TextStyle(
//                               color: statusColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Projects
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: widget.request.projectNames.map((p) {
//                         return Chip(
//                           label: Text(p),
//                           backgroundColor: Colors.blue.withOpacity(0.1),
//                           avatar: const Icon(Icons.folder, color: Colors.blue),
//                         );
//                       }).toList(),
//                     ),

//                     const SizedBox(height: 24),

//                     // Working Time + Date
//                     Row(
//                       children: [
//                         const Icon(Icons.lock_clock, color: Colors.purple),
//                         const SizedBox(width: 8),
//                         Text(
//                           // 'Working Time: ${widget.request.type}',
//                           'Working Time:',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 16),

//                     // Punch IN-OUT + Shortfall
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.grey.shade800
//                             : Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Punch IN - OUT',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 '${widget.request.checkinTime ?? '10:30 AM'} - ${widget.request.checkoutTime ?? '7:00 PM'}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               const Text(
//                                 'Shortfall Hrs',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 widget.request.shortfall ?? '1h 30m',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Reason
//                     const Text(
//                       'Reason',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.grey.shade800
//                             : Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         widget.request.justification,
//                         style: TextStyle(fontSize: 15, height: 1.5),
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // Remarks Input (only for pending + manager)
//                     if (widget.isManager &&
//                         widget.request.status == 'pending') ...[
//                       const Text(
//                         'Remarks *',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: _remarksController,
//                         maxLines: 5,
//                         decoration: InputDecoration(
//                           hintText: 'Enter your detailed remarks here...',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           counterText: '$_remarksLength/200',
//                           counterStyle: TextStyle(
//                             color: _remarksLength >= 200
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             _remarksLength = value.trim().length;
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Minimum 200 characters required',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: _remarksLength >= 200
//                               ? Colors.green
//                               : Colors.grey,
//                         ),
//                       ),
//                     ],

//                     const SizedBox(height: 32),

//                     // Action Buttons (only for Manager + Pending)
//                     if (widget.isManager && widget.request.status == 'pending')
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               if (_remarksLength < 200) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Remarks must be at least 200 characters',
//                                     ),
//                                   ),
//                                 );
//                                 return;
//                               }
//                               // TODO: Reject API call with remarks
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.close),
//                             label: const Text('Reject'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                             ),
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               if (_remarksLength < 200) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Remarks must be at least 200 characters',
//                                     ),
//                                   ),
//                                 );
//                                 return;
//                               }
//                               // TODO: Query API call with remarks
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.help_outline),
//                             label: const Text('Query'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                             ),
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               if (_remarksLength < 200) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       'Remarks must be at least 200 characters',
//                                     ),
//                                   ),
//                                 );
//                                 return;
//                               }
//                               // TODO: Approve API call with remarks
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.check),
//                             label: const Text('Approve'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStat(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_detail_dialog.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RegularisationDetailDialog extends StatelessWidget {
//   final RegularisationRequest request;
//   final bool
//   isManager; // true → approve/reject buttons, false → employee view only

//   const RegularisationDetailDialog({
//     super.key,
//     required this.request,
//     this.isManager = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = request.status == 'pending'
//         ? Colors.orange
//         : request.status == 'approved'
//         ? Colors.green
//         : Colors.red;

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.85,
//         ),
//         decoration: BoxDecoration(
//           color: isDark ? Colors.grey.shade900 : Colors.white,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header with gradient + User Name
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           request.empName ??
//                               'User', // ← Yeh line se user ka naam dikhega
//                           style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Regularisation Details',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),

//             Flexible(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Date + Day + Status
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.blue,
//                             size: 28,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               DateFormat(
//                                 'dd/MM/yyyy',
//                               ).format(DateTime.parse(request.forDate)),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               DateFormat(
//                                 'EEEE',
//                               ).format(DateTime.parse(request.forDate)),
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Text(
//                             request.status.toUpperCase(),
//                             style: TextStyle(
//                               color: statusColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Check-in & Out + Shortfall
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.grey.shade800
//                             : Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Check-in Time",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 request.checkinTime ?? '--',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Shortfall",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 request.shortfall ?? '--',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Reason
//                     const Text(
//                       'Reason / Justification',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       request.justification,
//                       style: TextStyle(
//                         fontSize: 15,
//                         height: 1.5,
//                         color: isDark ? Colors.white70 : Colors.black87,
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Projects
//                     if (request.projectNames.isNotEmpty) ...[
//                       const Text(
//                         'Projects',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: request.projectNames.map((project) {
//                           return Chip(
//                             label: Text(project),
//                             backgroundColor: Colors.blue.withOpacity(0.1),
//                             labelStyle: const TextStyle(color: Colors.blue),
//                             avatar: const Icon(
//                               Icons.folder,
//                               size: 18,
//                               color: Colors.blue,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ],

//                     const SizedBox(height: 32),

//                     // Manager Comment Section (Safe null handling)
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: statusColor.withOpacity(0.3)),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 request.status == 'approved'
//                                     ? Icons.check_circle
//                                     : Icons.cancel,
//                                 color: statusColor,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Manager Comment',
//                                 style: TextStyle(
//                                   color: statusColor,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             request.managerRemarks ??
//                                 (request.status == 'pending'
//                                     ? 'Request is pending approval. No remarks yet.'
//                                     : 'No remarks provided by manager.'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: isDark ? Colors.white70 : Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // Action Buttons (only for Manager in pending state)
//                     if (isManager && request.status == 'pending')
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // TODO: Reject with remarks dialog
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Reject',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // TODO: Approve with remarks dialog
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Approve',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_detail_dialog.dart

// // ... existing imports

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // ← Yeh line add kar do top pe

// class RegularisationDetailDialog extends StatelessWidget {
//   final RegularisationRequest request;
//   final bool isManager;

//   const RegularisationDetailDialog({
//     super.key,
//     required this.request,
//     this.isManager = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = request.status == 'pending'
//         ? Colors.orange
//         : request.status == 'approved'
//         ? Colors.green
//         : Colors.red;

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.85,
//         ),
//         decoration: BoxDecoration(
//           color: isDark ? Colors.grey.shade900 : Colors.white,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     user['emp_name'] ?? 'User' + 'Details',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),

//             Flexible(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Date + Day + Status
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.blue,
//                             size: 28,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               DateFormat(
//                                 'dd/MM/yyyy',
//                               ).format(DateTime.parse(request.forDate)),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               DateFormat(
//                                 'EEEE',
//                               ).format(DateTime.parse(request.forDate)),
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Text(
//                             request.status.toUpperCase(),
//                             style: TextStyle(
//                               color: statusColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Check-in & Out + Shortfall
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.grey.shade800
//                             : Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Check-in Time",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 request.checkinTime ?? '--',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Shortfall",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 request.shortfall ?? '--',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Reason
//                     const Text(
//                       'Reason / Justification',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       request.justification,
//                       style: TextStyle(
//                         fontSize: 15,
//                         height: 1.5,
//                         color: isDark ? Colors.white70 : Colors.black87,
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Projects
//                     if (request.projectNames.isNotEmpty) ...[
//                       const Text(
//                         'Projects',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: request.projectNames.map((project) {
//                           return Chip(
//                             label: Text(project),
//                             backgroundColor: Colors.blue.withOpacity(0.1),
//                             labelStyle: const TextStyle(color: Colors.blue),
//                             avatar: const Icon(
//                               Icons.folder,
//                               size: 18,
//                               color: Colors.blue,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ],

//                     const SizedBox(height: 32),

//                     // Manager Comment Section (Safe null handling)
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: statusColor.withOpacity(0.3)),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 request.status == 'approved'
//                                     ? Icons.check_circle
//                                     : Icons.cancel,
//                                 color: statusColor,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Manager Comment',
//                                 style: TextStyle(
//                                   color: statusColor,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             request.managerRemarks ??
//                                 (request.status == 'pending'
//                                     ? 'Request is pending approval. No remarks yet.'
//                                     : 'No remarks provided by manager.'),
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: isDark ? Colors.white70 : Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // Action Buttons (only for Manager in pending state)
//                     if (isManager && request.status == 'pending')
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // TODO: Reject with remarks dialog
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Reject',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // TODO: Approve with remarks dialog
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Approve',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_detail_dialog.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RegularisationDetailDialog extends StatelessWidget {
//   final RegularisationRequest request;
//   final bool
//   isManager; // true → show approve/reject, false → employee view only

//   const RegularisationDetailDialog({
//     super.key,
//     required this.request,
//     this.isManager = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = request.status == 'pending'
//         ? Colors.orange
//         : request.status == 'approved'
//         ? Colors.green
//         : Colors.red;

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.85,
//         ),
//         decoration: BoxDecoration(
//           color: isDark ? Colors.grey.shade900 : Colors.white,
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header with gradient
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Regularisation Details',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),

//             // Content
//             Flexible(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Date + Day + Status
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.blue,
//                             size: 28,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               DateFormat(
//                                 'dd/MM/yyyy',
//                               ).format(DateTime.parse(request.forDate)),
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               DateFormat(
//                                 'EEEE',
//                               ).format(DateTime.parse(request.forDate)),
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Text(
//                             request.status.toUpperCase(),
//                             style: TextStyle(
//                               color: statusColor,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Check-in & Out + Shortfall
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.grey.shade800
//                             : Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Check-in Time",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 request.checkinTime ?? '--',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Shortfall",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 request.shortfall ?? '--',
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Reason
//                     const Text(
//                       'Reason / Justification',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       request.justification,
//                       style: TextStyle(
//                         fontSize: 15,
//                         height: 1.5,
//                         color: isDark ? Colors.white70 : Colors.black87,
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Projects
//                     if (request.projectNames.isNotEmpty) ...[
//                       const Text(
//                         'Projects',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: request.projectNames.map((project) {
//                           return Chip(
//                             label: Text(project),
//                             backgroundColor: Colors.blue.withOpacity(0.1),
//                             labelStyle: const TextStyle(color: Colors.blue),
//                             avatar: const Icon(
//                               Icons.folder,
//                               size: 18,
//                               color: Colors.blue,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ],

//                     const SizedBox(height: 32),

//                     // Manager Comment (if any)
//                     if (request.status != 'pending')
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: statusColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: statusColor.withOpacity(0.3),
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   request.status == 'approved'
//                                       ? Icons.check_circle
//                                       : Icons.cancel,
//                                   color: statusColor,
//                                   size: 20,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Manager Comment',
//                                   style: TextStyle(
//                                     color: statusColor,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               request.managerRemarks ??
//                                   'No remarks provided yet.',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: isDark ? Colors.white70 : Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                     // if (request.status != 'pending')
//                     //   Container(
//                     //     padding: const EdgeInsets.all(16),
//                     //     decoration: BoxDecoration(
//                     //       color: statusColor.withOpacity(0.1),
//                     //       borderRadius: BorderRadius.circular(12),
//                     //       border: Border.all(
//                     //         color: statusColor.withOpacity(0.3),
//                     //       ),
//                     //     ),
//                     //     child: Column(
//                     //       crossAxisAlignment: CrossAxisAlignment.start,
//                     //       children: [
//                     //         Row(
//                     //           children: [
//                     //             Icon(
//                     //               request.status == 'approved'
//                     //                   ? Icons.check_circle
//                     //                   : Icons.cancel,
//                     //               color: statusColor,
//                     //               size: 20,
//                     //             ),
//                     //             const SizedBox(width: 8),
//                     //             Text(
//                     //               'Manager Comment',
//                     //               style: TextStyle(
//                     //                 color: statusColor,
//                     //                 fontWeight: FontWeight.bold,
//                     //               ),
//                     //             ),
//                     //           ],
//                     //         ),
//                     //         const SizedBox(height: 8),
//                     //         Text(
//                     //           request.managerRemarks ?? 'No remarks provided.',
//                     //           style: TextStyle(
//                     //             fontSize: 14,
//                     //             color: isDark ? Colors.white70 : Colors.black87,
//                     //           ),
//                     //         ),
//                     //       ],
//                     //     ),
//                     //   ),
//                     const SizedBox(height: 32),

//                     // Action Buttons (only for Manager)
//                     if (isManager && request.status == 'pending')
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // Reject logic
//                                 // ref.read(regularisationProvider.notifier).rejectRequest(request.regId, remarks);
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Reject',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // Approve logic
//                                 // ref.read(regularisationProvider.notifier).approveRequest(request.regId, remarks);
//                                 Navigator.pop(context);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 'Approve',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
