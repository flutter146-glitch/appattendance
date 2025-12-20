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
  final Function(RegularisationFilter) onFilterChanged;
  final List<RegularisationRequest> filteredRequests;

  const RegularisationFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filteredRequests,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        // color: isDark ? Colors.grey.shade800 : Colors.white,
        border: Border(
          bottom: BorderSide(
            // color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            color: Colors.white,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Filters — Flexible + Horizontal Scroll
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
                    onTap: () => onFilterChanged(RegularisationFilter.all),
                  ),
                  SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Pending',
                    filter: RegularisationFilter.pending,
                    selected: selectedFilter == RegularisationFilter.pending,
                    isDark: isDark,
                    onTap: () => onFilterChanged(RegularisationFilter.pending),
                  ),
                  SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Approved',
                    filter: RegularisationFilter.approved,
                    selected: selectedFilter == RegularisationFilter.approved,
                    isDark: isDark,
                    onTap: () => onFilterChanged(RegularisationFilter.approved),
                  ),
                  SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Rejected',
                    filter: RegularisationFilter.rejected,
                    selected: selectedFilter == RegularisationFilter.rejected,
                    isDark: isDark,
                    onTap: () => onFilterChanged(RegularisationFilter.rejected),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons — Fixed size
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                label: 'Export',
                icon: Icons.table_chart_rounded,
                color: Colors.green,
                isDark: isDark,
                onTap: () => _exportToExcel(filteredRequests, context),
              ),
              SizedBox(width: 8),
              _buildActionButton(
                label: null,
                icon: Icons.search_rounded,
                color: Colors.blue,
                isDark: isDark,
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            if (selected) Icon(Icons.check, color: Colors.white, size: 16),
            if (selected) SizedBox(width: 6),
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
    required String? label,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: label != null ? 14 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            if (label != null) ...[
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Export to Excel — same
  Future<void> _exportToExcel(
    List<RegularisationRequest> requests,
    BuildContext context,
  ) async {
    // ... same code as before
  }

  // Search Dialog — same
  void _showSearchDialog(BuildContext context) {
    // ... same code
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
