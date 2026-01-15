// lib/features/attendance/presentation/screens/employee_individual_details_screen.dart
// LIGHTWEIGHT & PRODUCTION-READY - January 15, 2026
// Refactored: heavy parts moved to separate widgets
// Real data only (TeamMember + individualAnalyticsProvider)

import 'dart:io';

import 'package:appattendance/features/attendance/domain/models/analytics_model.dart';
import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:appattendance/features/attendance/presentation/widgets/analytics/period_selector_widget.dart';
import 'package:appattendance/features/attendance/presentation/widgets/employeewidgets/attendance_history_widget.dart';
import 'package:appattendance/features/attendance/presentation/widgets/employeewidgets/daily_attendance_overview_card.dart';
import 'package:appattendance/features/attendance/presentation/widgets/employeewidgets/employee_header_widget.dart';
import 'package:appattendance/features/attendance/presentation/widgets/employeewidgets/employee_info_card.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class EmployeeIndividualDetailsScreen extends ConsumerWidget {
  final TeamMember employee;

  const EmployeeIndividualDetailsScreen({required this.employee, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Real analytics for this employee
    final analyticsAsync = ref.watch(
      individualAnalyticsProvider(employee.empId),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () => _exportEmployeeData(
              context,
              ref,
              employee,
              analyticsAsync.value,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Gradient Header (avatar + name)
          EmployeeHeaderWidget(employee: employee),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PeriodSelectorWidget(),
                  // 2. Employee Info Card (designation, email, phone, status)
                  EmployeeInfoCard(employee: employee),

                  const SizedBox(height: 24),

                  // 3. Daily Attendance Overview Card
                  DailyAttendanceOverviewCard(analyticsAsync: analyticsAsync),

                  const SizedBox(height: 32),

                  // 4. Attendance History (separate widget)
                  AttendanceHistoryWidget(employee: employee),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Real XLSX export (no dummy)
  Future<void> _exportEmployeeData(
    BuildContext context,
    WidgetRef ref,
    TeamMember employee,
    AnalyticsModel? analytics,
  ) async {
    if (analytics == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No analytics data available')),
      );
      return;
    }

    try {
      final excel = Excel.createExcel();
      final sheet = excel['Attendance Report'];

      // Header
      sheet.appendRow([
        TextCellValue('Employee Name'),
        TextCellValue('Designation'),
        TextCellValue('Email'),
        TextCellValue('Phone'),
        TextCellValue('Total Days'),
        TextCellValue('Present'),
        TextCellValue('Absent'),
        TextCellValue('Late'),
        TextCellValue('Leave'),
        TextCellValue('Attendance %'),
      ]);

      // Data
      sheet.appendRow([
        TextCellValue(employee.name),
        TextCellValue(employee.designation ?? 'N/A'),
        TextCellValue(employee.email ?? 'N/A'),
        TextCellValue(employee.phone ?? 'N/A'),
        IntCellValue(analytics.totalDays),
        IntCellValue(analytics.presentDays),
        IntCellValue(analytics.absentDays),
        IntCellValue(analytics.lateDays),
        IntCellValue(analytics.leaveDays),
        TextCellValue('${analytics.attendancePercentage.toStringAsFixed(1)}%'),
      ]);

      // Save
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final path =
          '${directory.path}/attendance_${employee.name.replaceAll(' ', '_')}_$timestamp.xlsx';
      final file = File(path);
      await file.writeAsBytes(excel.encode()!);

      await OpenFilex.open(path);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Exported: $timestamp.xlsx')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }
}
