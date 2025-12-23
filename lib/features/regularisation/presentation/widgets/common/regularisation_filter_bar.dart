// lib/features/regularisation/presentation/widgets/regularisation_filter_bar.dart

import 'dart:io';

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

enum RegularisationFilter { all, pending, approved, rejected }

class RegularisationFilterBar extends StatelessWidget {
  final RegularisationFilter selectedFilter;
  final ValueChanged<RegularisationFilter> onFilterChanged;
  final List<RegularisationRequest> allRequests;

  const RegularisationFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.allRequests,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Filters
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'All',
                    filter: RegularisationFilter.all,
                    selected: selectedFilter == RegularisationFilter.all,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Pending',
                    filter: RegularisationFilter.pending,
                    selected: selectedFilter == RegularisationFilter.pending,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Approved',
                    filter: RegularisationFilter.approved,
                    selected: selectedFilter == RegularisationFilter.approved,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Rejected',
                    filter: RegularisationFilter.rejected,
                    selected: selectedFilter == RegularisationFilter.rejected,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: Icons.table_chart_rounded,
                color: Colors.green,
                tooltip: 'Export to Excel',
                onTap: () => _exportToExcel(context),
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.search_rounded,
                color: Colors.blue,
                tooltip: 'Search',
                onTap: () => _showSearchDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required RegularisationFilter filter,
    required bool selected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? Colors.grey[700] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              const Icon(Icons.check, color: Colors.white, size: 16),
            if (selected) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  // Export to Excel - Complete & Working (No Type Error)
  Future<void> _exportToExcel(BuildContext context) async {
    // Permission handling
    var status = await Permission.storage.request();
    if (status.isDenied) {
      status = await Permission.manageExternalStorage.request();
    }
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }

    try {
      // Create Excel
      final excel = Excel.createExcel();
      final sheet = excel['Regularisation Requests'];

      // Header row
      sheet.appendRow([
        TextCellValue('Employee Name'),
        TextCellValue('Designation'),
        TextCellValue('Applied Date'),
        TextCellValue('For Date'),
        TextCellValue('Type'),
        TextCellValue('Status'),
        TextCellValue('Justification'),
        TextCellValue('Shortfall'),
        TextCellValue('Check-in'),
        TextCellValue('Check-out'),
        TextCellValue('Projects'),
      ]);

      // Data rows (null-safe & CellValue wrapped)
      for (final req in allRequests) {
        sheet.appendRow([
          TextCellValue(req.empName ?? 'Unknown'),
          TextCellValue(req.designation ?? '-'),
          TextCellValue(req.appliedDate ?? '-'),
          TextCellValue(req.forDate ?? '-'),
          TextCellValue(req.type ?? '-'),
          TextCellValue(req.status ?? '-'),
          TextCellValue(req.justification ?? '-'),
          TextCellValue(req.shortfall ?? '-'),
          TextCellValue(req.checkinTime ?? '-'),
          TextCellValue(req.checkoutTime ?? '-'),
          TextCellValue(
            req.projectNames.isNotEmpty ? req.projectNames.join(', ') : '-',
          ),
        ]);
      }

      // Save file
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('External storage not available');
      }

      final fileName =
          'Regularisation_Requests_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final path = '${directory.path}/$fileName';

      final file = File(path);
      await file.create(recursive: true);
      await file.writeAsBytes(excel.encode()!);

      // Open file
      final result = await OpenFile.open(path);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File open failed: ${result.message}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported successfully: $fileName')),
        );
      }
    } catch (e) {
      debugPrint('Export error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  // Search Dialog
  void _showSearchDialog(BuildContext context) {
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Requests'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => searchQuery = value.toLowerCase().trim(),
            decoration: const InputDecoration(
              hintText: 'Search by name, reason, status...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (searchQuery.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter search term')),
                  );
                  return;
                }
                // TODO: Actual search/filter logic here (Riverpod state update)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Searching for: "$searchQuery"')),
                );
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}

// // lib/features/regularisation/presentation/widgets/regularisation_filter_bar.dart

// import 'dart:io';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:excel/excel.dart' hide Border;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';

// enum RegularisationFilter { all, pending, approved, rejected }

// class RegularisationFilterBar extends StatelessWidget {
//   final RegularisationFilter selectedFilter;
//   final Function(RegularisationFilter) onFilterChanged;
//   final List<RegularisationRequest>
//   allRequests; // Full list (filter apply karne ke liye)

