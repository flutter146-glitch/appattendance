// lib/features/regularisation/presentation/providers/regularisation_filter_provider.dart

import 'package:appattendance/features/regularisation/presentation/widgets/common/regularisation_filter_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final regularisationFilterProvider = StateProvider<RegularisationFilter>(
  (ref) => RegularisationFilter.all,
);
