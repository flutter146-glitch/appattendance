import 'package:appattendance/core/database/db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbHelperProvider = Provider<DBHelper>((ref) {
  return DBHelper.instance;
});
