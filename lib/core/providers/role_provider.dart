// lib/core/providers/role_provider.dart
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleNotifier extends StateNotifier<UserModel?> {
  RoleNotifier() : super(null);

  void setUser(UserModel? user) => state = user;

  bool get isManager => state?.isManager == true;
  bool get isEmployee => state?.isEmployee == true;
  bool get isLoggedIn => state != null;
}

final roleProvider = StateNotifierProvider<RoleNotifier, UserModel?>((ref) {
  return RoleNotifier();
});
