import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tasks/providers/task_providers.dart';
import '../../tasks/view/task_edit_sheet.dart';
import '../../tasks/view/task_list_item.dart';

class SelectTaskForNoteSheet extends ConsumerWidget {
  const SelectTaskForNoteSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksStreamProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '选择关联任务',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => _openCreateTask(context),
                  child: const Text('新增任务'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(
              child: tasksAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('加载失败：$error')),
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Center(child: Text('暂无任务，请先新增一条任务'));
                  }

                  final openTasks =
                      tasks.where((t) => t.status != domain.TaskStatus.done).toList();
                  final doneTasks =
                      tasks.where((t) => t.status == domain.TaskStatus.done).toList();

                  return ListView(
                    shrinkWrap: true,
                    children: [
                      if (openTasks.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '未完成',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                        for (final task in openTasks) ...[
                          TaskListItem(
                            task: task,
                            onTap: () => Navigator.of(context).pop(task.id),
                          ),
                          const Divider(height: 0),
                        ],
                      ],
                      if (doneTasks.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '已完成',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                        for (final task in doneTasks) ...[
                          TaskListItem(
                            task: task,
                            onTap: () => Navigator.of(context).pop(task.id),
                          ),
                          const Divider(height: 0),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateTask(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const TaskEditSheet(),
    );
  }
}

