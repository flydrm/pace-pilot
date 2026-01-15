import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../providers/task_providers.dart';
import 'task_edit_sheet.dart';
import 'task_filters_sheet.dart';
import 'task_list_item.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  final TextEditingController _quickAddController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _quickAddController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(taskListQueryProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);

    return AppPageScaffold(
      title: '任务',
      actions: [
        IconButton(
          tooltip: '筛选',
          onPressed: () => _openFilters(context, query),
          icon: const Icon(Icons.filter_list),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        tooltip: '新增任务',
        onPressed: () => _openCreateSheet(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _quickAddController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.add_task),
                hintText: 'Quick Add：输入一句话创建任务…',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: 'AI 拆任务',
                  onPressed: () {
                    final input = _quickAddController.text.trim();
                    if (input.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('先输入一句话，再用 AI 拆任务')),
                      );
                      return;
                    }
                    final encoded = Uri.encodeQueryComponent(input);
                    context.push('/ai/breakdown?input=$encoded');
                  },
                  icon: const Icon(Icons.auto_awesome_outlined),
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitQuickAdd(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: '搜索：标题/描述…',
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.trim().isEmpty
                    ? null
                    : IconButton(
                        tooltip: '清除搜索',
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          _ActiveFiltersBar(
            query: query,
            onClear: () => ref.read(taskListQueryProvider.notifier).state =
                const domain.TaskListQuery(),
          ),
          const Divider(height: 0),
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('加载失败：$error')),
              data: (tasks) {
                final keyword = _searchQuery.trim().toLowerCase();
                final filtered = query.apply(tasks, DateTime.now());
                final visible = keyword.isEmpty
                    ? filtered
                    : filtered
                          .where((task) {
                            final hay = [
                              task.title.value,
                              task.description ?? '',
                            ].join('\n').toLowerCase();
                            return hay.contains(keyword);
                          })
                          .toList(growable: false);
                if (visible.isEmpty) {
                  if (tasks.isEmpty) {
                    return const Center(child: Text('暂无任务'));
                  }
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('没有匹配的任务'),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                          child: const Text('清除搜索'),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: visible.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final task = visible[index];
                    return TaskListItem(
                      task: task,
                      onTap: () => context.push('/tasks/${task.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitQuickAdd(BuildContext context) async {
    final title = _quickAddController.text.trim();
    if (title.isEmpty) return;

    try {
      await ref.read(createTaskUseCaseProvider)(title: title);
      _quickAddController.clear();
    } on domain.TaskTitleEmptyException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('标题不能为空')));
    }
  }

  void _openCreateSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const TaskEditSheet(),
    );
  }

  Future<void> _openFilters(
    BuildContext context,
    domain.TaskListQuery current,
  ) async {
    final next = await showModalBottomSheet<domain.TaskListQuery>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => TaskFiltersSheet(initial: current),
    );
    if (next == null) return;
    ref.read(taskListQueryProvider.notifier).state = next;
  }
}

class _ActiveFiltersBar extends StatelessWidget {
  const _ActiveFiltersBar({required this.query, required this.onClear});

  final domain.TaskListQuery query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _chip('状态：${_statusLabel(query.statusFilter)}'),
      if (query.priority != null)
        _chip('优先级：${_priorityLabel(query.priority!)}'),
      if (query.tag != null && query.tag!.isNotEmpty) _chip('标签：${query.tag}'),
      if (query.dueToday) _chip('今天到期'),
      if (query.overdue) _chip('已逾期'),
    ];

    final hasAnyFilter =
        query.statusFilter != domain.TaskStatusFilter.open ||
        query.priority != null ||
        (query.tag != null && query.tag!.isNotEmpty) ||
        query.dueToday ||
        query.overdue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: chips),
            ),
          ),
          if (hasAnyFilter)
            TextButton(onPressed: onClear, child: const Text('清除')),
        ],
      ),
    );
  }

  Widget _chip(String text) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Chip(label: Text(text)),
  );

  String _statusLabel(domain.TaskStatusFilter filter) => switch (filter) {
    domain.TaskStatusFilter.open => '未完成',
    domain.TaskStatusFilter.all => '全部',
    domain.TaskStatusFilter.todo => '待办',
    domain.TaskStatusFilter.inProgress => '进行中',
    domain.TaskStatusFilter.done => '已完成',
  };

  String _priorityLabel(domain.TaskPriority priority) => switch (priority) {
    domain.TaskPriority.high => '高',
    domain.TaskPriority.medium => '中',
    domain.TaskPriority.low => '低',
  };
}
