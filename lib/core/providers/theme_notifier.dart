// lib/core/providers/theme_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme') ?? 'system';
    state = saved == 'dark'
        ? ThemeMode.dark
        : saved == 'light'
        ? ThemeMode.light
        : ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme',
      mode == ThemeMode.dark
          ? 'dark'
          : mode == ThemeMode.light
          ? 'light'
          : 'system',
    );
  }

  void toggle() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      setTheme(ThemeMode.system);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}