//   const RegularisationFilterBar({
//     super.key,
//     required this.selectedFilter,
//     required this.onFilterChanged,
//     required this.allRequests,
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
//                     filter: RegularisationFilter.all,
//                     selected: selectedFilter == RegularisationFilter.all,
//                     isDark: isDark,
//                   ),
//                   const SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Pending',
//                     filter: RegularisationFilter.pending,
//                     selected: selectedFilter == RegularisationFilter.pending,
//                     isDark: isDark,
//                   ),
//                   const SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Approved',
//                     filter: RegularisationFilter.approved,
//                     selected: selectedFilter == RegularisationFilter.approved,
//                     isDark: isDark,
//                   ),
//                   const SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Rejected',
//                     filter: RegularisationFilter.rejected,
//                     selected: selectedFilter == RegularisationFilter.rejected,
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
//                 onTap: () => _exportToExcel(context),
//               ),
//               const SizedBox(width: 12),
//               _buildActionButton(
//                 icon: Icons.search_rounded,
//                 color: Colors.blue,
//                 tooltip: 'Search',
//                 onTap: () => _showSearchDialog(context),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip({
//     required String label,
//     required RegularisationFilter filter,
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

//   // Export to Excel
//   Future<void> _exportToExcel(BuildContext context) async {
//     // Permission check
//     if (await Permission.storage.request().isDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Storage permission denied')),
//       );
//       return;
//     }

//     // Create Excel
//     final excel = Excel.createExcel();
//     final sheet = excel['Regularisation Requests'];

//     // Header
//     sheet.appendRow([
//       'Employee Name',
//       'Designation',
//       'Applied Date',
//       'For Date',
//       'Type',
//       'Status',
//       'Justification',
//       'Shortfall',
//       'Check-in',
//       'Check-out',
//       'Projects',
//     ]);

//     // Data rows
//     for (final req in allRequests) {
//       sheet.appendRow([
//         req.empName,
//         req.designation,
//         req.appliedDate,
//         req.forDate,
//         req.type,
//         req.status,
//         req.justification,
//         req.shortfall ?? '-',
//         req.checkinTime ?? '-',
//         req.checkoutTime ?? '-',
//         req.projectNames.join(', '),
//       ]);
//     }

//     // Save file
//     try {
//       final directory = await getExternalStorageDirectory();
//       final path =
//           '${directory!.path}/Regularisation_Requests_${DateTime.now().millisecondsSinceEpoch}.xlsx';
//       final file = File(path);
//       await file.writeAsBytes(excel.encode()!);

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Exported to $path')));

//       OpenFile.open(path);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
//     }
//   }

