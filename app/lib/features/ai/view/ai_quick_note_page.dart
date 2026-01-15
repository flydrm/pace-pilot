import 'dart:async';

import 'package:ai/ai.dart' as ai;
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../notes/view/select_task_for_note_sheet.dart';
import '../../tasks/providers/task_providers.dart';
import '../providers/ai_providers.dart';

class AiQuickNotePage extends ConsumerStatefulWidget {
  const AiQuickNotePage({super.key});

  @override
  ConsumerState<AiQuickNotePage> createState() => _AiQuickNotePageState();
}

class _AiQuickNotePageState extends ConsumerState<AiQuickNotePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  String? _taskId;
  ai.AiCancelToken? _cancelToken;
  bool _generating = false;
  bool _saving = false;
  bool _hasDraft = false;

  @override
  void dispose() {
    _cancelToken?.cancel('dispose');
    _inputController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(aiConfigProvider);
    final configured = configAsync.maybeWhen(
      data: (config) =>
          config != null && (config.apiKey?.trim().isNotEmpty ?? false),
      orElse: () => false,
    );

    final taskId = _taskId;
    final taskAsync = taskId == null
        ? null
        : ref.watch(taskByIdProvider(taskId));

    return AppPageScaffold(
      title: 'AI 速记',
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
                  const Text(
                    '将发送：你在此处输入的文本（不会自动附带你的任务/笔记）。',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _inputController,
                    enabled: !_generating && !_saving,
                    decoration: const InputDecoration(
                      hintText: '例如：\n- 和张三对齐了接口字段\n- 需要补充错误码定义\n- 明天安排联调\n',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 5,
                    maxLines: 12,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: (!configured || _saving)
                        ? null
                        : (_generating ? _cancelGenerate : _generate),
                    child: Text(_generating ? '生成中…（点此停止）' : '生成笔记草稿'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_hasDraft)
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
                    TextField(
                      controller: _titleController,
                      enabled: !_saving,
                      decoration: const InputDecoration(
                        labelText: '标题（必填）',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _bodyController,
                      enabled: !_saving,
                      decoration: const InputDecoration(
                        labelText: '正文',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 8,
                      maxLines: 16,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '关联任务（可选）',
                            ),
                            child: taskId == null
                                ? const Text('未关联')
                                : taskAsync!.when(
                                    loading: () => const Text('加载中…'),
                                    error: (_, _) => const Text('加载失败'),
                                    data: (task) => Text(
                                      task == null
                                          ? '任务不存在或已删除'
                                          : task.title.value,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: '选择任务',
                          onPressed: _saving ? null : () => _pickTask(context),
                          icon: const Icon(Icons.link_outlined),
                        ),
                        IconButton(
                          tooltip: '清除关联',
                          onPressed: _saving || taskId == null
                              ? null
                              : () => setState(() => _taskId = null),
                          icon: const Icon(Icons.link_off_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _tagsController,
                      enabled: !_saving,
                      decoration: const InputDecoration(
                        labelText: '标签（逗号分隔）',
                        hintText: '例如：对齐, 联调, 周报',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _saving ? null : _clearDraft,
                            child: const Text('清空草稿'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: _saving ? null : _saveAsNote,
                            child: Text(_saving ? '保存中…' : '保存为笔记（可撤销）'),
                          ),
                        ),
                      ],
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

      final draft = await ref
          .read(openAiClientProvider)
          .draftNoteFromInput(
            config: config,
            input: _inputController.text,
            cancelToken: cancelToken,
          );

      _applyDraft(draft);
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

  void _applyDraft(ai.AiNoteDraft draft) {
    setState(() {
      _hasDraft = true;
      _titleController.text = draft.title;
      _bodyController.text = draft.body;
      _tagsController.text = draft.tags.join(',');
    });
  }

  void _clearDraft() {
    setState(() {
      _hasDraft = false;
      _titleController.text = '';
      _bodyController.text = '';
      _tagsController.text = '';
      _taskId = null;
    });
  }

  Future<void> _saveAsNote() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showSnack('标题不能为空');
      return;
    }

    setState(() => _saving = true);
    try {
      final create = ref.read(createNoteUseCaseProvider);
      final note = await create(
        title: title,
        body: _bodyController.text,
        tags: _parseTags(_tagsController.text),
        taskId: _taskId,
      );

      _clearDraft();
      _inputController.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已保存为笔记'),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () {
              ref.read(noteRepositoryProvider).deleteNote(note.id);
            },
          ),
        ),
      );
    } on domain.NoteTitleEmptyException {
      _showSnack('标题不能为空');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> _pickTask(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const SelectTaskForNoteSheet(),
    );
    if (picked == null) return;
    if (!mounted) return;
    setState(() => _taskId = picked);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
