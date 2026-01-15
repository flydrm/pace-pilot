import 'dart:async';

import 'package:ai/ai.dart' as ai;
import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../notes/providers/note_providers.dart';
import '../../tasks/providers/task_providers.dart';
import '../model/ai_evidence_item.dart';
import '../providers/ai_providers.dart';

class AiTodayPlanPage extends ConsumerStatefulWidget {
  const AiTodayPlanPage({super.key});

  @override
  ConsumerState<AiTodayPlanPage> createState() => _AiTodayPlanPageState();
}

class _AiTodayPlanPageState extends ConsumerState<AiTodayPlanPage> {
  final TextEditingController _focusController = TextEditingController();
  final TextEditingController _pomodorosController = TextEditingController();
  final TextEditingController _draftController = TextEditingController();

  String? _tagFilter;
  String _query = '';
  final Set<String> _selectedKeys = <String>{};

  ai.AiCancelToken? _cancelToken;
  bool _generating = false;
  bool _saving = false;

  ai.AiEvidenceAnswer? _answer;
  List<AiEvidenceItem> _lastSelectedEvidence = const [];
  bool _didAutoSelectTopEvidence = false;

  @override
  void dispose() {
    _cancelToken?.cancel('dispose');
    _focusController.dispose();
    _pomodorosController.dispose();
    _draftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(aiConfigProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    final notesAsync = ref.watch(notesStreamProvider);

    final config = configAsync.valueOrNull;
    final ready = config != null && (config.apiKey?.trim().isNotEmpty ?? false);
    final isLoading = tasksAsync.isLoading || notesAsync.isLoading;

    final now = DateTime.now();
    final dayKey = _formatDateYmd(now);
    final tasks = tasksAsync.valueOrNull ?? const <domain.Task>[];
    final openTasks = const domain.TaskListQuery().apply(tasks, now);

    final evidenceAll = _buildTaskEvidence(openTasks);
    final availableTags = _availableTags(evidenceAll);
    final evidence = _applyFilters(evidenceAll);
    _pruneSelection(evidenceAll);
    _maybeAutoSelectTopEvidence(evidenceAll: evidenceAll, isLoading: isLoading);

    return AppPageScaffold(
      title: '今日计划（AI）',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConfigCard(context, configAsync),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.today_outlined),
              title: const Text('日期：今天'),
              subtitle: Text(dayKey),
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
                    '约束（可选）',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pomodorosController,
                    enabled: !_generating && !_saving,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '今日可用番茄数（可选）',
                      hintText: '例如：6',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _focusController,
                    enabled: !_generating && !_saving,
                    decoration: const InputDecoration(
                      labelText: '关注点（可选）',
                      hintText: '例如：先交付，再优化；优先解决阻塞',
                      border: OutlineInputBorder(),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: (!ready || _saving)
                        ? null
                        : (_generating ? _cancelGenerate : _generate),
                    child: Text(_generating ? '生成中…（点此停止）' : '生成今日计划草稿'),
                  ),
                ],
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
                    '任务（今天）',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '将发送：你勾选的任务标题/描述/截止日期/标签/预计番茄数（不自动附带笔记与历史问答）。',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  if (isLoading)
                    const LinearProgressIndicator()
                  else if (tasksAsync.hasError)
                    Text('任务加载失败：${tasksAsync.error}')
                  else if (openTasks.isEmpty)
                    const Text('暂无未完成任务。可先新增任务，或用 AI 拆任务。')
                  else ...[
                    TextField(
                      enabled: !_generating && !_saving,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: '筛选（标题/摘要）',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    if (availableTags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('全部标签'),
                            selected: _tagFilter == null,
                            onSelected: _generating || _saving
                                ? null
                                : (_) => setState(() => _tagFilter = null),
                          ),
                          for (final tag in availableTags)
                            ChoiceChip(
                              label: Text(tag),
                              selected: _tagFilter == tag,
                              onSelected: _generating || _saving
                                  ? null
                                  : (_) {
                                      final next = _tagFilter == tag
                                          ? null
                                          : tag;
                                      setState(() => _tagFilter = next);
                                    },
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (evidence.isEmpty)
                      const Text('没有匹配的任务，请调整筛选条件。')
                    else ...[
                      Row(
                        children: [
                          TextButton(
                            onPressed: _generating || _saving
                                ? null
                                : () => setState(
                                    () => _selectedKeys
                                      ..clear()
                                      ..addAll(evidence.map((e) => e.key)),
                                  ),
                            child: const Text('全选当前'),
                          ),
                          TextButton(
                            onPressed: _generating || _saving
                                ? null
                                : () => setState(() => _selectedKeys.clear()),
                            child: const Text('清空'),
                          ),
                          const Spacer(),
                          Text('已选 ${_selectedKeys.length}'),
                        ],
                      ),
                      const Divider(height: 0),
                      for (final item in evidence) ...[
                        CheckboxListTile(
                          value: _selectedKeys.contains(item.key),
                          onChanged: _generating || _saving
                              ? null
                              : (v) => setState(() {
                                  if (v == true) {
                                    _selectedKeys.add(item.key);
                                  } else {
                                    _selectedKeys.remove(item.key);
                                  }
                                }),
                          title: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item.snippet,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: IconButton(
                            tooltip: '打开',
                            onPressed: () => context.push(item.route),
                            icon: const Icon(Icons.open_in_new_outlined),
                          ),
                        ),
                        const Divider(height: 0),
                      ],
                    ],
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_answer != null) _buildDraftCard(context),
        ],
      ),
    );
  }

  Widget _buildConfigCard(
    BuildContext context,
    AsyncValue<domain.AiProviderConfig?> configAsync,
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
              onTap: () => context.push('/settings/ai'),
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
            onTap: () => context.push('/settings/ai'),
          ),
        );
      },
    );
  }

  void _cancelGenerate() {
    _cancelToken?.cancel('user');
  }

  Future<void> _generate() async {
    final config = await ref.read(aiConfigProvider.future);
    if (config == null || (config.apiKey?.trim().isEmpty ?? true)) {
      _showSnack('请先完成 AI 配置');
      return;
    }

    final tasks = await ref.read(tasksStreamProvider.future);
    final openTasks = const domain.TaskListQuery().apply(tasks, DateTime.now());
    final evidenceAll = _buildTaskEvidence(openTasks);
    final selected = evidenceAll
        .where((e) => _selectedKeys.contains(e.key))
        .toList();

    if (selected.isEmpty) {
      _showSnack('请至少选择 1 个任务');
      return;
    }
    if (selected.length > 12) {
      _showSnack('任务过多：请控制在 12 条以内（当前 ${selected.length}）');
      return;
    }

    setState(() {
      _generating = true;
      _answer = null;
      _lastSelectedEvidence = selected;
      _draftController.text = '';
    });

    final cancelToken = ai.AiCancelToken();
    try {
      _cancelToken = cancelToken;
      final now = DateTime.now();
      final dayKey = _formatDateYmd(now);
      final focus = _focusController.text.trim();

      final pomodoros = int.tryParse(_pomodorosController.text.trim());
      final pomodorosText =
          (pomodoros == null || pomodoros <= 0 || pomodoros > 24)
          ? null
          : '今日可用番茄数：$pomodoros';

      final question = [
        '请基于证据，生成今日计划草稿（$dayKey）。',
        '要求：文案克制、商务稳重；只使用证据内容，禁止编造新的任务与新事实；缺少信息要用“待补：...”标记。',
        '结构：',
        '1) 今日目标（1–2 句）',
        '2) 今日计划（按优先级/截止日期排序；每项包含：任务标题 / 预计番茄数 / Next Action）',
        '3) 风险/阻塞（0–3 条）',
        '4) 今日收尾（1–2 条）',
        if (pomodorosText != null) pomodorosText,
        if (focus.isNotEmpty) '用户关注点：$focus',
      ].join('\n');

      final blocks = <String>[];
      for (var i = 0; i < selected.length; i++) {
        final e = selected[i];
        blocks.add('[${i + 1}] TASK ${e.title}\n${e.snippet}');
      }

      final result = await ref
          .read(openAiClientProvider)
          .askWithEvidence(
            config: config,
            question: question,
            evidence: blocks,
            cancelToken: cancelToken,
          );

      final validCitations =
          result.citations
              .where((c) => c >= 1 && c <= selected.length)
              .toSet()
              .toList()
            ..sort();

      final insufficient =
          result.insufficientEvidence ||
          validCitations.length < 2 ||
          validCitations.length > 5;
      final citations = insufficient ? const <int>[] : validCitations;

      setState(() {
        _answer = ai.AiEvidenceAnswer(
          answer: result.answer,
          citations: citations,
          insufficientEvidence: insufficient,
        );
        _draftController.text = result.answer;
      });
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

  void _maybeAutoSelectTopEvidence({
    required List<AiEvidenceItem> evidenceAll,
    required bool isLoading,
  }) {
    if (_didAutoSelectTopEvidence) return;
    if (isLoading) return;
    if (evidenceAll.isEmpty) return;
    if (_selectedKeys.isNotEmpty) {
      _didAutoSelectTopEvidence = true;
      return;
    }
    _didAutoSelectTopEvidence = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedKeys
          ..clear()
          ..addAll(evidenceAll.take(5).map((e) => e.key));
      });
    });
  }

  Widget _buildDraftCard(BuildContext context) {
    final answer = _answer!;
    final cited = answer.citations
        .where((i) => i >= 1 && i <= _lastSelectedEvidence.length)
        .map((i) => MapEntry(i, _lastSelectedEvidence[i - 1]))
        .toList(growable: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              answer.insufficientEvidence ? '草稿（证据不足）' : '草稿（可编辑）',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _draftController,
              enabled: !_saving,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '可在此编辑后保存为笔记（只追加不覆盖）。',
              ),
              minLines: 8,
              maxLines: 20,
            ),
            const SizedBox(height: 12),
            if (!answer.insufficientEvidence) ...[
              const Text(
                '引用',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (cited.length < 2)
                const Text('引用不足（应为 2–5 条）。建议补充任务信息后重试。')
              else
                for (final entry in cited)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 12,
                      child: Text(
                        '${entry.key}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(
                      entry.value.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: entry.value.snippet.isEmpty
                        ? null
                        : Text(
                            entry.value.snippet,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(entry.value.route),
                  ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saving ? null : _saveToNote,
              child: Text(_saving ? '保存中…' : '保存为笔记（只追加不覆盖）'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToNote() async {
    final draft = _draftController.text.trimRight();
    if (draft.trim().isEmpty) {
      _showSnack('草稿为空，无法保存');
      return;
    }

    final dayKey = _formatDateYmd(DateTime.now());
    final dayTag = 'today-plan:$dayKey';
    final title = '今日计划 $dayKey';

    setState(() => _saving = true);
    try {
      final repo = ref.read(noteRepositoryProvider);
      final notes = await repo.watchAllNotes().first;
      final existing = notes.where((n) => n.tags.contains(dayTag)).toList();

      final timestamp = DateTime.now();
      final insufficient = _answer?.insufficientEvidence == true;
      final header = insufficient
          ? '## AI 草稿（证据不足，${_formatDateTime(timestamp)}）'
          : '## AI 草稿（${_formatDateTime(timestamp)}）';
      final selected = _lastSelectedEvidence;
      final citations =
          (_answer?.citations ?? const <int>[])
              .where((i) => i >= 1 && i <= selected.length)
              .toSet()
              .toList()
            ..sort();

      final evidenceList = <String>[
        '任务（本次发送 ${selected.length} 条）：',
        for (var i = 0; i < selected.length; i++)
          '- [${i + 1}] ${selected[i].title}',
      ].join('\n');

      final citationsList = citations.isEmpty
          ? '引用：无（证据不足或模型未按要求返回）'
          : [
              '引用：',
              for (final c in citations) '- [$c] ${selected[c - 1].title}',
            ].join('\n');

      final section = [
        header,
        '',
        draft,
        '',
        citationsList,
        '',
        evidenceList,
      ].join('\n');

      if (existing.isEmpty) {
        final created = await ref.read(createNoteUseCaseProvider)(
          title: title,
          body: section,
          tags: ['today-plan', dayTag],
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('已保存为今日计划笔记'),
            action: SnackBarAction(
              label: '撤销',
              onPressed: () => unawaited(repo.deleteNote(created.id)),
            ),
          ),
        );

        if (context.mounted) {
          context.push('/notes/${created.id}');
        }
        return;
      }

      final note = existing.reduce(
        (a, b) => a.updatedAt.isAfter(b.updatedAt) ? a : b,
      );
      final before = note;
      final separator = note.body.trim().isEmpty ? '' : '\n\n---\n\n';
      final updatedBody = '${note.body}$separator$section';

      final updated = await ref.read(updateNoteUseCaseProvider)(
        note: note,
        title: note.title.value,
        body: updatedBody,
        tags: note.tags.toSet().toList(),
        taskId: note.taskId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已追加到今日计划笔记'),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () => unawaited(repo.upsertNote(before)),
          ),
        ),
      );

      if (context.mounted) {
        context.push('/notes/${updated.id}');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  List<AiEvidenceItem> _buildTaskEvidence(List<domain.Task> openTasks) {
    final items = <AiEvidenceItem>[];
    for (final task in openTasks) {
      final status = switch (task.status) {
        domain.TaskStatus.todo => '待办',
        domain.TaskStatus.inProgress => '进行中',
        domain.TaskStatus.done => '已完成',
      };
      final due = task.dueAt == null
          ? null
          : '${task.dueAt!.month}/${task.dueAt!.day}';
      final est = task.estimatedPomodoros;
      final parts = <String>[
        status,
        if (task.priority != domain.TaskPriority.medium)
          _priorityLabel(task.priority),
        if (due != null) '到期 $due',
        if (est != null) '预计 $est 个番茄',
        if (task.tags.isNotEmpty) task.tags.take(4).join(' · '),
        if (task.description?.trim().isNotEmpty == true)
          _oneLine(task.description!),
      ];
      items.add(
        AiEvidenceItem(
          key: 'task:${task.id}',
          type: AiEvidenceType.task,
          title: task.title.value,
          snippet: parts.where((p) => p.trim().isNotEmpty).join('  ·  '),
          route: '/tasks/${task.id}',
          at: task.updatedAt,
          tags: task.tags,
        ),
      );
    }
    return items;
  }

  List<String> _availableTags(List<AiEvidenceItem> evidence) {
    final set = <String>{};
    for (final e in evidence) {
      set.addAll(e.tags);
    }
    final tags = set.toList();
    tags.sort((a, b) => a.compareTo(b));
    return tags;
  }

  List<AiEvidenceItem> _applyFilters(List<AiEvidenceItem> evidence) {
    final q = _query.trim();
    final tag = _tagFilter;

    return evidence
        .where((e) {
          if (tag != null && !e.tags.contains(tag)) return false;
          if (q.isNotEmpty) {
            final hay = '${e.title}\n${e.snippet}'.toLowerCase();
            if (!hay.contains(q.toLowerCase())) return false;
          }
          return true;
        })
        .toList(growable: false);
  }

  void _pruneSelection(List<AiEvidenceItem> evidenceAll) {
    final availableKeys = evidenceAll.map((e) => e.key).toSet();
    _selectedKeys.removeWhere((k) => !availableKeys.contains(k));
  }

  String _priorityLabel(domain.TaskPriority priority) => switch (priority) {
    domain.TaskPriority.high => '高优先级',
    domain.TaskPriority.medium => '中优先级',
    domain.TaskPriority.low => '低优先级',
  };

  String _oneLine(String text) {
    final line = text.trim().split('\n').first.trim();
    return line.length <= 80 ? line : '${line.substring(0, 80)}…';
  }

  String _shortBaseUrl(String baseUrl) {
    final trimmed = baseUrl.trim();
    if (trimmed.length <= 32) return trimmed;
    return '${trimmed.substring(0, 32)}…';
  }

  String _formatDateYmd(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _formatDateTime(DateTime dt) =>
      '${_formatDateYmd(dt)} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
