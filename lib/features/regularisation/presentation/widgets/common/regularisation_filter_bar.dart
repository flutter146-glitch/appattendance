import 'dart:io';

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/regularisation/domain/models/regularisation_filter.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// enum RegularisationFilter { all, pending, approved, rejected }

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
    // final user = ref.watch(authProvider).value;

    // final isManagerial = user?.isManagerial ?? false;
    // final selectedFilter = ref.watch(regularisationFilterProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // color: isDark ? Colors.grey.shade900 : Colors.white,
        color: Colors.transparent,
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
                  // const SizedBox(width: 8),
                  // // if (isManagerial)
                  // _buildFilterChip(
                  //   label: 'team',
                  //   filter: RegularisationFilter.pending,
                  //   selected: selectedFilter == RegularisationFilter.pending,
                  //   isDark: isDark,
                  // ),
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
          color: selected ? AppColors.primary : Colors.grey.withOpacity(0.2),

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
      final result = await OpenFilex.open(path);
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
