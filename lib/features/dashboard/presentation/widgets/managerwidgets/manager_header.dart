// lib/features/dashboard/presentation/widgets/manager/manager_header.dart
import 'package:flutter/material.dart';
import 'package:appattendance/core/utils/app_colors.dart';
import 'package:appattendance/features/auth/domain/models/user_model.dart';

class ManagerHeader extends StatelessWidget {
  final UserModel user;
  const ManagerHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white24,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Welcome back,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(user.email, style: const TextStyle(color: Colors.white60, fontSize: 14)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: const Text("MANAGER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28)),
            ],
          ),
          const SizedBox(height: 30),
          const Text("TUESDAY, 9 DECEMBER 2025", style:53:26", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w300)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
            child: const Text("LIVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}