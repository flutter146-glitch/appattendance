// lib/core/providers/app_state_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState {
  final bool isLoading;
  final String? message;

  AppState({this.isLoading = false, this.message});
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((
  ref,
) {
  return AppStateNotifier();
});

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void showLoading(String msg) =>
      state = AppState(isLoading: true, message: msg);
  void hideLoading() => state = AppState();
  void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
