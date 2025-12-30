// // lib/features/leaves/presentation/widgets/leave_detail_dialog.dart
// // Fully updated: No hardcoded fields, aligned with employee_leaves table, production-ready, dynamic status/remarks, manager approve/reject with input

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class LeaveDetailDialog extends StatefulWidget {
//   final LeaveModel leave;
//   final bool isManager;
//   final Function(String status, String remarks)? onUpdateStatus;

//   const LeaveDetailDialog({
//     super.key,
//     required this.leave,
//     this.isManager = false,
//     this.onUpdateStatus,
//   });

//   @override
//   State<LeaveDetailDialog> createState() => _LeaveDetailDialogState();
// }

// class _LeaveDetailDialogState extends State<LeaveDetailDialog> {
//   final TextEditingController _remarksController = TextEditingController();
//   bool _isSubmitting = false;

//   @override
//   void dispose() {
//     _remarksController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = _getStatusColor(
//       widget.leave.approvalStatus.toLowerCase(),
//     );

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.85,
//         ),
//         padding: const EdgeInsets.all(24),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Leave Details',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Status Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Text(
//                   widget.leave.statusDisplay,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Dates & Time
//               _buildInfoRow(
//                 Icons.calendar_today,
//                 'From',
//                 widget.leave.formattedFrom,
//               ),
//               _buildInfoRow(
//                 Icons.calendar_today,
//                 'To',
//                 widget.leave.formattedTo,
//               ),
//               _buildInfoRow(
//                 Icons.access_time,
//                 'Time',
//                 '${widget.leave.fromTime.format(context)} - ${widget.leave.toTime.format(context)}',
//               ),
//               if (widget.leave.totalDays != null)
//                 _buildInfoRow(
//                   Icons.date_range,
//                   'Duration',
//                   widget.leave.duration,
//                 ),

//               const SizedBox(height: 16),

//               // Type & Justification
//               _buildInfoRow(
//                 Icons.category,
//                 'Type',
//                 widget.leave.leaveType.name.toUpperCase(),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Justification',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 widget.leave.justification,
//                 style: const TextStyle(height: 1.4),
//               ),

//               // Manager Remarks (if any)
//               if (widget.leave.managerComments != null &&
//                   widget.leave.managerComments!.isNotEmpty) ...[
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Manager Remarks',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(widget.leave.managerComments!),
//                 ),
//               ],

//               // Manager Approve/Reject Section
//               if (widget.isManager && widget.leave.isPending) ...[
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Manager Action',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: _remarksController,
//                   maxLines: 4,
//                   maxLength: 200,
//                   decoration: const InputDecoration(
//                     labelText: 'Remarks (required for approval/rejection)',
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter your comments here...',
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _isSubmitting
//                             ? null
//                             : () => _submitAction('rejected'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: _isSubmitting
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : const Text('Reject'),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: _isSubmitting
//                             ? null
//                             : () => _submitAction('approved'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: _isSubmitting
//                             ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : const Text('Approve'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _submitAction(String status) async {
//     final remarks = _remarksController.text.trim();

//     if (remarks.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Remarks are required for action')),
//       );
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     try {
//       widget.onUpdateStatus?.call(status, remarks);
//       Navigator.pop(context);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Leave $status successfully')));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Action failed: $e')));
//     } finally {
//       if (mounted) setState(() => _isSubmitting = false);
//     }
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey),
//           const SizedBox(width: 12),
//           Expanded(child: Text('$label: $value')),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'pending':
//         return Colors.orange;
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       case 'cancelled':
//         return Colors.grey;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// // // lib/features/leaves/presentation/widgets/leave_detail_dialog.dart

// // import 'package:appattendance/core/utils/app_colors.dart';
// // import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// // class LeaveDetailDialog extends StatelessWidget {
// //   final LeaveModel leave;
// //   final bool isManager;
// //   final Function(String, String)? onUpdateStatus; // (status, remarks)

// //   const LeaveDetailDialog({
// //     super.key,
// //     required this.leave,
// //     this.isManager = false,
// //     this.onUpdateStatus,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final statusColor = _getStatusColor(leave.approvalStatus);

// //     return Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
// //       child: Container(
// //         constraints: BoxConstraints(
// //           maxHeight: MediaQuery.of(context).size.height * 0.85,
// //         ),
// //         padding: const EdgeInsets.all(24),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     'Leave Details',
// //                     style: Theme.of(context).textTheme.headlineSmall,
// //                   ),
// //                   IconButton(
// //                     icon: const Icon(Icons.close),
// //                     onPressed: () => Navigator.pop(context),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 16),

// //               // Status Badge
// //               Container(
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 16,
// //                   vertical: 8,
// //                 ),
// //                 decoration: BoxDecoration(
// //                   color: statusColor.withOpacity(0.2),
// //                   borderRadius: BorderRadius.circular(30),
// //                 ),
// //                 child: Text(
// //                   leave.approvalStatus.toUpperCase(),
// //                   style: TextStyle(
// //                     color: statusColor,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 16),

// //               // Dates
// //               _buildInfoRow(Icons.calendar_today, 'From', leave.formattedFrom),
// //               _buildInfoRow(Icons.calendar_today, 'To', leave.formattedTo),
// //               _buildInfoRow(
// //                 Icons.access_time,
// //                 'Time',
// //                 '${leave.fromTime.format(context)} - ${leave.toTime.format(context)}',
// //               ),
// //               if (leave.totalDays != null)
// //                 _buildInfoRow(Icons.date_range, 'Duration', leave.duration),

// //               const SizedBox(height: 16),

// //               // Type & Justification
// //               _buildInfoRow(
// //                 Icons.category,
// //                 'Type',
// //                 leave.leaveType.name.toUpperCase(),
// //               ),
// //               const SizedBox(height: 8),
// //               const Text(
// //                 'Justification',
// //                 style: TextStyle(fontWeight: FontWeight.w600),
// //               ),
// //               const SizedBox(height: 4),
// //               Text(leave.justification, style: const TextStyle(height: 1.4)),

// //               if (leave.managerComments != null &&
// //                   leave.managerComments!.isNotEmpty) ...[
// //                 const SizedBox(height: 16),
// //                 const Text(
// //                   'Manager Remarks',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w600,
// //                     color: Colors.blue,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.blue.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Text(leave.managerComments!),
// //                 ),
// //               ],

// //               if (isManager && leave.isPending) ...[
// //                 const SizedBox(height: 24),
// //                 TextField(
// //                   maxLines: 4,
// //                   decoration: const InputDecoration(
// //                     labelText: 'Remarks (200+ chars)',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                   onChanged: (value) {
// //                     // TODO: Store remarks for submit
// //                   },
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: () => onUpdateStatus?.call(
// //                           'rejected',
// //                           'Your remarks here',
// //                         ),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.red,
// //                         ),
// //                         child: const Text('Reject'),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: () => onUpdateStatus?.call(
// //                           'approved',
// //                           'Your remarks here',
// //                         ),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.green,
// //                         ),
// //                         child: const Text('Approve'),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInfoRow(IconData icon, String label, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         children: [
// //           Icon(icon, color: Colors.grey),
// //           const SizedBox(width: 12),
// //           Expanded(child: Text('$label: $value')),
// //         ],
// //       ),
// //     );
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status.toLowerCase()) {
// //       case 'pending':
// //         return Colors.orange;
// //       case 'approved':
// //         return Colors.green;
// //       case 'rejected':
// //         return Colors.red;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// // }
