// employee_regularisation_screen.dart

import 'package:appattendance/core/theme/app_gradients.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_filter_provider.dart';
import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/monthly_overview_widget.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeRegularisationScreen extends ConsumerWidget {
  final Map<String, dynamic> user;
  final bool canApproveReject;

  const EmployeeRegularisationScreen({
    super.key,
    required this.user,
    this.canApproveReject = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final regState = ref.watch(regularisationProvider);
    final ownRequests = regState.requests
        .where((r) => r.empId == user['emp_id'])
        .toList();

    final ownStats = RegularisationStats(
      total: ownRequests.length,
      pending: ownRequests.where((r) => r.status == 'pending').length,
      approved: ownRequests.where((r) => r.status == 'approved').length,
      rejected: ownRequests.where((r) => r.status == 'rejected').length,
    );
    double avgShortfall = 1.2;
    int totalDays = ownRequests.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Regularisation Requests'),
        centerTitle: true,
        backgroundColor: AppColors.warning,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Apply Form
        },
        child: Icon(Icons.add),
        tooltip: 'Apply Regularisation',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.dashboard(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
        child: Column(
          children: [
            // 1. Monthly Overview (Own stats)
            MonthlyOverviewWidget(
              total: ownStats.total,
              pending: ownStats.pending,
              approved: ownStats.approved,
              rejected: ownStats.rejected,
              totalDays: totalDays,
              avgShortfall: avgShortfall,
              isManager: false,
            ),

            // 2. Filter Bar Widget (Only for Manager view)
            RegularisationFilterBar(
              selectedFilter: ref.watch(regularisationFilterProvider),
              onFilterChanged: (filter) {
                ref.read(regularisationFilterProvider.notifier).state = filter;
              },
              filteredRequests: regState.requests,
            ),
            // 3. Own Request Cards
            Expanded(
              child: regState.requests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No regularisation requests",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: regState.requests.length,
                      itemBuilder: (context, index) {
                        final req = regState.requests[index];
                        return RegularisationRequestCard(
                          request: req,
                          isDark: isDark,
                          showActions:
                              canApproveReject && req.status == 'pending',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
