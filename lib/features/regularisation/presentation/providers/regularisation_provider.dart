// lib/features/regularisation/presentation/providers/regularisation_provider.dart

import 'package:appattendance/features/regularisation/presentation/providers/regularisation_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final regularisationProvider =
    StateNotifierProvider<RegularisationNotifier, RegularisationState>(
      (ref) => RegularisationNotifier(ref),
    );
