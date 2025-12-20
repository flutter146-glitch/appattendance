import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 7,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(),
        height: 65,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.5),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.3),
            //   blurRadius: 10,
            //   offset: const Offset(0, -2),
            // ),
          ],
          border: Border.all(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavButton(
              icon: Icons.dashboard_rounded,
              label: 'DASHBOARD',
              index: 0,
              isSelected: currentIndex == 0,
            ),
            _buildNavButton(
              icon: Icons.calendar_today_rounded,
              label: 'REGULARIZATION',
              index: 1,
              isSelected: currentIndex == 1,
            ),
            _buildNavButton(
              icon: Icons.beach_access_rounded,
              label: 'LEAVE',
              index: 2,
              isSelected: currentIndex == 2,
            ),
            _buildNavButton(
              icon: Icons.timeline_rounded,
              label: 'TIMESHEET',
              index: 3,
              isSelected: currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabChanged(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.15) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? Colors.lightGreenAccent
                      : Colors.white.withOpacity(0.7),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
