import 'dart:async';

import 'package:ai/ai.dart' as ai;
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../providers/ai_providers.dart';

class AiBreakdownPage extends ConsumerStatefulWidget {
  const AiBreakdownPage({super.key, this.initialInput});

  final String? initialInput;

  @override
  ConsumerState<AiBreakdownPage> createState() => _AiBreakdownPageState();
}

class _AiBreakdownPageState extends ConsumerState<AiBreakdownPage> {
  final TextEditingController _inputController = TextEditingController();
  List<TextEditingController> _taskControllers = const [];

  ai.AiCancelToken? _cancelToken;
  bool _generating = false;
  bool _importing = false;
  bool _addToTodayPlan = false;

  @override
  void dispose() {
    _cancelToken?.cancel('dispose');
    _inputController.dispose();
    for (final c in _taskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final initial = widget.initialInput?.trim();
    if (initial != null && initial.isNotEmpty) {
      _inputController.text = initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(aiConfigProvider);
    final configured = configAsync.maybeWhen(
      data: (config) =>
          config != null && (config.apiKey?.trim().isNotEmpty ?? false),
      orElse: () => false,
    );

    return AppPageScaffold(
      title: '一句话拆任务',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!configured)
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning_amber_outlined),
                title: const Text('需要先配置 AI'),
                subtitle: const Text('请先在设置中填写 baseUrl / model / apiKey'),
                trailing: TextButton(
                  onPressed: () => context.push('/settings/ai'),
                  child: const Text('去设置'),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '输入',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _inputController,
                    enabled: !_generating && !_importing,
                    decoration: const InputDecoration(
                      hintText: '例如：今天把新需求拆解并对齐接口，安排联调与回归',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 3,
                    maxLines: 8,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: (!configured || _importing)
                        ? null
                        : (_generating ? _cancelGenerate : _generate),
                    child: Text(_generating ? '生成中…（点此停止）' : '生成草稿'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_taskControllers.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '草稿（可编辑）',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < _taskControllers.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _taskControllers[i],
                                enabled: !_importing,
                                decoration: InputDecoration(
                                  labelText: '任务 ${i + 1}',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              tooltip: '移除',
                              onPressed: _importing
                                  ? null
                                  : () => _removeTaskAt(i),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: _importing ? null : _addEmptyTask,
                      icon: const Icon(Icons.add),
                      label: const Text('添加一条'),
                    ),
                    const SizedBox(height: 4),
                    CheckboxListTile(
                      value: _addToTodayPlan,
                      onChanged: _importing
                          ? null
                          : (v) => setState(() => _addToTodayPlan = v ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('导入后加入今天计划'),
                      subtitle: const Text('将导入的任务追加到“今天”队列'),
                      dense: true,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _importing ? null : _importDraft,
                      child: Text(_importing ? '导入中…' : '导入到任务（可撤销）'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _cancelGenerate() {
    _cancelToken?.cancel('user');
  }

  Future<void> _generate() async {
    final cancelToken = ai.AiCancelToken();
    setState(() => _generating = true);
    try {
      _cancelToken = cancelToken;
      final config = await ref.read(aiConfigProvider.future);
      if (config == null || (config.apiKey?.trim().isEmpty ?? true)) {
        _showSnack('请先完成 AI 配置');
        return;
      }

      final items = await ref
          .read(openAiClientProvider)
          .breakdownToTasks(
            config: config,
            input: _inputController.text,
            cancelToken: cancelToken,
          );
      _setDraft(items);
    } on ai.AiClientCancelledException {
      _showSnack('已取消');
    } catch (e) {
      _showSnack('生成失败：$e');
    } finally {
      if (identical(_cancelToken, cancelToken)) {
        _cancelToken = null;
      }
      if (mounted) setState(() => _generating = false);
    }
  }

  void _setDraft(List<String> tasks) {
    for (final c in _taskControllers) {
      c.dispose();
    }
    final next = tasks.map((t) => TextEditingController(text: t)).toList();
    setState(() => _taskControllers = next);
  }

  void _addEmptyTask() {
    setState(() {
      _taskControllers = [..._taskControllers, TextEditingController(text: '')];
    });
  }

  void _removeTaskAt(int index) {
    final removed = _taskControllers[index];
    setState(() {
      _taskControllers = [
        for (var i = 0; i < _taskControllers.length; i++)
          if (i != index) _taskControllers[i],
      ];
    });
    removed.dispose();
  }

  Future<void> _importDraft() async {
    setState(() => _importing = true);
    try {
      final create = ref.read(createTaskUseCaseProvider);
      final repo = ref.read(taskRepositoryProvider);

      final createdIds = <String>[];
      for (final controller in _taskControllers) {
        final title = controller.text.trim();
        if (title.isEmpty) continue;
        final task = await create(title: title);
        createdIds.add(task.id);
      }

      if (createdIds.isEmpty) {
        _showSnack('没有可导入的任务');
        return;
      }

      if (_addToTodayPlan) {
        final now = DateTime.now();
        final day = DateTime(now.year, now.month, now.day);
        final planRepo = ref.read(todayPlanRepositoryProvider);
        for (final id in createdIds) {
          await planRepo.addTask(day: day, taskId: id);
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _addToTodayPlan
                ? '已导入 ${createdIds.length} 个任务，并加入今天计划'
                : '已导入 ${createdIds.length} 个任务',
          ),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () {
              unawaited(_undoImport(repo, createdIds));
            },
          ),
        ),
      );

      _setDraft(const []);
    } on domain.TaskTitleEmptyException {
      _showSnack('任务标题不能为空');
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _undoImport(
    domain.TaskRepository repo,
    List<String> taskIds,
  ) async {
    for (final id in taskIds) {
      await repo.deleteTask(id);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
