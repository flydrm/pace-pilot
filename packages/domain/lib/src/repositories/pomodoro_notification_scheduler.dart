abstract interface class PomodoroNotificationScheduler {
  Future<void> schedulePomodoroEnd({
    required String taskId,
    required String taskTitle,
    required DateTime endAt,
    required bool playSound,
    required bool enableVibration,
  });

  Future<void> cancelPomodoroEnd();
}
