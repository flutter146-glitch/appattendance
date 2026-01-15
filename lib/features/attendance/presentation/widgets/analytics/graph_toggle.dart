// lib/features/attendance/presentation/widgets/stylish_toggle_widget.dart
import 'dart:ui';

import 'package:appattendance/features/attendance/presentation/providers/analytics_provider.dart';
import 'package:appattendance/features/auth/domain/models/user_extension.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToggleWidget extends ConsumerWidget {
  final WidgetRef ref;
  final bool isManager;

  const ToggleWidget({super.key, required this.ref, required this.isManager});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentView = ref.watch(analyticsViewProvider);

    // Force re-evaluate isManager from authProvider every rebuild
    final user = ref.watch(authProvider).value;
    final effectiveIsManager = user?.isManagerial ?? isManager;

    // Options based on effective role
    final options = effectiveIsManager
        ? [
            {
              'view': AnalyticsView.mergeGraph,
              'label': 'Merge',
              'icon': Icons.merge_type_rounded,
            },
            {
              'view': AnalyticsView.employeeOverview,
              'label': 'Team',
              'icon': Icons.people_alt_rounded,
            },
            {
              'view': AnalyticsView.activeProjects,
              'label': 'Projects',
              'icon': Icons.business_center_rounded,
            },
          ]
        : [
            {
              'view': AnalyticsView.employeeOverview,
              'label': 'Overview',
              'icon': Icons.person_rounded,
            },
            {
              'view': AnalyticsView.activeProjects,
              'label': 'Projects',
              'icon': Icons.business_center_rounded,
            },
          ];

    // If employee and current view is Merge Graph → auto switch to Overview
    if (!effectiveIsManager && currentView == AnalyticsView.mergeGraph) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(analyticsViewProvider.notifier).state =
            AnalyticsView.employeeOverview;
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.12),
                blurRadius: 10,
                spreadRadius: -2,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(options.length, (index) {
                    final item = options[index];
                    final v = item['view'] as AnalyticsView;
                    final label = item['label'] as String;
                    final icon = item['icon'] as IconData;
                    final isSelected = currentView == v;

                    final gradient = isSelected
                        ? LinearGradient(
                            colors: v == AnalyticsView.employeeOverview
                                ? [
                                    Colors.orange.shade400,
                                    Colors.deepOrange.shade600,
                                  ]
                                : [
                                    Colors.blue.shade400,
                                    Colors.indigo.shade600,
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null;

                    return GestureDetector(
                      onTap: () =>
                          ref.read(analyticsViewProvider.notifier).state = v,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color:
                                        (v == AnalyticsView.employeeOverview
                                                ? Colors.orange
                                                : Colors.blue)
                                            .withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    spreadRadius: -2,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    offset: const Offset(-2, -2),
                                    blurRadius: 4,
                                    spreadRadius: -2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: isSelected ? Colors.white : Colors.white70,
                              shadows: isSelected
                                  ? [
                                      Shadow(
                                        color: Colors.white.withOpacity(0.6),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
