// lib/features/regularisation/presentation/providers/regularisation_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegularisationState {
  final List<Map<String, dynamic>> requests;
  final bool isLoading;

  const RegularisationState({this.requests = const [], this.isLoading = false});

  // YE METHOD ADD KAR DE — copyWith()
  RegularisationState copyWith({
    List<Map<String, dynamic>>? requests,
    bool? isLoading,
  }) {
    return RegularisationState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final regularisationProvider =
    StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
      return RegularisationNotifier();
    });

class RegularisationNotifier extends StateNotifier<RegularisationState> {
  RegularisationNotifier() : super(const RegularisationState()) {
    loadRequests();
  }

  Future<void> loadRequests() async {
    state = state.copyWith(isLoading: true); // AB YE CHALEGA!

    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(
      isLoading: false,
      requests: [
        {
          'id': 'R001',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'type': 'Late Check-in',
          'status': 'Pending',
          'reason': 'Traffic jam',
        },
        {
          'id': 'R002',
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'type': 'Early Checkout',
          'status': 'Approved',
          'reason': 'Doctor appointment',
        },
      ],
    );
  }
}

// // lib/features/regularisation/presentation/providers/regularisation_notifier.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RegularisationState {
//   final List<Map<String, dynamic>> requests;
//   final bool isLoading;

//   RegularisationState({this.requests = const [], this.isLoading = false});
// }

// final regularisationProvider =
//     StateNotifierProvider<RegularisationNotifier, RegularisationState>((ref) {
//       return RegularisationNotifier();
//     });

// class RegularisationNotifier extends StateNotifier<RegularisationState> {
//   RegularisationNotifier() : super(RegularisationState()) {
//     loadRequests();
//   }

//   Future<void> loadRequests() async {
//     state = state.copyWith(isLoading: true);
//     await Future.delayed(const Duration(seconds: 1));
//     state = RegularisationState(
//       requests: [
//         {
//           'id': 'R001',
//           'date': DateTime.now().subtract(const Duration(days: 2)),
//           'type': 'Late Check-in',
//           'status': 'Pending',
//           'reason': 'Traffic jam',
//         },
//       ],
//     );
//   }
// }
