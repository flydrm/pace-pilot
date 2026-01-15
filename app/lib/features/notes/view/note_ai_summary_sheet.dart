import 'dart:async';

import 'package:ai/ai.dart' as ai;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../ai/providers/ai_providers.dart';
import '../providers/note_providers.dart';

class NoteAiSummarySheet extends ConsumerStatefulWidget {
  const NoteAiSummarySheet({super.key, required this.noteId});

  final String noteId;

  @override
  ConsumerState<NoteAiSummarySheet> createState() => _NoteAiSummarySheetState();
}

class _NoteAiSummarySheetState extends ConsumerState<NoteAiSummarySheet> {
  final TextEditingController _draftController = TextEditingController();
  ai.AiCancelToken? _cancelToken;
  bool _generating = false;
  bool _applying = false;

  @override
  void dispose() {
    _cancelToken?.cancel('dispose');
    _draftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(aiConfigProvider);
    final noteAsync = ref.watch(noteByIdProvider(widget.noteId));

    return noteAsync.when(
      loading: () => const AppPageScaffold(
        title: '总结要点',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => AppPageScaffold(
        title: '总结要点',
        body: Center(child: Text('加载失败：$error')),
      ),
      data: (note) {
        if (note == null) {
          return const AppPageScaffold(
            title: '总结要点',
            body: Center(child: Text('笔记不存在或已删除')),
          );
        }

        final ready = configAsync.maybeWhen(
          data: (c) => c != null && (c.apiKey?.trim().isNotEmpty ?? false),
          orElse: () => false,
        );

        return AppPageScaffold(
          title: '总结要点',
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
                onPressed: (!ready || _applying)
                    ? null
                    : (_generating
                          ? _cancelGenerate
                          : () => _generate(note.id)),
                child: Text(_generating ? '生成中…（点此停止）' : '生成总结草稿'),
              ),
              const SizedBox(height: 12),
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
                        controller: _draftController,
                        enabled: !_applying,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '先生成，再按需修改后采用到笔记',
                        ),
                        minLines: 6,
                        maxLines: 16,
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: !_applying
                            ? () => _applyToNote(note.id)
                            : null,
                        child: Text(_applying ? '采用中…' : '采用到当前笔记（可撤销）'),
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

  void _cancelGenerate() {
    _cancelToken?.cancel('user');
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
      _showSnack('笔记正文为空，无法总结');
      return;
    }

    final cancelToken = ai.AiCancelToken();
    setState(() => _generating = true);
    try {
      _cancelToken = cancelToken;
      final summary = await ref
          .read(openAiClientProvider)
          .summarizeNote(
            config: config,
            title: note.title.value,
            body: note.body,
            cancelToken: cancelToken,
          );
      if (!mounted) return;
      setState(() => _draftController.text = summary);
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

  Future<void> _applyToNote(String noteId) async {
    final draft = _draftController.text.trimRight();
    if (draft.trim().isEmpty) {
      _showSnack('草稿为空，无法采用');
      return;
    }

    final note = await ref.read(noteByIdProvider(noteId).future);
    if (note == null) {
      _showSnack('笔记不存在或已删除');
      return;
    }

    final before = note;
    final timestamp = DateTime.now();
    final section = [
      '## AI 总结（${_formatDateTime(timestamp)}）',
      '',
      draft,
    ].join('\n');
    final separator = note.body.trim().isEmpty ? '' : '\n\n---\n\n';
    final updatedBody = '${note.body}$separator$section';

    setState(() => _applying = true);
    try {
      final update = ref.read(updateNoteUseCaseProvider);
      await update(
        note: note,
        title: note.title.value,
        body: updatedBody,
        tags: note.tags.toSet().toList(),
        taskId: note.taskId,
      );

      if (!mounted) return;
      final repo = ref.read(noteRepositoryProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已写入 AI 总结'),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () => unawaited(repo.upsertNote(before)),
          ),
        ),
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _applying = false);
    }
  }

  String _shortBaseUrl(String baseUrl) {
    final trimmed = baseUrl.trim();
    if (trimmed.length <= 32) return trimmed;
    return '${trimmed.substring(0, 32)}…';
  }

  String _formatDateTime(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
