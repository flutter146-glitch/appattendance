// lib/features/leaves/presentation/widgets/leave_card.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LeaveCard extends ConsumerStatefulWidget {
  final LeaveModel leave;
  final bool isManagerView;
  final bool showActions;

  const LeaveCard({
    super.key,
    required this.leave,
    required this.isManagerView,
    this.showActions = false,
  });

  @override
  ConsumerState<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends ConsumerState<LeaveCard> {
  bool _isSubmitting = false;

  Color _getStatusColor(LeaveStatus status) {
    return switch (status) {
      LeaveStatus.pending => Colors.orange,
      LeaveStatus.approved => Colors.green,
      LeaveStatus.rejected => Colors.red,
      LeaveStatus.cancelled => Colors.grey,
      LeaveStatus.query => Colors.blue,
      _ => Colors.grey,
    };
  }

  Future<void> _submitAction(LeaveStatus newStatus) async {
    if (!mounted) return;
    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(leaveRepositoryProvider);
      await repo.updateLeaveStatus(
        leaveId: widget.leave.leaveId,
        newStatus: newStatus,
        managerComments: 'Action from card', // TODO: Add remarks input dialog
      );

      // Refresh leaves list
      ref.read(myLeavesProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Leave ${newStatus.name}d successfully'),
            backgroundColor: newStatus == LeaveStatus.approved
                ? Colors.green
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Action failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(widget.leave.leaveApprovalStatus);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => LeaveDetailDialog(
            leave: widget.leave,
            isManagerView: widget.isManagerView,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? Colors.grey.shade800 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Leave Type + Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.leave.leaveType.name.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.leave.statusDisplay,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Dates & Duration
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.leave.formattedFrom} - ${widget.leave.formattedTo}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.leave.duration,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Justification
              Text(
                widget.leave.justificationDisplay,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),

              // Manager Remarks
              if (widget.leave.managerComments != null &&
                  widget.leave.managerComments!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manager Remarks',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.leave.managerComments!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],

              // Approve/Reject Buttons
              if (widget.showActions &&
                  widget.isManagerView &&
                  widget.leave.isPending &&
                  ref.watch(canApproveLeavesProvider)) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () => _submitAction(LeaveStatus.rejected),
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isSubmitting
                          ? null
                          : () => _submitAction(LeaveStatus.approved),
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// // lib/features/leaves/presentation/widgets/leave_card.dart
// // Final upgraded version: Riverpod integration + LeaveModel freezed getters + real approve/reject
// // Dec 30, 2025 - Production-ready, loading state, privileges safe

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LeaveCard extends ConsumerStatefulWidget {
//   final LeaveModel leave;
//   final bool isManagerView;
//   final bool showActions;

//   const LeaveCard({
//     super.key,
//     required this.leave,
//     required this.isManagerView,
//     this.showActions = false, // Default false
//   });

//   @override
//   ConsumerState<LeaveCard> createState() => _LeaveCardState();
// }

// class _LeaveCardState extends ConsumerState<LeaveCard> {
//   bool _isSubmitting = false;

//   Color _getStatusColor(LeaveStatus status) {
//     return switch (status) {
//       LeaveStatus.pending => Colors.orange,
//       LeaveStatus.approved => Colors.green,
//       LeaveStatus.rejected => Colors.red,
//       LeaveStatus.cancelled => Colors.grey,
//       LeaveStatus.query => Colors.blue, // Added for query status
//       _ => Colors.grey, // Safety fallback for any new status
//     };
//   }

//   Future<void> _submitAction(LeaveStatus newStatus) async {
//     setState(() => _isSubmitting = true);

//     try {
//       final repo = ref.read(leaveRepositoryProvider);
//       await repo.updateLeaveStatus(
//         leaveId: widget.leave.leaveId,
//         newStatus: newStatus,
//         managerComments: 'Action from card', // TODO: Add remarks input dialog
//       );

//       // Refresh leaves list
//       ref.read(myLeavesProvider.notifier).loadLeaves();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Leave ${newStatus.name}d successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Action failed: $e')));
//     } finally {
//       if (mounted) setState(() => _isSubmitting = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = _getStatusColor(widget.leave.leaveApprovalStatus);

//     return GestureDetector(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (_) => LeaveDetailDialog(
//             leave: widget.leave,
//             isManagerView: widget.isManagerView,
//           ),
//         );
//       },
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
//                       widget.leave.leaveType.name.toUpperCase(),
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
//                       widget.leave.statusDisplay,
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
//                     '${widget.leave.formattedFrom} - ${widget.leave.formattedTo}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     widget.leave.duration,
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               // Justification
//               Text(
//                 widget.leave.justificationDisplay,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 14, height: 1.4),
//               ),

//               // Manager Remarks (if any)
//               if (widget.leave.managerComments != null &&
//                   widget.leave.managerComments!.isNotEmpty) ...[
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
//                         widget.leave.managerComments!,
//                         style: const TextStyle(fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],

//               // Approve/Reject Buttons (only for manager view + pending + privilege check)
//               if (widget.isManagerView &&
//                   widget.leave.isPending &&
//                   ref.watch(canApproveLeavesProvider)) ...[
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: _isSubmitting
//                           ? null
//                           : () => _submitAction(LeaveStatus.rejected),
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
//                       onPressed: _isSubmitting
//                           ? null
//                           : () => _submitAction(LeaveStatus.approved),
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
// }

// // lib/features/leaves/presentation/widgets/leave_card.dart
// // Final upgraded version: Riverpod integration + LeaveModel freezed getters + real approve/reject
// // Dec 30, 2025 - Production-ready, loading state, privileges safe

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/providers/leave_provider.dart';
// import 'package:appattendance/features/leaves/presentation/widgets/common/leave_detail_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// class LeaveCard extends ConsumerStatefulWidget {
//   final LeaveModel leave;
//   final bool isManagerView;

//   const LeaveCard({super.key, required this.leave, this.isManagerView = false});

//   @override
//   ConsumerState<LeaveCard> createState() => _LeaveCardState();
// }

// class _LeaveCardState extends ConsumerState<LeaveCard> {
//   bool _isSubmitting = false;

//   Color _getStatusColor(LeaveStatus status) {
//     return switch (status) {
//       LeaveStatus.pending => Colors.orange,
//       LeaveStatus.approved => Colors.green,
//       LeaveStatus.rejected => Colors.red,
//       LeaveStatus.cancelled => Colors.grey,
//       LeaveStatus.query => Colors.blue, // Added for query status
//       _ => Colors.grey, // Default fallback (safety)
//     };
//   }

//   String _getStatusText(LeaveStatus status) {
//     return status.name[0].toUpperCase() + status.name.substring(1);
//   }

//   Future<void> _submitAction(LeaveStatus newStatus) async {
//     setState(() => _isSubmitting = true);

//     try {
//       final repo = ref.read(leaveRepositoryProvider);
//       await repo.updateLeaveStatus(
//         leaveId: widget.leave.leaveId,
//         newStatus: newStatus,
//         managerComments: 'Action from card', // TODO: Add remarks input dialog
//       );

//       // Refresh leaves list
//       ref.read(myLeavesProvider.notifier).loadLeaves();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Leave ${newStatus.name}d successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Action failed: $e')));
//     } finally {
//       if (mounted) setState(() => _isSubmitting = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final statusColor = _getStatusColor(widget.leave.leaveApprovalStatus);

//     return GestureDetector(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (_) => LeaveDetailDialog(
//             leave: widget.leave,
//             isManagerView: widget.isManagerView,
//           ),
//         );
//       },
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
//                       widget.leave.leaveType.name.toUpperCase(),
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
//                       _getStatusText(widget.leave.leaveApprovalStatus),
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
//                     '${DateFormat('dd MMM yyyy').format(widget.leave.leaveFromDate)} - ${DateFormat('dd MMM yyyy').format(widget.leave.leaveToDate)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     '${widget.leave.totalDays} days',
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 8),

//               // Justification
//               Text(
//                 widget.leave.leaveJustification ?? 'No justification provided',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 14, height: 1.4),
//               ),

//               // Manager Remarks (if any)
//               if (widget.leave.managerComments != null &&
//                   widget.leave.managerComments!.isNotEmpty) ...[
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
//                         widget.leave.managerComments!,
//                         style: const TextStyle(fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],

//               // Approve/Reject Buttons (only for manager view + pending)
//               if (widget.isManagerView && widget.leave.isPending) ...[
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: _isSubmitting
//                           ? null
//                           : () => _submitAction(LeaveStatus.rejected),
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
//                       onPressed: _isSubmitting
//                           ? null
//                           : () => _submitAction(LeaveStatus.approved),
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
// }

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
//     final statusColor = _getStatusColor(leave.approvalStatus);

//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         color: isDark ? Colors.grey.shade700 : Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header: Type + Status
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
//                       leave.approvalStatus.toUpperCase(),
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

//               if (isManagerView && leave.isPending) ...[
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         // TODO: Reject with remarks dialog
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
//                         // TODO: Approve with remarks dialog
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
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }
