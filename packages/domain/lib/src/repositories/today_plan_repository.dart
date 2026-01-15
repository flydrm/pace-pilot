abstract interface class TodayPlanRepository {
  Stream<List<String>> watchTaskIdsForDay({required DateTime day});

  Future<void> addTask({
    required DateTime day,
    required String taskId,
  });

  Future<void> removeTask({
    required DateTime day,
    required String taskId,
  });

  Future<void> replaceTasks({
    required DateTime day,
    required List<String> taskIds,
  });

  Future<void> clearDay({required DateTime day});
}

