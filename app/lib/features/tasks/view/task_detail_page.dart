import 'dart:math' as math;

import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../focus/providers/focus_providers.dart';
import '../../notes/providers/note_providers.dart';
import '../../notes/view/note_edit_sheet.dart';
import '../../today/providers/today_plan_providers.dart';
import '../providers/task_providers.dart';
import 'task_edit_sheet.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  const TaskDetailPage({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  final TextEditingController _newChecklistController = TextEditingController();

  @override
  void dispose() {
    _newChecklistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskByIdProvider(widget.taskId));
    return taskAsync.when(
      loading: () => const AppPageScaffold(
        title: '任务详情',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => AppPageScaffold(
        title: '任务详情',
        body: Center(child: Text('加载失败：$error')),
      ),
      data: (task) {
        if (task == null) {
          return const AppPageScaffold(
            title: '任务详情',
            body: Center(child: Text('任务不存在或已删除')),
          );
        }

        final planIdsAsync = ref.watch(todayPlanTaskIdsProvider);
        final planIds = planIdsAsync.valueOrNull ?? const <String>[];
        final inTodayPlan = planIds.contains(task.id);

        return AppPageScaffold(
          title: task.title.value,
          actions: [
            IconButton(
              tooltip: '删除',
              onPressed: () => _confirmDelete(context, task.id),
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              tooltip: '编辑',
              onPressed: () => _openEditSheet(context, task),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _TaskSummaryCard(task: task),
              const SizedBox(height: 12),
              _buildChecklistSection(task),
              const SizedBox(height: 12),
              _buildPomodoroSection(task),
              const SizedBox(height: 12),
              _buildNotesSection(task),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: planIdsAsync.isLoading
                    ? null
                    : () => _toggleTodayPlan(context, task.id, inTodayPlan),
                icon: Icon(
                  inTodayPlan
                      ? Icons.event_busy_outlined
                      : Icons.event_available_outlined,
                ),
                label: Text(inTodayPlan ? '移出今天计划' : '加入今天计划'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => context.go('/focus?taskId=${task.id}'),
                child: const Text('开始专注'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, String taskId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除任务？'),
        content: const Text(
          '将删除该任务，并清理相关 Checklist / 番茄记录 / 今天计划引用；关联笔记会保留但将解除关联。\n\n此操作不可撤销。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!context.mounted) return;

    final active = await ref.read(activePomodoroProvider.future);
    if (active != null && active.taskId == taskId) {
      await ref.read(cancelPomodoroNotificationUseCaseProvider)();
      await ref.read(activePomodoroRepositoryProvider).clear();
    }

    await ref.read(taskRepositoryProvider).deleteTask(taskId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已删除任务')));
    context.pop();
  }

  Future<void> _toggleTodayPlan(
    BuildContext context,
    String taskId,
    bool inPlan,
  ) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final repo = ref.read(todayPlanRepositoryProvider);
    if (inPlan) {
      await repo.removeTask(day: day, taskId: taskId);
    } else {
      await repo.addTask(day: day, taskId: taskId);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(inPlan ? '已移出今天计划' : '已加入今天计划')));
  }

  Widget _buildNotesSection(domain.Task task) {
    final notesAsync = ref.watch(notesByTaskIdProvider(task.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '关联笔记',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => _openCreateNoteSheet(context, task.id),
                  child: const Text('新增'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            notesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('加载失败：$error'),
              ),
              data: (notes) {
                if (notes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('还没有关联笔记。写一条记录进展/资料吧。'),
                  );
                }

                return Column(
                  children: [
                    for (final note in notes) ...[
                      ListTile(
                        leading: const Icon(Icons.note_outlined),
                        title: Text(
                          note.title.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: note.body.trim().isEmpty
                            ? null
                            : Text(
                                note.body.trim().split('\n').first,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                        onTap: () => context.push('/notes/${note.id}'),
                      ),
                      const Divider(height: 0),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateNoteSheet(BuildContext context, String taskId) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => NoteEditSheet(taskId: taskId),
    );
  }

  Widget _buildPomodoroSection(domain.Task task) {
    final sessionsAsync = ref.watch(pomodoroSessionsByTaskProvider(task.id));
    final countAsync = ref.watch(pomodoroCountByTaskProvider(task.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '番茄记录',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                countAsync.when(
                  data: (count) => Text('累计 $count'),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            sessionsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('加载失败：$error'),
              ),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('还没有番茄记录。开始一次专注吧。'),
                  );
                }

                final visible = sessions.take(5).toList();
                return Column(
                  children: [
                    for (final session in visible)
                      ListTile(
                        dense: true,
                        leading: Icon(
                          session.isDraft
                              ? Icons.edit_note
                              : Icons.check_circle_outline,
                        ),
                        title: Text(_formatSessionTime(session)),
                        subtitle: Text(
                          session.progressNote == null ||
                                  session.progressNote!.isEmpty
                              ? (session.isDraft ? '稍后补（草稿）' : '未填写进展')
                              : session.progressNote!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (sessions.length > visible.length)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text('仅展示最近 5 条'),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatSessionTime(domain.PomodoroSession session) {
    final end = session.endAt;
    final mm = end.month.toString().padLeft(2, '0');
    final dd = end.day.toString().padLeft(2, '0');
    final hh = end.hour.toString().padLeft(2, '0');
    final min = end.minute.toString().padLeft(2, '0');
    final mins = session.duration.inMinutes;
    return '$mm/$dd $hh:$min · ${mins}min';
  }

  Widget _buildChecklistSection(domain.Task task) {
    final itemsAsync = ref.watch(taskChecklistItemsProvider(task.id));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Checklist',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            itemsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('加载失败：$error'),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('还没有子任务，添加一条让它更可执行。'),
                  );
                }

                return Column(
                  children: [
                    for (final item in items)
                      CheckboxListTile(
                        value: item.isDone,
                        onChanged: (value) async {
                          if (value == null) return;
                          final toggle = ref.read(
                            toggleChecklistItemUseCaseProvider,
                          );
                          await toggle(item: item, isDone: value);
                        },
                        dense: true,
                        title: Text(item.title.value),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                  ],
                );
              },
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newChecklistController,
                    decoration: const InputDecoration(
                      hintText: '新增子任务…',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addChecklistItem(task),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: '添加',
                  onPressed: () => _addChecklistItem(task),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addChecklistItem(domain.Task task) async {
    final title = _newChecklistController.text.trim();
    if (title.isEmpty) return;

    final items = await ref.read(taskChecklistItemsProvider(task.id).future);
    final nextOrderIndex = items.isEmpty
        ? 0
        : (items.map((i) => i.orderIndex).reduce(math.max) + 1);

    try {
      final create = ref.read(createChecklistItemUseCaseProvider);
      await create(taskId: task.id, title: title, orderIndex: nextOrderIndex);
      _newChecklistController.clear();
    } on domain.ChecklistItemTitleEmptyException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('子任务标题不能为空')));
    }
  }

  void _openEditSheet(BuildContext context, domain.Task task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => TaskEditSheet(task: task),
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  const _TaskSummaryCard({required this.task});

  final domain.Task task;

  @override
  Widget build(BuildContext context) {
    final dueAt = task.dueAt;
    final dueText = dueAt == null
        ? '未设置'
        : '${dueAt.year}-${dueAt.month.toString().padLeft(2, '0')}-${dueAt.day.toString().padLeft(2, '0')}';

    final tagsText = task.tags.isEmpty ? '无' : task.tags.join(' · ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              task.title.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('状态：${_statusLabel(task.status)}'),
            Text('优先级：${_priorityLabel(task.priority)}'),
            Text('截止：$dueText'),
            Text('标签：$tagsText'),
            Text('预计番茄：${task.estimatedPomodoros?.toString() ?? '未设置'}'),
            if (task.description != null) ...[
              const SizedBox(height: 8),
              Text(task.description!),
            ],
          ],
        ),
      ),
    );
  }

  String _statusLabel(domain.TaskStatus status) => switch (status) {
    domain.TaskStatus.todo => '待办',
    domain.TaskStatus.inProgress => '进行中',
    domain.TaskStatus.done => '已完成',
  };

  String _priorityLabel(domain.TaskPriority priority) => switch (priority) {
    domain.TaskPriority.high => '高',
    domain.TaskPriority.medium => '中',
    domain.TaskPriority.low => '低',
  };
}
