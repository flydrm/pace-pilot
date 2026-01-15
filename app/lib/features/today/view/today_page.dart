import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../../core/providers/app_providers.dart';
import '../../focus/providers/focus_providers.dart';
import '../../tasks/providers/task_providers.dart';
import '../../tasks/view/task_list_item.dart';
import '../providers/today_plan_providers.dart';
import 'today_plan_edit_sheet.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  final TextEditingController _quickAddController = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _quickAddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksStreamProvider);
    final sessionsAsync = ref.watch(todayPomodoroSessionsProvider);
    final yesterdaySessionsAsync = ref.watch(yesterdayPomodoroSessionsProvider);
    final planIdsAsync = ref.watch(todayPlanTaskIdsProvider);
    final configAsync = ref.watch(pomodoroConfigProvider);
    final workMinutes = configAsync.maybeWhen(
      data: (c) => c.workDurationMinutes,
      orElse: () => 25,
    );
    final tasks = tasksAsync.valueOrNull ?? const <domain.Task>[];
    final byId = {for (final t in tasks) t.id: t};
    final planIds = planIdsAsync.valueOrNull ?? const <String>[];
    final planTasks = <domain.Task>[
      for (final id in planIds)
        if (byId[id] != null) byId[id]!,
    ];

    return AppPageScaffold(
      title: '今天',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _QuickAddCard(
            controller: _quickAddController,
            enabled: !_adding,
            onSubmit: () => _submitQuickAdd(context),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/ai/breakdown'),
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: const Text('AI 拆任务'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/tasks'),
                  icon: const Icon(Icons.list_alt_outlined),
                  label: const Text('任务列表'),
                ),
              ),
            ],
          ),
          if (tasksAsync.isLoading) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ] else if (tasksAsync.hasError) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.error_outline),
                title: const Text('任务加载失败'),
                subtitle: Text('${tasksAsync.error}'),
              ),
            ),
          ],
          const SizedBox(height: 16),
          _TodayFocusCard(
            tasks: tasks,
            sessionsAsync: sessionsAsync,
            workMinutes: workMinutes,
          ),
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              final rule = const domain.TodayQueueRule(maxItems: 5);
              final result = rule(tasks, DateTime.now());
              final nextStep = planTasks.isNotEmpty ? planTasks.first : result.nextStep;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionTitle('下一步'),
                  const SizedBox(height: 8),
                  _NextStepCard(task: nextStep),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(child: _SectionTitle('今天计划')),
                      TextButton.icon(
                        onPressed: () => context.push('/ai/today-plan'),
                        icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                        label: const Text('AI 草稿'),
                      ),
                      IconButton(
                        tooltip: '编辑今天计划',
                        onPressed: () => _openPlanEditor(context),
                        icon: const Icon(Icons.tune_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (planIdsAsync.isLoading)
                    const LinearProgressIndicator()
                  else if (planIdsAsync.hasError)
                    Text('今天计划加载失败：${planIdsAsync.error}')
                  else if (planTasks.isNotEmpty)
                    Card(
                      child: Column(
                        children: [
                          for (final task in planTasks)
                            TaskListItem(
                              task: task,
                              onTap: () => context.push('/tasks/${task.id}'),
                            ),
                        ],
                      ),
                    )
                  else if (tasksAsync.isLoading)
                    const Text('加载中…')
                  else if (result.todayQueue.isEmpty)
                    const Text('今天还没有可执行任务。去添加一条，或用 AI 拆任务更快。')
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('还没有“今天计划”。'),
                            const SizedBox(height: 8),
                            FilledButton.tonal(
                              onPressed: () => _fillPlanFromSuggested(
                                context,
                                result.todayQueue,
                              ),
                              child: const Text('用建议填充（可编辑）'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const _SectionTitle('昨天回顾'),
          const SizedBox(height: 8),
          _YesterdayReviewCard(
            tasks: tasks,
            sessionsAsync: yesterdaySessionsAsync,
          ),
        ],
      ),
    );
  }

  Future<void> _submitQuickAdd(BuildContext context) async {
    final title = _quickAddController.text.trim();
    if (title.isEmpty) return;

    setState(() => _adding = true);
    try {
      await ref.read(createTaskUseCaseProvider)(title: title);
      _quickAddController.clear();
    } on domain.TaskTitleEmptyException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('标题不能为空')),
      );
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  Future<void> _openPlanEditor(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const TodayPlanEditSheet(),
    );
  }

  Future<void> _fillPlanFromSuggested(
    BuildContext context,
    List<domain.Task> suggested,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final ids = suggested.map((t) => t.id).toList();
    await ref.read(todayPlanRepositoryProvider).replaceTasks(day: day, taskIds: ids);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已填充 ${ids.length} 条计划')),
    );
    await _openPlanEditor(context);
  }
}

