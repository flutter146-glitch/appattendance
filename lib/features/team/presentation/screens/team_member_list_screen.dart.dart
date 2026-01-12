// lib/features/team/presentation/screens/team_member_list_screen.dart
// ULTIMATE & PRODUCTION-READY VERSION - January 09, 2026 (Fully Upgraded)
// Key Upgrades:
// - Modern SliverAppBar with member count + search
// - Shimmer loading for list
// - Pull-to-refresh with haptic feedback
// - Real-time search with debounce
// - Empty state with icon
// - Filter button placeholder with future-ready
// - Hero animation on card tap
// - Dark/light mode perfect contrast & shadows
// - Accessibility & responsive layout

import 'dart:async';

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:appattendance/features/team/presentation/screens/team_member_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authProvider);
    final teamAsync = ref.watch(searchedTeamMembersProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await ref.read(teamMembersProvider.notifier).refresh();
        },
        child: CustomScrollView(
          slivers: [
            // SliverAppBar with Search
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: isDark ? Colors.grey[900] : AppColors.primary,
              title: const Text(
                'My Team',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list_rounded),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Filter options coming soon...'),
                      ),
                    );
                  },
                  tooltip: 'Filter',
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDark
                          ? [Colors.grey[900]!, Colors.black]
                          : [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                            ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, designation...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                        .read(teamSearchQueryProvider.notifier)
                                        .state =
                                    '';
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: teamAsync.when(
                  data: (members) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          '${members.length} member${members.length == 1 ? '' : 's'} found',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (members.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No team members found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Hero(
                                  tag: 'team_member_${member.empId}',
                                  child: Card(
                                    elevation: 6,
                                    shadowColor: Colors.black.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    color: isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                TeamMemberDetailScreen(
                                                  empId: member.empId,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: Row(
                                          children: [
                                            // Avatar with present indicator
                                            Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 32,
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  backgroundImage:
                                                      member.profilePhotoUrl !=
                                                          null
                                                      ? NetworkImage(
                                                          member
                                                              .profilePhotoUrl!,
                                                        )
                                                      : null,
                                                  child:
                                                      member.profilePhotoUrl ==
                                                          null
                                                      ? Text(
                                                          member.avatarInitial,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 28,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        )
                                                      : null,
                                                ),
                                                if (member.isPresentToday)
                                                  Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: Container(
                                                      width: 18,
                                                      height: 18,
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(width: 16),

                                            // Member Info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    member.displayNameWithRole,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black87,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    member.email ?? 'No email',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: isDark
                                                          ? Colors.white70
                                                          : Colors.grey[700],
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    member.quickStats,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Status Badge
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: member.statusColor
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                member.statusBadgeText,
                                                style: TextStyle(
                                                  color: member.statusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                  loading: () => Column(
                    children: List.generate(
                      5,
                      (_) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: isDark
                              ? Colors.grey[800]!
                              : Colors.grey[300]!,
                          highlightColor: isDark
                              ? Colors.grey[700]!
                              : Colors.grey[100]!,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const SizedBox(height: 120),
                          ),
                        ),
                      ),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load team members',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check your connection',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => ref.invalidate(teamMembersProvider),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
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

// // lib/features/team/presentation/screens/team_member_list_screen.dart
// import 'package:appattendance/core/utils/app_colors.dart';
// import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
// import 'package:appattendance/features/team/domain/models/team_member.dart';
// import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
// import 'package:appattendance/features/team/presentation/screens/team_member_detail_screen.dart';
// import 'package:appattendance/features/team/presentation/widgets/commons/member_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TeamMemberListScreen extends ConsumerStatefulWidget {
//   const TeamMemberListScreen({super.key});

//   @override
//   ConsumerState<TeamMemberListScreen> createState() =>
//       _TeamMemberListScreenState();
// }

// class _TeamMemberListScreenState extends ConsumerState<TeamMemberListScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       ref.read(teamSearchQueryProvider.notifier).state = _searchController.text
//           .trim();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userAsync = ref.watch(authProvider);
//     final teamAsync = ref.watch(searchedTeamMembersProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Team Members'),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Column(
//         children: [
//           // Search & Filter Bar
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search team members...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 IconButton(
//                   icon: const Icon(Icons.filter_list),
//                   onPressed: () {
//                     // TODO: Open filter bottom sheet (department, status, etc.)
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Filter coming soon...')),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Result count
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: teamAsync.when(
//                 data: (members) => Text(
//                   '${members.length} members found',
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//                 loading: () => const SizedBox(),
//                 error: (_, __) => const Text('Error'),
//               ),
//             ),
//           ),

//           const SizedBox(height: 8),

//           // Members List
//           Expanded(
//             child: teamAsync.when(
//               data: (members) => members.isEmpty
//                   ? const Center(child: Text('No team members found'))
//                   : ListView.builder(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       itemCount: members.length,
//                       itemBuilder: (context, index) {
//                         final member = members[index];
//                         return MemberCard(
//                           member: member,
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     TeamMemberDetailScreen(empId: member.empId),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (e, _) => Center(child: Text('Error: $e')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
