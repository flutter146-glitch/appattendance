// lib/core/providers/view_mode_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ViewMode { manager, employee }

final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.manager);

// Agar tu Notifier class chahta hai (optional, zyada boilerplate)
// Dartclass ViewModeNotifier extends StateNotifier<ViewMode> {
//   ViewModeNotifier() : super(ViewMode.manager);

//   void toggle() {
//     state = state == ViewMode.manager ? ViewMode.employee : ViewMode.manager;
//   }

//   void setManager() => state = ViewMode.manager;
//   void setEmployee() => state = ViewMode.employee;
// }

// final viewModeProvider = StateNotifierProvider<ViewModeNotifier, ViewMode>((ref) {
//   return ViewModeNotifier();
// });
