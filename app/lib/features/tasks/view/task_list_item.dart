import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({super.key, required this.task, required this.onTap});

  final domain.Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dueAt = task.dueAt;
    final dueText = dueAt == null ? null : '${dueAt.month}/${dueAt.day}';

    return ListTile(
      title: Text(task.title.value, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: _buildSubtitle(dueText),
      trailing: _buildPriorityIcon(task.priority),
      onTap: onTap,
    );
  }

  Widget? _buildSubtitle(String? dueText) {
    final parts = <String>[];
    if (dueText != null) parts.add('到期 $dueText');
    if (task.tags.isNotEmpty) parts.add(task.tags.take(3).join(' · '));
    if (parts.isEmpty) return null;
    return Text(parts.join('  ·  '), maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  Widget _buildPriorityIcon(domain.TaskPriority priority) {
    return switch (priority) {
      domain.TaskPriority.high => const Icon(Icons.priority_high),
      domain.TaskPriority.medium => const Icon(Icons.drag_handle),
      domain.TaskPriority.low => const Icon(Icons.arrow_downward),
    };
  }
}