class _TodayFocusCard extends StatelessWidget {
  const _TodayFocusCard({
    required this.tasks,
    required this.sessionsAsync,
    required this.workMinutes,
  });

  final List<domain.Task> tasks;
  final AsyncValue<List<domain.PomodoroSession>> sessionsAsync;
  final int workMinutes;

  @override
  Widget build(BuildContext context) {
    return sessionsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (sessions) {
        if (sessions.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '今日专注',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text('还没有专注记录。开始一个 ${workMinutes}min 番茄，今天会更“在掌控中”。'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go('/focus'),
                    child: const Text('去专注'),
                  ),
                ],
              ),
            ),
          );
        }

        final byId = {for (final t in tasks) t.id: t};
        final totalMinutes = sessions.fold<int>(0, (sum, s) => sum + s.duration.inMinutes);
        final draftCount = sessions.where((s) => s.isDraft).length;

        final minutesByTask = <String, int>{};
        final countByTask = <String, int>{};
        for (final s in sessions) {
          minutesByTask[s.taskId] = (minutesByTask[s.taskId] ?? 0) + s.duration.inMinutes;
          countByTask[s.taskId] = (countByTask[s.taskId] ?? 0) + 1;
        }

        String? topTaskId;
        var topMinutes = -1;
        for (final entry in minutesByTask.entries) {
          if (entry.value > topMinutes) {
            topMinutes = entry.value;
            topTaskId = entry.key;
          }
        }

        final topTask = topTaskId == null ? null : byId[topTaskId];
        final topCount = topTaskId == null ? null : countByTask[topTaskId];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '今日专注',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text('番茄 ${sessions.length}'),
                  ],
                ),
                const SizedBox(height: 8),
                Text('总计 ${totalMinutes}min'),
                if (topTask != null && topCount != null) ...[
                  const SizedBox(height: 4),
                  Text('最专注：${topTask.title.value} · $topCount 个 · ${topMinutes}min'),
                ],
                if (draftCount > 0) ...[
                  const SizedBox(height: 4),
                  Text('待补草稿：$draftCount', style: const TextStyle(color: Colors.black54)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickAddCard extends StatelessWidget {
  const _QuickAddCard({
    required this.controller,
    required this.enabled,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '快速新增',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              enabled: enabled,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.add_task),
                hintText: '输入一句话创建任务…',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onSubmit(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard({required this.task});

  final domain.Task? task;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('还没有“下一步”。'),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => context.go('/tasks'),
                child: const Text('去添加任务'),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              task!.title.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.push('/tasks/${task!.id}'),
                    child: const Text('查看详情'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.go('/focus?taskId=${task!.id}'),
                    child: const Text('开始专注'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _YesterdayReviewCard extends StatelessWidget {
  const _YesterdayReviewCard({
    required this.tasks,
    required this.sessionsAsync,
  });

  final List<domain.Task> tasks;
  final AsyncValue<List<domain.PomodoroSession>> sessionsAsync;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final start = todayStart.subtract(const Duration(days: 1));
    final end = todayStart;

    final completedTasks = tasks.where((t) {
      if (t.status != domain.TaskStatus.done) return false;
      return !t.updatedAt.isBefore(start) && t.updatedAt.isBefore(end);
    }).toList(growable: false);

    return Card(
      child: ExpansionTile(
        title: const Text('展开查看'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          sessionsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, st) => Text('专注记录加载失败：$e'),
            data: (sessions) {
              final totalMinutes =
                  sessions.fold<int>(0, (sum, s) => sum + s.duration.inMinutes);
              final draftCount = sessions.where((s) => s.isDraft).length;

              final byTask = <String, int>{};
              for (final s in sessions) {
                byTask[s.taskId] = (byTask[s.taskId] ?? 0) + s.duration.inMinutes;
              }

              String? topTaskId;
              var topMinutes = -1;
              for (final entry in byTask.entries) {
                if (entry.value > topMinutes) {
                  topMinutes = entry.value;
                  topTaskId = entry.key;
                }
              }

              final byId = {for (final t in tasks) t.id: t};
              final topTask = topTaskId == null ? null : byId[topTaskId];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('完成任务：${completedTasks.length}'),
                  const SizedBox(height: 4),
                  Text('专注番茄：${sessions.length} · 总计 ${totalMinutes}min'),
                  if (draftCount > 0) ...[
                    const SizedBox(height: 4),
                    Text('待补草稿：$draftCount', style: const TextStyle(color: Colors.black54)),
                  ],
                  if (topTaskId != null && topTask != null) ...[
                    const SizedBox(height: 4),
                    Text('最专注：${topTask.title.value} · ${topMinutes}min'),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/ai/daily'),
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Text('AI 总结昨天（可编辑后保存为笔记）'),
                  ),
                  if (completedTasks.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      '昨天完成',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    for (final task in completedTasks.take(5))
                      ListTile(
                        title: Text(
                          task.title.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/tasks/${task.id}'),
                        dense: true,
                      ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
