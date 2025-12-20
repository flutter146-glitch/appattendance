// lib/core/providers/view_mode_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ViewMode { manager, employee }

final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.manager);

// lib/core/providers/selected_employee_provider.dart
final selectedEmployeeIdProvider = StateProvider<String?>((ref) => null);
