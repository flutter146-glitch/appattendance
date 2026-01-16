// lib/features/regularisation/presentation/screens/employee_regularisation_screen.dart

import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/month_filter_widget.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_provider.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/monthly_overview_widget.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_detail_dialog.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EmployeeRegularisationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;

  const EmployeeRegularisationScreen({super.key, required this.user});

  @override
  ConsumerState<EmployeeRegularisationScreen> createState() =>
      _EmployeeRegularisationScreenState();
}

class _EmployeeRegularisationScreenState
    extends ConsumerState<EmployeeRegularisationScreen> {
  String _selectedMonth = DateFormat('MMM yyyy').format(DateTime.now());
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final regState = ref.watch(regularisationProvider);

    final empId = widget.user['emp_id'] as String? ?? '';
    final ownRequests = regState.requests
        .where((r) => r.empId == empId)
        .toList();

    // Filter by selected month (safe parsing)
    final filteredRequests = ownRequests.where((r) {
      try {
        final date = DateTime.parse(r.forDate);
        final monthYear = DateFormat('MMM yyyy').format(date);
        return monthYear == _selectedMonth;
      } catch (_) {
        return false;
      }
    }).toList();

    // Filtered stats
    final ownStats = RegularisationStats(
      total: filteredRequests.length,
      pending: filteredRequests.where((r) => r.status == 'pending').length,
      approved: filteredRequests.where((r) => r.status == 'approved').length,
      rejected: filteredRequests.where((r) => r.status == 'rejected').length,
    );

    return Scaffold(
      // extendBodyBehindAppBar hata diya → gradient body ke andar hi rahega, no half cut-off
      // appBar: AppBar(
      //   title: const Text('My Regularisation Requests'),
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
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => ApplyRegularisationScreen(user: widget.user),
      //       ),
      //     );
      //   },
      //   label: const Text('Apply New'),
      //   icon: const Icon(Icons.add),
      //   backgroundColor: AppColors.primary,
      //   elevation: 8,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.dashboard(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        child: SafeArea(
          // SafeArea strengthened - top/bottom insets handle karega
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
                    // Month Filter
                    MonthFilterWidget(
                      selectedMonth: _selectedMonth,
                      onMonthChanged: (newMonth) {
                        setState(() => _selectedMonth = newMonth);
                      },
                    ),

                    // const SizedBox(height: 24),

                    // Monthly Overview
                    RegularizationMonthlyOverviewWidget(
                      total: ownStats.total,
                      pending: ownStats.pending,
                      approved: ownStats.approved,
                      rejected: ownStats.rejected,
                      avgShortfall: 1.2, // TODO: Real from DB
                      totalDays: filteredRequests.length,
                      isManager: false,
                    ),

                    const SizedBox(height: 24),

                    // Filter Bar
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
                                    "No regularisation requests in $_selectedMonth",
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
                                          isManager: false,
                                        ),
                                  );
                                },
                                child: RegularisationRequestCard(
                                  request: req,
                                  isDark: isDark,
                                  isEmployeeView: true,
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
      ),
    );
  }
}
