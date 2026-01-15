import 'dart:async';

import 'package:ai/ai.dart' as ai;
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../ai/providers/ai_providers.dart';
import '../providers/note_providers.dart';

class NoteAiActionItemsSheet extends ConsumerStatefulWidget {
  const NoteAiActionItemsSheet({super.key, required this.noteId});

  final String noteId;

  @override
  ConsumerState<NoteAiActionItemsSheet> createState() =>
      _NoteAiActionItemsSheetState();
}

class _NoteAiActionItemsSheetState
    extends ConsumerState<NoteAiActionItemsSheet> {
  List<TextEditingController> _taskControllers = const [];
  ai.AiCancelToken? _cancelToken;
  bool _generating = false;
  bool _importing = false;

  @override
  void dispose() {
    _cancelToken?.cancel('dispose');
    for (final c in _taskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(aiConfigProvider);
    final noteAsync = ref.watch(noteByIdProvider(widget.noteId));

    return noteAsync.when(
      loading: () => const AppPageScaffold(
        title: '提取行动项',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => AppPageScaffold(
        title: '提取行动项',
        body: Center(child: Text('加载失败：$error')),
      ),
      data: (note) {
        if (note == null) {
          return const AppPageScaffold(
            title: '提取行动项',
            body: Center(child: Text('笔记不存在或已删除')),
          );
        }

        final ready = configAsync.maybeWhen(
          data: (c) => c != null && (c.apiKey?.trim().isNotEmpty ?? false),
          orElse: () => false,
        );

        return AppPageScaffold(
          title: '提取行动项',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildConfigCard(context, configAsync),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('发送范围'),
                  subtitle: Text(
                    note.body.trim().isEmpty ? '标题（正文为空）' : '标题 + 正文',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: (!ready || _importing)
                    ? null
                    : (_generating
                          ? _cancelGenerate
                          : () => _generate(note.id)),
                child: Text(_generating ? '生成中…（点此停止）' : '生成行动项清单'),
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
                                      labelText: '行动项 ${i + 1}',
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
      },
    );
  }

  void _cancelGenerate() {
    _cancelToken?.cancel('user');
  }

  Widget _buildConfigCard(
    BuildContext context,
    AsyncValue<dynamic> configAsync,
  ) {
    return configAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, stack) => Card(
        child: ListTile(
          leading: const Icon(Icons.error_outline),
          title: const Text('AI 配置读取失败'),
          subtitle: Text('$error'),
          trailing: TextButton(
            onPressed: () => context.push('/settings/ai'),
            child: const Text('去设置'),
          ),
        ),
      ),
      data: (config) {
        final ready =
            config != null && (config.apiKey?.trim().isNotEmpty ?? false);
        if (!ready) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.warning_amber_outlined),
              title: const Text('AI 未配置'),
              subtitle: const Text('先在设置里配置 baseUrl / model / apiKey'),
              trailing: TextButton(
                onPressed: () => context.push('/settings/ai'),
                child: const Text('设置'),
              ),
            ),
          );
        }
        return Card(
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('AI 已就绪'),
            subtitle: Text(
              '${config.model} · ${_shortBaseUrl(config.baseUrl)}',
            ),
            trailing: TextButton(
              onPressed: () => context.push('/settings/ai'),
              child: const Text('设置'),
            ),
          ),
        );
      },
    );
  }

  Future<void> _generate(String noteId) async {
    final note = await ref.read(noteByIdProvider(noteId).future);
    if (note == null) {
      _showSnack('笔记不存在或已删除');
      return;
    }

    final config = await ref.read(aiConfigProvider.future);
    if (config == null || (config.apiKey?.trim().isEmpty ?? true)) {
      _showSnack('请先完成 AI 配置');
      return;
    }

    if (note.body.trim().isEmpty) {
      _showSnack('笔记正文为空，无法提取行动项');
      return;
    }

    final cancelToken = ai.AiCancelToken();
    setState(() => _generating = true);
    try {
      _cancelToken = cancelToken;
      final items = await ref
          .read(openAiClientProvider)
          .extractActionItemsFromNote(
            config: config,
            title: note.title.value,
            body: note.body,
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

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已导入 ${createdIds.length} 个任务'),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () {
              unawaited(_undoImport(repo, createdIds));
            },
          ),
        ),
      );

      _setDraft(const []);
      Navigator.of(context).pop();
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

  String _shortBaseUrl(String baseUrl) {
    final trimmed = baseUrl.trim();
    if (trimmed.length <= 32) return trimmed;
    return '${trimmed.substring(0, 32)}…';
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