//   // Search Dialog
//   void _showSearchDialog(BuildContext context) {
//     String searchQuery = '';

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Search Requests'),
//           content: TextField(
//             onChanged: (value) => searchQuery = value.toLowerCase(),
//             decoration: const InputDecoration(
//               hintText: 'Search by name, reason, status...',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // TODO: Apply search filter on allRequests
//                 // For now, just show message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Searching for: $searchQuery')),
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text('Search'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_filter_bar.dart

// import 'dart:io';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:excel/excel.dart' hide Border;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';

// enum RegularisationFilter { all, pending, approved, rejected }

// class RegularisationFilterBar extends StatelessWidget {
//   final RegularisationFilter selectedFilter;
//   final Function(RegularisationFilter) onFilterChanged;
//   final List<RegularisationRequest> filteredRequests;

//   const RegularisationFilterBar({
//     super.key,
//     required this.selectedFilter,
//     required this.onFilterChanged,
//     required this.filteredRequests,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         // color: isDark ? Colors.grey.shade800 : Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             // color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
//             color: Colors.white,
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Filters — Flexible + Horizontal Scroll
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildFilterChip(
//                     label: 'All',
//                     filter: RegularisationFilter.all,
//                     selected: selectedFilter == RegularisationFilter.all,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.all),
//                   ),
//                   SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Pending',
//                     filter: RegularisationFilter.pending,
//                     selected: selectedFilter == RegularisationFilter.pending,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.pending),
//                   ),
//                   SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Approved',
//                     filter: RegularisationFilter.approved,
//                     selected: selectedFilter == RegularisationFilter.approved,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.approved),
//                   ),
//                   SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Rejected',
//                     filter: RegularisationFilter.rejected,
//                     selected: selectedFilter == RegularisationFilter.rejected,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.rejected),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Action Buttons — Fixed size
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildActionButton(
//                 label: 'Export',
//                 icon: Icons.table_chart_rounded,
//                 color: Colors.green,
//                 isDark: isDark,
//                 onTap: () => _exportToExcel(filteredRequests, context),
//               ),
//               SizedBox(width: 8),
//               _buildActionButton(
//                 label: null,
//                 icon: Icons.search_rounded,
//                 color: Colors.blue,
//                 isDark: isDark,
//                 onTap: () => _showSearchDialog(context),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip({
//     required String label,
//     required RegularisationFilter filter,
//     required bool selected,
//     required bool isDark,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
//             if (selected) Icon(Icons.check, color: Colors.white, size: 16),
//             if (selected) SizedBox(width: 6),
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
//     required String? label,
//     required IconData icon,
//     required Color color,
//     required bool isDark,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: label != null ? 14 : 12,
//           vertical: 10,
//         ),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.3),
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: Colors.white, size: 18),
//             if (label != null) ...[
//               SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // Export to Excel — same
//   Future<void> _exportToExcel(
//     List<RegularisationRequest> requests,
//     BuildContext context,
//   ) async {
//     // ... same code as before
//   }

//   // Search Dialog — same
//   void _showSearchDialog(BuildContext context) {
//     // ... same code
//   }
// }

// // lib/features/regularisation/presentation/widgets/regularisation_filter_bar.dart

// import 'dart:io';
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
// import 'package:excel/excel.dart' hide Border;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:permission_handler/permission_handler.dart';

// enum RegularisationFilter { all, pending, approved, rejected }

// class RegularisationFilterBar extends StatelessWidget {
//   final RegularisationFilter selectedFilter;
//   final Function(RegularisationFilter) onFilterChanged;
//   final List<RegularisationRequest> filteredRequests; // Current filtered data

//   const RegularisationFilterBar({
//     super.key,
//     required this.selectedFilter,
//     required this.onFilterChanged,
//     required this.filteredRequests,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey.shade800 : Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           // Filters
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildFilterChip(
//                     label: 'All',
//                     filter: RegularisationFilter.all,
//                     selected: selectedFilter == RegularisationFilter.all,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.all),
//                   ),
//                   SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Pending',
//                     filter: RegularisationFilter.pending,
//                     selected: selectedFilter == RegularisationFilter.pending,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.pending),
//                   ),
//                   SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Approved',
//                     filter: RegularisationFilter.approved,
//                     selected: selectedFilter == RegularisationFilter.approved,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.approved),
//                   ),
//                   SizedBox(width: 8),
//                   _buildFilterChip(
//                     label: 'Rejected',
//                     filter: RegularisationFilter.rejected,
//                     selected: selectedFilter == RegularisationFilter.rejected,
//                     isDark: isDark,
//                     onTap: () => onFilterChanged(RegularisationFilter.rejected),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           SizedBox(width: 16),

//           // Export Button
//           _buildActionButton(
//             label: 'Export',
//             icon: Icons.table_chart_rounded,
//             color: Colors.green,
//             isDark: isDark,
//             onTap: () => _exportToExcel(filteredRequests, context),
//           ),

//           SizedBox(width: 8),

//           // Search Button
//           _buildActionButton(
//             label: null,
//             icon: Icons.search_rounded,
//             color: Colors.blue,
//             isDark: isDark,
//             onTap: () => _showSearchDialog(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip({
//     required String label,
//     required RegularisationFilter filter,
//     required bool selected,
//     required bool isDark,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
//             if (selected) Icon(Icons.check, color: Colors.white, size: 18),
//             if (selected) SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected
//                     ? Colors.white
//                     : (isDark ? Colors.white70 : Colors.black87),
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required String? label,
//     required IconData icon,
//     required Color color,
//     required bool isDark,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: label != null ? 16 : 12,
//           vertical: 12,
//         ),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.3),
//               blurRadius: 8,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 20),
//             if (label != null) ...[
//               SizedBox(width: 8),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   // Export to Excel
//   Future<void> _exportToExcel(
//     List<RegularisationRequest> requests,
//     BuildContext context,
//   ) async {
//     if (requests.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("No data to export")));
//       return;
//     }

//     // Permission
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       status = await Permission.storage.request();
//       if (!status.isGranted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Storage permission denied")));
//         return;
//       }
//     }

//     try {
//       var excel = Excel.createExcel();
//       Sheet sheet = excel['Regularisation Requests'];

//       // Headers
//       sheet.appendRow([
//         TextCellValue('Employee Name'),
//         TextCellValue('Designation'),
//         TextCellValue('Date Applied'),
//         TextCellValue('For Date'),
//         TextCellValue('Type'),
//         TextCellValue('Status'),
//         TextCellValue('Reason'),
//         TextCellValue('Projects'),
//       ]);

//       // Data
//       for (var req in requests) {
//         sheet.appendRow([
//           TextCellValue(req.empName),
//           TextCellValue(req.designation),
//           TextCellValue(req.appliedDate),
//           TextCellValue(req.forDate),
//           TextCellValue(req.type),
//           TextCellValue(req.status.toUpperCase()),
//           TextCellValue(req.justification),
//           TextCellValue(req.projectNames.join(', ')),
//         ]);
//       }

//       // Save file
//       final directory = await getExternalStorageDirectory();
//       final path =
//           '${directory!.path}/regularisation_requests_${DateTime.now().millisecondsSinceEpoch}.xlsx';
//       final file = File(path);
//       await file.writeAsBytes(excel.encode()!);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Exported to $path"),
//           action: SnackBarAction(
//             label: "Open",
//             onPressed: () => OpenFile.open(path),
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Export failed: $e")));
//     }
//   }

//   // Search Dialog
//   void _showSearchDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         String query = '';
//         return AlertDialog(
//           title: Text('Search Regularisation Requests'),
//           content: TextField(
//             onChanged: (value) => query = value,
//             decoration: InputDecoration(
//               hintText: 'Search by name, project, department...',
//               prefixIcon: Icon(Icons.search),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(ctx);
//                 // Implement search logic in provider
//                 // ref.read(regularisationProvider.notifier).search(query);
//               },
//               child: Text('Search'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
