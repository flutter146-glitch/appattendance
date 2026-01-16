// lib/features/team/presentation/screens/team_member_list_screen.dart

import 'dart:async';

import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:appattendance/features/team/presentation/screens/team_member_detail_screen.dart';
import 'package:appattendance/features/team/presentation/widgets/commons/status_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamMemberListScreen extends ConsumerStatefulWidget {
  const TeamMemberListScreen({super.key});

  @override
  ConsumerState<TeamMemberListScreen> createState() =>
      _TeamMemberListScreenState();
}

class _TeamMemberListScreenState extends ConsumerState<TeamMemberListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      ref.read(teamSearchQueryProvider.notifier).state = _searchController.text
          .trim();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    HapticFeedback.lightImpact();
    await ref.read(teamMembersProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeColors(context);
    final userAsync = ref.watch(authProvider);
    final teamAsync = ref.watch(searchedTeamMembersProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text('Team Members', style: TextStyle(color: theme.textPrimary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.surface,
        foregroundColor: theme.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: theme.primary,
        backgroundColor: theme.surface,
        child: Column(
          children: [
            // Search & Filter Row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name, email, designation...',
                        hintStyle: TextStyle(
                          color: theme.textSecondary.withOpacity(0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.textSecondary,
                        ),
                        filled: true,
                        fillColor: theme.surfaceVariant,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      style: TextStyle(color: theme.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const StatusFilterWidget(),
                ],
              ),
            ),

            // Result Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: teamAsync.when(
                  data: (members) => Text(
                    '${members.length} member${members.length == 1 ? '' : 's'} found',
                    style: TextStyle(fontSize: 14, color: theme.textSecondary),
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => Text(
                    'Error loading team',
                    style: TextStyle(color: theme.error),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Members List
            Expanded(
              child: teamAsync.when(
                data: (members) {
                  if (members.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 80,
                            color: theme.textDisabled,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No team members found',
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: theme.isDark ? 1 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: theme.surface,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: member
                                  .statusColor(theme)
                                  .withOpacity(0.2),
                              child: Text(
                                member.avatarInitial,
                                style: TextStyle(
                                  color: member.statusColor(theme),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              member.displayNameWithRole,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  member.email ?? 'No email',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member.quickStats,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: theme.primary,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: member
                                    .statusColor(theme)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                member.statusBadgeText,
                                style: TextStyle(
                                  color: member.statusColor(theme),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TeamMemberDetailScreen(
                                    empId: member.empId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(color: theme.primary),
                ),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 60,
                        color: theme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load team',
                        style: TextStyle(color: theme.error, fontSize: 18),
                      ),
                      TextButton(
                        onPressed: _refresh,
                        child: Text(
                          'Retry',
                          style: TextStyle(color: theme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
