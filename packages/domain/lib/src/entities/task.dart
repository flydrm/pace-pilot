import '../value_objects/task_title.dart';

enum TaskStatus { todo, inProgress, done }

enum TaskPriority { low, medium, high }

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
    required this.tags,
    required this.estimatedPomodoros,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.dueAt,
  });

  final String id;
  final TaskTitle title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueAt;
  final List<String> tags;
  final int? estimatedPomodoros;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task copyWith({
    TaskTitle? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueAt,
    List<String>? tags,
    int? estimatedPomodoros,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueAt: dueAt ?? this.dueAt,
      tags: tags ?? this.tags,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
