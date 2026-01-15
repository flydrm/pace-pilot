import '../entities/task_checklist_item.dart';

abstract interface class TaskChecklistRepository {
  Stream<List<TaskChecklistItem>> watchByTaskId(String taskId);
  Future<void> upsertItem(TaskChecklistItem item);
  Future<void> deleteItem(String itemId);
}
