import 'dart:async';

import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../focus/view/select_task_sheet.dart';
import '../../tasks/providers/task_providers.dart';
import '../providers/today_plan_providers.dart';

class TodayPlanEditSheet extends ConsumerWidget {
  const TodayPlanEditSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksStreamProvider);
    final planIdsAsync = ref.watch(todayPlanTaskIdsProvider);

    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);

    final tasks = tasksAsync.valueOrNull ?? const <domain.Task>[];
    final byId = {for (final t in tasks) t.id: t};
    final planIds = planIdsAsync.valueOrNull ?? const <String>[];
    final planTasks = <domain.Task>[
      for (final id in planIds)
        if (byId[id] != null) byId[id]!,
    ];

    final suggested = const domain.TodayQueueRule(maxItems: 5)(tasks, now).todayQueue;

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '编辑今天计划',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '拖拽排序；从“添加任务”或“用建议填充”开始。',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => _addTask(context, ref, day),
                    icon: const Icon(Icons.add),
                    label: const Text('添加任务'),
                  ),
                  OutlinedButton.icon(
                    onPressed: suggested.isEmpty
                        ? null
                        : () => _replaceWithSuggested(context, ref, day, suggested),
                    icon: const Icon(Icons.auto_fix_high_outlined),
                    label: const Text('用建议填充'),
                  ),
                  TextButton(
                    onPressed: planIds.isEmpty ? null : () => _clear(context, ref, day),
                    child: const Text('清空'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: planIdsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('加载失败：$error')),
                  data: (_) {
                    if (tasksAsync.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (tasksAsync.hasError) {
                      return Center(child: Text('任务加载失败：${tasksAsync.error}'));
                    }
                    if (planIds.isEmpty) {
                      return const Center(child: Text('今天还没有计划任务'));
                    }

                    return ReorderableListView.builder(
                      itemCount: planTasks.length,
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final ids = planTasks.map((t) => t.id).toList();
                        final moved = ids.removeAt(oldIndex);
                        ids.insert(newIndex, moved);
                        unawaited(
                          ref.read(todayPlanRepositoryProvider).replaceTasks(day: day, taskIds: ids),
                        );
                      },
                      itemBuilder: (context, index) {
                        final task = planTasks[index];
                        return ListTile(
                          key: ValueKey('today_plan_item:${task.id}'),
                          title: Text(
                            task.title.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: _subtitleFor(task),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: '移除',
                                onPressed: () {
                                  unawaited(
                                    ref
                                        .read(todayPlanRepositoryProvider)
                                        .removeTask(day: day, taskId: task.id),
                                  );
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              ReorderableDragStartListener(
                                index: index,
                                child: const Icon(Icons.drag_handle),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addTask(BuildContext context, WidgetRef ref, DateTime day) async {
    final taskId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const SelectTaskSheet(),
    );
    if (taskId == null) return;
    await ref.read(todayPlanRepositoryProvider).addTask(day: day, taskId: taskId);
  }

  Future<void> _replaceWithSuggested(
    BuildContext context,
    WidgetRef ref,
    DateTime day,
    List<domain.Task> suggested,
  ) async {
    final ids = suggested.map((t) => t.id).toList();
    await ref.read(todayPlanRepositoryProvider).replaceTasks(day: day, taskIds: ids);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已填充 ${ids.length} 条计划')),
    );
  }

  Future<void> _clear(BuildContext context, WidgetRef ref, DateTime day) async {
    await ref.read(todayPlanRepositoryProvider).clearDay(day: day);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已清空今天计划')),
    );
  }

  Widget? _subtitleFor(domain.Task task) {
    final dueAt = task.dueAt;
    final dueText = dueAt == null ? null : '${dueAt.month}/${dueAt.day}';

    final parts = <String>[];
    if (dueText != null) parts.add('到期 $dueText');
    if (task.tags.isNotEmpty) parts.add(task.tags.take(3).join(' · '));
    if (parts.isEmpty) return null;
    return Text(parts.join('  ·  '), maxLines: 1, overflow: TextOverflow.ellipsis);
  }
}
