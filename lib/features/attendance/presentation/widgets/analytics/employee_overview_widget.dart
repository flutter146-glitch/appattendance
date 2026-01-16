import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:appattendance/features/attendance/presentation/screens/employee_individual_details_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class EmployeeOverviewWidget extends ConsumerStatefulWidget {
  const EmployeeOverviewWidget({super.key});

  @override
  ConsumerState<EmployeeOverviewWidget> createState() =>
      _EmployeeOverviewWidgetState();
}

class _EmployeeOverviewWidgetState
    extends ConsumerState<EmployeeOverviewWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOrder = 'A-Z'; // 'A-Z' or 'Z-A'

  final Map<String, bool> _expandedCards = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TeamMember> _filteredAndSorted(List<TeamMember> members) {
    var filtered = members.where((m) {
      final q = _searchQuery.toLowerCase();
      return m.name.toLowerCase().contains(q) ||
          (m.designation ?? '').toLowerCase().contains(q);
    }).toList();

    if (_sortOrder == 'A-Z') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else {
      filtered.sort((a, b) => b.name.compareTo(a.name));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeColors(context);
    final teamAsync = ref.watch(teamMembersProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fancy Header with period + date + count
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people_alt_rounded,
                    color: theme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employee Overview - Daily',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Date: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${teamAsync.value?.length ?? 0} Employees',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search + Sort
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search employees...',
                      hintStyle: TextStyle(
                        color: theme.textSecondary.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    style: TextStyle(color: theme.textPrimary, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => setState(() {
                  _sortOrder = _sortOrder == 'A-Z' ? 'Z-A' : 'A-Z';
                }),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _sortOrder,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _sortOrder == 'A-Z'
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16,
                        color: theme.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          teamAsync.when(
            data: (allMembers) {
              if (allMembers.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      "No team members found",
                      style: TextStyle(color: theme.textSecondary),
                    ),
                  ),
                );
              }

              final members = _filteredAndSorted(allMembers);

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isExpanded = _expandedCards[member.empId] ?? false;

                  final statusColor = member.statusColor(theme);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.isDark
                              ? Colors.black.withOpacity(0.25)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Main tappable area
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EmployeeIndividualDetailsScreen(
                                  employee: member,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar - small & primary tint
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: theme.primary.withOpacity(
                                    0.15,
                                  ),
                                  child: Text(
                                    member.avatarInitial,
                                    style: TextStyle(
                                      color: theme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Name + Status badge (dot + text)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              member.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: theme.textPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(
                                                0.12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: statusColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  member.statusBadgeText,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: statusColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        member.designation ?? "—",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Compact chips for time & project count
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: [
                                          _buildCompactChip(
                                            Icons.access_time_rounded,
                                            member.todayCheckInTime,
                                            theme,
                                          ),
                                          _buildCompactChip(
                                            Icons.work_rounded,
                                            '${member.projectNames?.length ?? 0} Projects',
                                            theme,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Vertical project list (right side, scrollable)
                                SizedBox(
                                  width: 110,
                                  height: 80,
                                  child: ListView.builder(
                                    itemCount: member.projectNames?.length ?? 0,
                                    itemBuilder: (ctx, i) {
                                      final proj = member.projectNames![i];
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.primary.withOpacity(
                                            0.12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          proj,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: theme.primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom expand button
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: theme.divider),
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              'View Daily Attendance Details',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: theme.primary,
                              size: 20,
                            ),
                            onTap: () {
                              setState(() {
                                _expandedCards[member.empId] = !isExpanded;
                              });
                            },
                          ),
                        ),

                        // Expanded Pie Chart + legend
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.surfaceVariant.withOpacity(0.5),
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Daily Attendance Distribution',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 160,
                                  child: PieChart(
                                    PieChartData(
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 35,
                                      sections: [
                                        if (member.totalAttendance > 0) ...[
                                          PieChartSectionData(
                                            value: member.presentPercentage,
                                            title: member.presentPercentage > 5
                                                ? '${member.presentPercentage.toStringAsFixed(0)}%'
                                                : '',
                                            color: theme.success,
                                            radius: 55,
                                            titleStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: member.latePercentage,
                                            title: member.latePercentage > 5
                                                ? '${member.latePercentage.toStringAsFixed(0)}%'
                                                : '',
                                            color: theme.warning,
                                            radius: 55,
                                            titleStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: member.absentPercentage,
                                            title: member.absentPercentage > 5
                                                ? '${member.absentPercentage.toStringAsFixed(0)}%'
                                                : '',
                                            color: theme.error,
                                            radius: 55,
                                            titleStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ] else
                                          PieChartSectionData(
                                            value: 1,
                                            title: 'No Data',
                                            color: theme.textDisabled,
                                            radius: 55,
                                            titleStyle: TextStyle(
                                              color: theme.onPrimary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildPieLegend(
                                      theme.success,
                                      'Present (${member.presentCount})',
                                      theme,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildPieLegend(
                                      theme.warning,
                                      'Late (${member.lateCount})',
                                      theme,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildPieLegend(
                                      theme.error,
                                      'Absent (${member.absentCount})',
                                      theme,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => Shimmer.fromColors(
              baseColor: theme.isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: theme.isDark
                  ? Colors.grey[700]!
                  : Colors.grey[100]!,
              child: Column(
                children: List.generate(
                  5,
                  (_) => Container(
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            error: (err, stk) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  "Error loading team: $err",
                  style: TextStyle(color: theme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactChip(IconData icon, String text, ThemeColors theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: theme.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 11, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegend(Color color, String label, ThemeColors theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: theme.textSecondary)),
      ],
    );
  }
}
