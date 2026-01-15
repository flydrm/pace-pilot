import '../entities/task.dart';

abstract interface class TaskRepository {
  Stream<List<Task>> watchAllTasks();
  Future<Task?> getTaskById(String taskId);
  Future<void> upsertTask(Task task);
  Future<void> deleteTask(String taskId);
}
