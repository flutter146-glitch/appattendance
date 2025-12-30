// // lib/features/leaves/presentation/widgets/leave_card.dart

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class LeaveCard extends StatelessWidget {
//   final LeaveModel leave;
//   final bool isManagerView;
//   final VoidCallback? onTap;

//   const LeaveCard({
//     super.key,
//     required this.leave,
//     this.isManagerView = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = _getStatusColor(leave.approvalStatus.toLowerCase());

//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header: Leave Type + Status Badge
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       leave.leaveType.name.toUpperCase(),
//                       style: TextStyle(
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       leave.statusDisplay,
//                       style: TextStyle(
//                         color: statusColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // Dates & Duration
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.calendar_today,
//                     size: 18,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${leave.formattedFrom} - ${leave.formattedTo}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     leave.duration,
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 8),

//               // Time
//               Row(
//                 children: [
//                   const Icon(Icons.access_time, size: 18, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${leave.fromTime.format(context)} - ${leave.toTime.format(context)}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // Justification
//               Text(
//                 leave.justification,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 14, height: 1.4),
//               ),

//               // Manager Remarks (if any)
//               if (leave.managerComments != null &&
//                   leave.managerComments!.isNotEmpty) ...[
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Manager Remarks',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         leave.managerComments!,
//                         style: const TextStyle(fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],

//               // Approve/Reject Buttons (only for manager view + pending)
//               if (isManagerView && leave.isPending) ...[
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         // TODO: Open reject dialog with remarks input
//                       },
//                       icon: const Icon(Icons.close, color: Colors.red),
//                       label: const Text(
//                         'Reject',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         side: const BorderSide(color: Colors.red),
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // TODO: Open approve dialog with remarks input
//                       },
//                       icon: const Icon(Icons.check),
//                       label: const Text('Approve'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
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

// // // lib/features/leaves/presentation/widgets/leave_card.dart
// // import 'package:appattendance/core/utils/app_colors.dart';
// // import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// // class LeaveCard extends StatelessWidget {
// //   final LeaveModel leave;
// //   final bool isManagerView;
// //   final VoidCallback? onTap;

// //   const LeaveCard({
// //     super.key,
// //     required this.leave,
// //     this.isManagerView = false,
// //     this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final statusColor = _getStatusColor(leave.approvalStatus);

// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Card(
// //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //         elevation: 4,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         color: isDark ? Colors.grey.shade700 : Colors.white,
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Header: Type + Status
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 6,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: AppColors.primary.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Text(
// //                       leave.leaveType.name.toUpperCase(),
// //                       style: TextStyle(
// //                         color: AppColors.primary,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 13,
// //                       ),
// //                     ),
// //                   ),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 6,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: statusColor.withOpacity(0.2),
// //                       borderRadius: BorderRadius.circular(20),
// //                     ),
// //                     child: Text(
// //                       leave.approvalStatus.toUpperCase(),
// //                       style: TextStyle(
// //                         color: statusColor,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 13,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //               const SizedBox(height: 12),

// //               // Dates & Duration
// //               Row(
// //                 children: [
// //                   const Icon(
// //                     Icons.calendar_today,
// //                     size: 18,
// //                     color: Colors.grey,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Text(
// //                     '${leave.formattedFrom} - ${leave.formattedTo}',
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   const Spacer(),
// //                   Text(
// //                     leave.duration,
// //                     style: const TextStyle(fontSize: 14, color: Colors.grey),
// //                   ),
// //                 ],
// //               ),

// //               const SizedBox(height: 8),

// //               // Time
// //               Row(
// //                 children: [
// //                   const Icon(Icons.access_time, size: 18, color: Colors.grey),
// //                   const SizedBox(width: 8),
// //                   Text(
// //                     '${leave.fromTime.format(context)} - ${leave.toTime.format(context)}',
// //                     style: const TextStyle(fontSize: 14),
// //                   ),
// //                 ],
// //               ),

// //               const SizedBox(height: 12),

// //               // Justification
// //               Text(
// //                 leave.justification,
// //                 maxLines: 2,
// //                 overflow: TextOverflow.ellipsis,
// //                 style: const TextStyle(fontSize: 14, height: 1.4),
// //               ),

// //               if (leave.managerComments != null &&
// //                   leave.managerComments!.isNotEmpty) ...[
// //                 const SizedBox(height: 12),
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.blue.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Manager Remarks',
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.w600,
// //                           color: Colors.blue,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Text(
// //                         leave.managerComments!,
// //                         style: const TextStyle(fontSize: 13),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],

// //               if (isManagerView && leave.isPending) ...[
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     OutlinedButton.icon(
// //                       onPressed: () {
// //                         // TODO: Reject with remarks dialog
// //                       },
// //                       icon: const Icon(Icons.close, color: Colors.red),
// //                       label: const Text(
// //                         'Reject',
// //                         style: TextStyle(color: Colors.red),
// //                       ),
// //                       style: OutlinedButton.styleFrom(
// //                         side: const BorderSide(color: Colors.red),
// //                       ),
// //                     ),
// //                     ElevatedButton.icon(
// //                       onPressed: () {
// //                         // TODO: Approve with remarks dialog
// //                       },
// //                       icon: const Icon(Icons.check),
// //                       label: const Text('Approve'),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.green,
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
