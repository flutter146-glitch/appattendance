// // lib/features/leaves/presentation/widgets/leave_filter_bar.dart
// // Fully updated: No hardcoded data, dynamic filters (All/Team/Pending/Approved/Rejected), export filtered data to Excel, search dialog, dark mode, production-ready

// import 'dart:io';

// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// import 'package:appattendance/features/leaves/presentation/utils/leave_utils.dart';
// import 'package:flutter/material.dart';

// enum LeaveFilter { all, team, pending, approved, rejected }

// class LeaveFilterBar extends StatelessWidget {
//   final LeaveFilter selectedFilter;
//   final ValueChanged<LeaveFilter> onFilterChanged;
//   final List<LeaveModel>
//   allRequests; // Full unfiltered list (for search/filter)
//   final List<LeaveModel>
//   filteredRequests; // Currently filtered list (for export)
//   final bool isManagerView;

//   const LeaveFilterBar({
//     super.key,
//     required this.selectedFilter,
//     required this.onFilterChanged,
//     required this.allRequests,
//     required this.filteredRequests,
//     this.isManagerView = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade900 : Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Filters — Horizontal Scroll
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildFilterChip(
//                     label: 'All',
//                     filter: LeaveFilter.all,
//                     selected: selectedFilter == LeaveFilter.all,
//                     isDark: isDark,
//                   ),
//                   const SizedBox(width: 8),
//                   if (isManagerView) ...[
//                     _buildFilterChip(
//                       label: 'Team',
//                       filter: LeaveFilter.team,
//                       selected: selectedFilter == LeaveFilter.team,
//                       isDark: isDark,
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                   _buildFilterChip(
//                     label: 'Pending',
//                     filter: LeaveFilter.pending,
//                     selected: selectedFilter == LeaveFilter.pending,
//                     isDark: isDark,
//                   ),
//                   const SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Approved',
//                     filter: LeaveFilter.approved,
//                     selected: selectedFilter == LeaveFilter.approved,
//                     isDark: isDark,
//                   ),
//                   const SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Rejected',
//                     filter: LeaveFilter.rejected,
//                     selected: selectedFilter == LeaveFilter.rejected,
//                     isDark: isDark,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Action Buttons
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildActionButton(
//                 icon: Icons.table_chart_rounded,
//                 color: Colors.green,
//                 tooltip: 'Export to Excel',
//                 onTap: () =>
//                     LeaveUtils.exportToExcel(filteredRequests, context),
//               ),
//               const SizedBox(width: 12),
//               _buildActionButton(
//                 icon: Icons.search_rounded,
//                 color: Colors.blue,
//                 tooltip: 'Search',
//                 onTap: () => LeaveUtils.showSearchDialog(context, (query) {
//                   // TODO: Real filter logic (update Riverpod state with query)
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Searching for: "$query"')),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip({
//     required String label,
//     required LeaveFilter filter,
//     required bool selected,
//     required bool isDark,
//   }) {
//     return GestureDetector(
//       onTap: () => onFilterChanged(filter),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: selected
//               ? AppColors.primary
//               : (isDark ? Colors.grey[700] : Colors.grey[200]),
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(
//             color: selected ? AppColors.primary : Colors.transparent,
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (selected)
//               const Icon(Icons.check, color: Colors.white, size: 16),
//             if (selected) const SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected
//                     ? Colors.white
//                     : (isDark ? Colors.white70 : Colors.black87),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required String tooltip,
//     required VoidCallback onTap,
//   }) {
//     return Tooltip(
//       message: tooltip,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Icon(icon, color: Colors.white, size: 20),
//         ),
//       ),
//     );
//   }
// }

// // // lib/features/leaves/presentation/widgets/leave_filter_bar.dart

// // import 'package:appattendance/core/utils/app_colors.dart';
// // import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// // import 'package:appattendance/features/leaves/presentation/utils/leave_utils.dart';
// // import 'package:flutter/material.dart';

// // enum LeaveFilter { all, team, pending, approved, rejected }

// // class LeaveFilterBar extends StatelessWidget {
// //   final LeaveFilter selectedFilter;
// //   final ValueChanged<LeaveFilter> onFilterChanged;
// //   final List<LeaveModel> allRequests;        // Full list (for search)
// //   final List<LeaveModel> filteredRequests;   // Current visible (for export)
// //   final bool isManagerView;                  // Hide 'Team' filter for employee

// //   const LeaveFilterBar({
// //     super.key,
// //     required this.selectedFilter,
// //     required this.onFilterChanged,
// //     required this.allRequests,
// //     required this.filteredRequests,
// //     this.isManagerView = false,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: isDark ? Colors.grey.shade900 : Colors.white,
// //         border: Border(
// //           bottom: BorderSide(
// //             color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
// //             width: 1,
// //           ),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           // Filters — Horizontal Scroll
// //           Expanded(
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: Row(
// //                 children: [
// //                   _buildFilterChip(
// //                     label: 'All',
// //                     filter: LeaveFilter.all,
// //                     selected: selectedFilter == LeaveFilter.all,
// //                     isDark: isDark,
// //                   ),
// //                   const SizedBox(width: 8),

// //                   // Show "Team" filter only for manager
// //                   if (isManagerView) ...[
// //                     _buildFilterChip(
// //                       label: 'Team',
// //                       filter: LeaveFilter.team,
// //                       selected: selectedFilter == LeaveFilter.team,
// //                       isDark: isDark,
// //                     ),
// //                     const SizedBox(width: 8),
// //                   ],

// //                   _buildFilterChip(
// //                     label: 'Pending',
// //                     filter: LeaveFilter.pending,
// //                     selected: selectedFilter == LeaveFilter.pending,
// //                     isDark: isDark,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   _buildFilterChip(
// //                     label: 'Approved',
// //                     filter: LeaveFilter.approved,
// //                     selected: selectedFilter == LeaveFilter.approved,
// //                     isDark: isDark,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   _buildFilterChip(
// //                     label: 'Rejected',
// //                     filter: LeaveFilter.rejected,
// //                     selected: selectedFilter == LeaveFilter.rejected,
// //                     isDark: isDark,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // Action Buttons (Export + Search)
// //           Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               _buildActionButton(
// //                 icon: Icons.table_chart_rounded,
// //                 color: Colors.green,
// //                 tooltip: 'Export Filtered Leaves to Excel',
// //                 onTap: () => LeaveUtils.exportToExcel(filteredRequests, context),
// //               ),
// //               const SizedBox(width: 12),
// //               _buildActionButton(
// //                 icon: Icons.search_rounded,
// //                 color: Colors.blue,
// //                 tooltip: 'Search by Name, Project, Department',
// //                 onTap: () => LeaveUtils.showSearchDialog(
// //                   context,
// //                   (query) {
// //                     // Real search logic (you can add Riverpod state later)
// //                     final lowerQuery = query.toLowerCase();
// //                     final searchResults = allRequests.where((leave) {
// //                       final name = leave.empId.toLowerCase(); // Or map empId to name
// //                       final project = leave.projectName?.toLowerCase() ?? '';
// //                       final department = leave.department?.toLowerCase() ?? '';
// //                       return name.contains(lowerQuery) ||
// //                           project.contains(lowerQuery) ||
// //                           department.contains(lowerQuery);
// //                     }).toList();

// //                     // TODO: Update Riverpod state with searchResults
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(
// //                         content: Text('Found ${searchResults.length} matching leaves'),
// //                         duration: const Duration(seconds: 2),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFilterChip({
// //     required String label,
// //     required LeaveFilter filter,
// //     required bool selected,
// //     required bool isDark,
// //   }) {
// //     return GestureDetector(
// //       onTap: () => onFilterChanged(filter),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //         decoration: BoxDecoration(
// //           color: selected ? AppColors.primary : (isDark ? Colors.grey[700] : Colors.grey[200]),
// //           borderRadius: BorderRadius.circular(30),
// //           border: Border.all(
// //             color: selected ? AppColors.primary : Colors.transparent,
// //             width: 1.5,
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             if (selected) const Icon(Icons.check, color: Colors.white, size: 16),
// //             if (selected) const SizedBox(width: 6),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 13,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildActionButton({
// //     required IconData icon,
// //     required Color color,
// //     required String tooltip,
// //     required VoidCallback onTap,
// //   }) {
// //     return Tooltip(
// //       message: tooltip,
// //       child: GestureDetector(
// //         onTap: onTap,
// //         child: Container(
// //           padding: const EdgeInsets.all(12),
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
// //             shape: BoxShape.circle,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: color.withOpacity(0.3),
// //                 blurRadius: 8,
// //                 offset: const Offset(0, 4),
// //               ),
// //             ],
// //           ),
// //           child: Icon(icon, color: Colors.white, size: 20),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // lib/features/leaves/presentation/widgets/leave_filter_bar.dart

// // import 'dart:io';

// // import 'package:appattendance/core/utils/app_colors.dart';
// // import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// // import 'package:appattendance/features/leaves/presentation/utils/leave_utils.dart';
// // import 'package:flutter/material.dart';

// // enum LeaveFilter { all, team, pending, approved, rejected }

// // class LeaveFilterBar extends StatelessWidget {
// //   final LeaveFilter selectedFilter;
// //   final ValueChanged<LeaveFilter> onFilterChanged;
// //   final List<LeaveModel>
// //   allRequests; // Full unfiltered list (for search/filter)
// //   final List<LeaveModel>
// //   filteredRequests; // Currently filtered list (for export)

// //   const LeaveFilterBar({
// //     super.key,
// //     required this.selectedFilter,
// //     required this.onFilterChanged,
// //     required this.allRequests,
// //     required this.filteredRequests,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: isDark ? Colors.grey.shade900 : Colors.white,
// //         border: Border(
// //           bottom: BorderSide(
// //             color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
// //             width: 1,
// //           ),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           // Filters — Horizontal Scroll
// //           Expanded(
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: Row(
// //                 children: [
// //                   _buildFilterChip(
// //                     label: 'All',
// //                     filter: LeaveFilter.all,
// //                     selected: selectedFilter == LeaveFilter.all,
// //                     isDark: isDark,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   _buildFilterChip(
// //                     label: 'Team',
// //                     filter: LeaveFilter.team,
// //                     selected: selectedFilter == LeaveFilter.team,
// //                     isDark: isDark,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   _buildFilterChip(
// //                     label: 'Pending',
// //                     filter: LeaveFilter.pending,
// //                     selected: selectedFilter == LeaveFilter.pending,
// //                     isDark: isDark,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   _buildFilterChip(
// //                     label: 'Approved',
// //                     filter: LeaveFilter.approved,
// //                     selected: selectedFilter == LeaveFilter.approved,
// //                     isDark: isDark,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   _buildFilterChip(
// //                     label: 'Rejected',
// //                     filter: LeaveFilter.rejected,
// //                     selected: selectedFilter == LeaveFilter.rejected,
// //                     isDark: isDark,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // Action Buttons
// //           Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               _buildActionButton(
// //                 icon: Icons.table_chart_rounded,
// //                 color: Colors.green,
// //                 tooltip: 'Export to Excel',
// //                 onTap: () =>
// //                     LeaveUtils.exportToExcel(filteredRequests, context),
// //               ),
// //               const SizedBox(width: 12),
// //               _buildActionButton(
// //                 icon: Icons.search_rounded,
// //                 color: Colors.blue,
// //                 tooltip: 'Search',
// //                 onTap: () => LeaveUtils.showSearchDialog(context, (query) {
// //                   // TODO: Real filter logic (update Riverpod state)
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('Searching for: "$query"')),
// //                   );
// //                 }),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFilterChip({
// //     required String label,
// //     required LeaveFilter filter,
// //     required bool selected,
// //     required bool isDark,
// //   }) {
// //     return GestureDetector(
// //       onTap: () => onFilterChanged(filter),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //         decoration: BoxDecoration(
// //           color: selected
// //               ? AppColors.primary
// //               : (isDark ? Colors.grey[700] : Colors.grey[200]),
// //           borderRadius: BorderRadius.circular(30),
// //           border: Border.all(
// //             color: selected ? AppColors.primary : Colors.transparent,
// //             width: 1.5,
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             if (selected)
// //               const Icon(Icons.check, color: Colors.white, size: 16),
// //             if (selected) const SizedBox(width: 6),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 color: selected
// //                     ? Colors.white
// //                     : (isDark ? Colors.white70 : Colors.black87),
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 13,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildActionButton({
// //     required IconData icon,
// //     required Color color,
// //     required String tooltip,
// //     required VoidCallback onTap,
// //   }) {
// //     return Tooltip(
// //       message: tooltip,
// //       child: GestureDetector(
// //         onTap: onTap,
// //         child: Container(
// //           padding: const EdgeInsets.all(12),
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
// //             shape: BoxShape.circle,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: color.withOpacity(0.3),
// //                 blurRadius: 8,
// //                 offset: const Offset(0, 4),
// //               ),
// //             ],
// //           ),
// //           child: Icon(icon, color: Colors.white, size: 20),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // lib/features/leaves/presentation/widgets/leave_filter_bar.dart

// // import 'dart:io';
// // import 'package:appattendance/core/utils/app_colors.dart';
// // import 'package:appattendance/features/leaves/domain/models/leave_model.dart';
// // import 'package:excel/excel.dart' hide Border;
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:open_file/open_file.dart';
// // import 'package:permission_handler/permission_handler.dart';

// // enum LeaveFilter { all, team, pending, approved, rejected }

// // class LeaveFilterBar extends StatelessWidget {
// //   final LeaveFilter selectedFilter;
// //   final ValueChanged<LeaveFilter> onFilterChanged;
// //   final List<LeaveModel> allRequests; // Full list
// //   final List<LeaveModel> filteredRequests; // For export

// //   const LeaveFilterBar({
// //     super.key,
// //     required this.selectedFilter,
// //     required this.onFilterChanged,
// //     required this.allRequests,
// //     required this.filteredRequests,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: isDark ? Colors.grey.shade900 : Colors.white,
// //         border: Border(
// //           bottom: BorderSide(
// //             color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
// //             width: 1,
// //           ),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           // Filters
// //           Expanded(
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: Row(
// //                 children: [
// //                   _buildChip('All', LeaveFilter.all, isDark),
// //                   const SizedBox(width: 8),
// //                   _buildChip('Team', LeaveFilter.team, isDark),
// //                   const SizedBox(width: 8),
// //                   _buildChip('Pending', LeaveFilter.pending, isDark),
// //                   const SizedBox(width: 8),
// //                   _buildChip('Approved', LeaveFilter.approved, isDark),
// //                   const SizedBox(width: 8),
// //                   _buildChip('Rejected', LeaveFilter.rejected, isDark),
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // Actions
// //           Row(
// //             children: [
// //               _buildAction(
// //                 Icons.table_chart_rounded,
// //                 Colors.green,
// //                 'Export',
// //                 () => _exportToExcel(context),
// //               ),
// //               const SizedBox(width: 12),
// //               _buildAction(
// //                 Icons.search,
// //                 Colors.blue,
// //                 'Search',
// //                 () => _showSearchDialog(context),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildChip(String label, LeaveFilter filter, bool isDark) {
// //     final selected = selectedFilter == filter;
// //     return GestureDetector(
// //       onTap: () => onFilterChanged(filter),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //         decoration: BoxDecoration(
// //           color: selected
// //               ? AppColors.primary
// //               : (isDark ? Colors.grey[700] : Colors.grey[200]),
// //           borderRadius: BorderRadius.circular(30),
// //         ),
// //         child: Text(
// //           label,
// //           style: TextStyle(
// //             color: selected
// //                 ? Colors.white
// //                 : (isDark ? Colors.white70 : Colors.black87),
// //             fontWeight: FontWeight.w600,
// //             fontSize: 13,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAction(
// //     IconData icon,
// //     Color color,
// //     String tooltip,
// //     VoidCallback onTap,
// //   ) {
// //     return Tooltip(
// //       message: tooltip,
// //       child: GestureDetector(
// //         onTap: onTap,
// //         child: Container(
// //           padding: const EdgeInsets.all(12),
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
// //             shape: BoxShape.circle,
// //           ),
// //           child: Icon(icon, color: Colors.white, size: 20),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _exportToExcel(BuildContext context) async {
// //     var status = await Permission.storage.request();
// //     if (status.isDenied)
// //       status = await Permission.manageExternalStorage.request();
// //     if (!status.isGranted) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(const SnackBar(content: Text('Permission denied')));
// //       return;
// //     }

// //     try {
// //       final excel = Excel.createExcel();
// //       final sheet = excel['Leaves'];

// //       sheet.appendRow([
// //         TextCellValue('Employee Name'),
// //         TextCellValue('Type'),
// //         TextCellValue('From'),
// //         TextCellValue('To'),
// //         TextCellValue('Status'),
// //         TextCellValue('Reason'),
// //         TextCellValue('Manager Remarks'),
// //       ]);

// //       for (final leave in filteredRequests) {
// //         sheet.appendRow([
// //           TextCellValue(leave.empId), // Replace with real emp name from DB
// //           TextCellValue(leave.leaveType.name),
// //           TextCellValue(leave.formattedFrom),
// //           TextCellValue(leave.formattedTo),
// //           TextCellValue(leave.approvalStatus),
// //           TextCellValue(leave.justification),
// //           TextCellValue(leave.managerComments ?? '-'),
// //         ]);
// //       }

// //       final dir = await getExternalStorageDirectory();
// //       if (dir == null) throw Exception('Storage not available');

// //       final path =
// //           '${dir.path}/Leaves_${DateTime.now().millisecondsSinceEpoch}.xlsx';
// //       final file = File(path);
// //       await file.writeAsBytes(excel.encode()!);

// //       final result = await OpenFile.open(path);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //             result.type == ResultType.done ? 'Exported!' : 'Open failed',
// //           ),
// //         ),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
// //     }
// //   }

// //   void _showSearchDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Search Leaves'),
// //         content: TextField(
// //           decoration: const InputDecoration(
// //             hintText: 'Name / Project / Department',
// //           ),
// //           onSubmitted: (value) {
// //             // TODO: Implement real search (Riverpod state update)
// //             Navigator.pop(context);
// //           },
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('Search'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
