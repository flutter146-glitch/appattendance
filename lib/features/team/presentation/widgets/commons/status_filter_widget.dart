// lib/features/team/presentation/widgets/commons/status_filter_widget.dart
import 'package:appattendance/features/team/domain/models/team_member.dart';
import 'package:appattendance/features/team/presentation/providers/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusFilterWidget extends ConsumerWidget {
  const StatusFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(memberStatusFilterProvider);

    return PopupMenuButton<MemberStatusFilter>(
      icon: const Icon(Icons.filter_list_rounded),
      tooltip: 'Filter by status',
      initialValue: currentFilter,
      onSelected: (filter) {
        ref.read(memberStatusFilterProvider.notifier).state = filter;
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: MemberStatusFilter.all,
          child: Text('All Members'),
        ),
        const PopupMenuItem(
          value: MemberStatusFilter.active,
          child: Text('Active Only'),
        ),
        const PopupMenuItem(
          value: MemberStatusFilter.inactive,
          child: Text('Inactive Only'),
        ),
      ],
    );
  }
}
