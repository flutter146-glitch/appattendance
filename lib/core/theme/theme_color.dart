// lib/core/utils/theme_colors.dart

import 'package:appattendance/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeColors {
  final BuildContext context;

  ThemeColors(this.context);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  // Primary Colors
  Color get primary => isDark ? AppColors.primaryLight : AppColors.primary;
  Color get primaryContainer =>
      isDark ? AppColors.primary : AppColors.primaryLight;
  Color get onPrimary => AppColors.white;

  // Secondary Colors
  Color get secondary =>
      isDark ? AppColors.secondaryLight : AppColors.secondary;
  Color get onSecondary => AppColors.white;

  // Background & Surface
  Color get background =>
      isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get surface => isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get surfaceVariant =>
      isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
  Color get onSurface => isDark ? AppColors.textInverse : AppColors.textPrimary;

  // Text Colors
  Color get textPrimary =>
      isDark ? AppColors.textInverse : AppColors.textPrimary;
  Color get textSecondary =>
      isDark ? AppColors.grey400 : AppColors.textSecondary;
  Color get textDisabled => isDark ? AppColors.grey500 : AppColors.textDisabled;
  Color get textHint => isDark ? AppColors.grey600 : AppColors.grey400;

  // Semantic Colors
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get error => AppColors.error;
  Color get info => AppColors.info;

  // Card & Container
  Color get cardBackground => isDark ? AppColors.grey800 : AppColors.white;
  Color get divider => isDark ? AppColors.grey700 : AppColors.grey300;
  // Add inside ThemeColors class

  Color get accent => isDark ? AppColors.accentLight : AppColors.accent;
  // Icon Colors
  Color get iconPrimary => isDark ? AppColors.white : AppColors.grey800;
  Color get iconSecondary => isDark ? AppColors.grey400 : AppColors.grey600;

  // Pie Chart & Stats
  Color get presentColor => Colors.green;
  Color get lateColor => Colors.orange;
  Color get absentColor => Colors.red;
  Color get onTimeColor => Colors.teal;
  Color get leaveColor => Colors.blue;

  // Button States
  Color get buttonDisabled => isDark ? AppColors.grey700 : AppColors.grey300;
}
