// lib/features/regularisation/presentation/screens/manager_regularisation_screen.dart

import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/core/providers/view_mode_provider.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_provider.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/month_filter_widget.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/monthly_overview_widget.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_detail_dialog.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ManagerRegularisationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;
  final bool canApproveReject;
  final bool isEmployeeViewMode;

  const ManagerRegularisationScreen({
    super.key,
    required this.user,
    this.canApproveReject = false,
    this.isEmployeeViewMode = false,
  });

  @override
  ConsumerState<ManagerRegularisationScreen> createState() =>
      _ManagerRegularisationScreenState();
}

class _ManagerRegularisationScreenState
    extends ConsumerState<ManagerRegularisationScreen> {
  String _selectedMonth = DateFormat('MMM yyyy').format(DateTime.now());
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final regState = ref.watch(regularisationProvider);
    final viewMode = ref.watch(viewModeProvider);

    final empId = widget.user['emp_id'] as String? ?? '';

    // Data filter based on view mode
    final List<RegularisationRequest> displayedRequests =
        widget.isEmployeeViewMode || viewMode == ViewMode.employee
        ? regState.requests.where((r) => r.empId == empId).toList()
        : regState.requests;

    // Filter by selected month (only in employee view mode)
    final filteredRequests =
        widget.isEmployeeViewMode || viewMode == ViewMode.employee
        ? displayedRequests.where((r) {
            try {
              final date = DateTime.parse(r.forDate);
              final monthYear = DateFormat('MMM yyyy').format(date);
              return monthYear == _selectedMonth;
            } catch (_) {
              return false;
            }
          }).toList()
        : displayedRequests;

    // Stats from filtered requests
    final int total = filteredRequests.length;
    final int pending = filteredRequests
        .where((r) => r.status == 'pending')
        .length;
    final int approved = filteredRequests
        .where((r) => r.status == 'approved')
        .length;
    final int rejected = filteredRequests
        .where((r) => r.status == 'rejected')
        .length;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text(
      //     widget.isEmployeeViewMode || viewMode == ViewMode.employee ? '' : '',
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   foregroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //       icon: _isRefreshing
      //           ? const SizedBox(
      //               height: 24,
      //               width: 24,
      //               child: CircularProgressIndicator(
      //                 color: Colors.white,
      //                 strokeWidth: 3,
      //               ),
      //             )
      //           : const Icon(Icons.refresh),
      //       onPressed: _isRefreshing
      //           ? null
      //           : () async {
      //               setState(() => _isRefreshing = true);
      //               await ref.read(regularisationProvider.notifier).refresh();
      //               setState(() => _isRefreshing = false);
      //             },
      //     ),
      //   ],
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.dashboard(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => _isRefreshing = true);
            await ref.read(regularisationProvider.notifier).refresh();
            setState(() => _isRefreshing = false);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Filter - ONLY in employee view mode
                  if (widget.isEmployeeViewMode ||
                      viewMode == ViewMode.employee)
                    MonthFilterWidget(
                      selectedMonth: _selectedMonth,
                      onMonthChanged: (newMonth) {
                        setState(() => _selectedMonth = newMonth);
                      },
                    ),

                  // const SizedBox(height: 24),

                  // Monthly Overview
                  RegularizationMonthlyOverviewWidget(
                    total: total,
                    pending: pending,
                    approved: approved,
                    rejected: rejected,
                    avgShortfall: 1.2, // TODO: Real from DB
                    totalDays: filteredRequests.length,
                    isManager:
                        !widget.isEmployeeViewMode &&
                        viewMode == ViewMode.manager,
                  ),

                  const SizedBox(height: 24),

                  // Filter Bar - ONLY in manager view (team data)
                  if (!widget.isEmployeeViewMode &&
                      viewMode == ViewMode.manager)
                    RegularisationFilterBar(
                      selectedFilter: ref.watch(regularisationFilterProvider),
                      onFilterChanged: (filter) =>
                          ref
                                  .read(regularisationFilterProvider.notifier)
                                  .state =
                              filter,
                      allRequests: filteredRequests,
                    ),

                  const SizedBox(height: 16),

                  // Requests List
                  regState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredRequests.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.hourglass_empty_rounded,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No requests found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredRequests.length,
                          itemBuilder: (context, index) {
                            final req = filteredRequests[index];
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      RegularisationDetailDialog(
                                        request: req,
                                        isManager:
                                            !widget.isEmployeeViewMode &&
                                            viewMode == ViewMode.manager,
                                      ),
                                );
                              },
                              child: RegularisationRequestCard(
                                request: req,
                                isDark: isDark,
                                showActions:
                                    widget.canApproveReject &&
                                    !widget.isEmployeeViewMode &&
                                    viewMode == ViewMode.manager &&
                                    req.status == 'pending',
                                isEmployeeView:
                                    widget.isEmployeeViewMode ||
                                    viewMode == ViewMode.employee,
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
