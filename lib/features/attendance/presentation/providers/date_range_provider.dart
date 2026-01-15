// lib/features/attendance/presentation/providers/date_range_provider.dart
// New provider for selected date range (for filtering)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final dateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);
