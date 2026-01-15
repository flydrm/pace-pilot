import '../value_objects/checklist_item_title.dart';

class TaskChecklistItem {
  const TaskChecklistItem({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
    required this.orderIndex,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String taskId;
  final ChecklistItemTitle title;
  final bool isDone;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskChecklistItem copyWith({
    ChecklistItemTitle? title,
    bool? isDone,
    int? orderIndex,
    DateTime? updatedAt,
  }) {
    return TaskChecklistItem(
      id: id,
      taskId: taskId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
