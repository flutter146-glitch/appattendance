import 'package:appattendance/core/theme/theme_color.dart';
import 'package:appattendance/features/auth/presentation/providers/auth_provider.dart';
import 'package:appattendance/features/projects/domain/models/project_model.dart';
import 'package:appattendance/features/projects/presentation/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ActiveProjectsWidget extends ConsumerWidget {
  const ActiveProjectsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeColors(context);
    final userAsync = ref.watch(authProvider);
    final projectsAsync = ref.watch(
      allProjectsProvider,
    ); // ya team/mapped jo use kar rahe ho

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Projects',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No active projects',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textSecondary,
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];

                  // Progress color based on %
                  final progressColor = project.progress >= 70
                      ? theme.success
                      : project.progress >= 40
                      ? theme.warning
                      : theme.error;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: theme.isDark ? 1 : 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: theme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + ACTIVE chip
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  project.projectName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.success.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: TextStyle(
                                    color: theme.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Description
                          Text(
                            project.projectDescription ??
                                'Development of new platform with modern features',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 16),

                          // Progress Bar + %
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: project.progress / 100,
                                    minHeight: 12,
                                    backgroundColor: theme.surfaceVariant,
                                    valueColor: AlwaysStoppedAnimation(
                                      progressColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${project.progress.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: progressColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Bottom Stats Row (Team, Tasks, Days Left)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildBottomStat(
                                Icons.people_alt_rounded,
                                '${project.teamSize ?? 3}',
                                'Team',
                                theme,
                              ),
                              _buildBottomStat(
                                Icons.list_alt_rounded,
                                '${project.totalTasks ?? 3}',
                                'Tasks',
                                theme,
                              ),
                              _buildBottomStat(
                                Icons.calendar_today_rounded,
                                project.daysLeftDisplay,
                                'Days Left',
                                theme,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },

            loading: () => Column(
              children: List.generate(
                2,
                (_) => Shimmer.fromColors(
                  baseColor: theme.isDark
                      ? Colors.grey[800]!
                      : Colors.grey[300]!,
                  highlightColor: theme.isDark
                      ? Colors.grey[700]!
                      : Colors.grey[100]!,
                  child: Container(
                    height: 180,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),

            error: (_, __) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Failed to load projects',
                  style: TextStyle(color: theme.error, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStat(
    IconData icon,
    String value,
    String label,
    ThemeColors theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.textSecondary),
        const SizedBox(width: 6),
        Text(
          '$value $label',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: theme.textPrimary,
          ),
        ),
      ],
    );
  }
}
