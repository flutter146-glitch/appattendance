// lib/features/auth/presentation/providers/auth_notifier.dart
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/providers/role_provider.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final userMap = await DBHelper.instance.getUser();
    if (userMap == null) return null;
    return UserModel.fromJson(userMap);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Simulate API/DB login
      await Future.delayed(const Duration(seconds: 1));

      // Dummy check
      if (email == "employee@nutantek.com" && password == "123456") {
        final user = UserModel(
          id: "1",
          email: email,
          name: "Vainyala Samal",
          role: UserRole.employee,
          department: "Mobile Dev",
          token: "dummy-jwt-token-123456",
          projects: [],
        );
        await DBHelper.instance.saveUser(user.toJson());
        ref.read(roleProvider.notifier).setUser(user);
        return user;
      }

      if (email == "manager@nutantek.com" && password == "manager123") {
        final user = UserModel(
          id: "2",
          email: email,
          name: "Raj Sharma",
          role: UserRole.manager,
          department: "Management",
          projects: [],
        );
        await DBHelper.instance.saveUser(user.toJson());
        ref.read(roleProvider.notifier).setUser(user);
        return user;
      }

      throw "Invalid credentials";
    });
  }

  Future<void> logout() async {
    await DBHelper.instance.clearUser();
    state = const AsyncData(null);
    ref.read(roleProvider.notifier).setUser(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});
