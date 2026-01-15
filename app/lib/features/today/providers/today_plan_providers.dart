import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';

final todayPlanTaskIdsProvider = StreamProvider<List<String>>((ref) {
  final now = DateTime.now();
  final day = DateTime(now.year, now.month, now.day);
  return ref.watch(todayPlanRepositoryProvider).watchTaskIdsForDay(day: day);
});

