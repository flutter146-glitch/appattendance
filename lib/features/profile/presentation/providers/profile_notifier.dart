// lib/features/profile/presentation/providers/profile_notifier.dart
import 'package:appattendance/core/database/db_helper.dart';
import 'package:appattendance/core/providers/role_provider.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserModel?>>((ref) {
      return ProfileNotifier(ref);
    });

class ProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  ProfileNotifier(this.ref) : super(const AsyncLoading()) {
    loadProfile();
  }

  final Ref ref;

  Future<void> loadProfile() async {
    final user = ref.read(roleProvider);
    if (user != null) {
      state = AsyncData(user);
    }
  }

  Future<void> updateProfile(String phone, String emergency) async {
    final user = state.value;
    if (user == null) return;

    final updated = user.copyWith(
      phone: phone,
      // Add emergency contact field if needed
    );

    // Save to DB
    await DBHelper.instance.saveUser(updated.toJson());
    ref.read(roleProvider.notifier).setUser(updated);
    state = AsyncData(updated);
  }
}
