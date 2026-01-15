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
import '../model/time_range_key.dart';
import '../providers/ai_providers.dart';

class AiDailyReviewPage extends ConsumerStatefulWidget {
  const AiDailyReviewPage({super.key});

  @override
  ConsumerState<AiDailyReviewPage> createState() => _AiDailyReviewPageState();
}

class _AiDailyReviewPageState extends ConsumerState<AiDailyReviewPage> {
  final TextEditingController _focusController = TextEditingController();
  final TextEditingController _draftController = TextEditingController();

  AiEvidenceType? _typeFilter;
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
    _draftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(aiConfigProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    final notesAsync = ref.watch(notesStreamProvider);

    final range = _yesterdayRange(DateTime.now());
    final sessionsAsync = ref.watch(
      pomodoroSessionsBetweenProvider(
        TimeRangeKey(
          startInclusive: range.startInclusive,
          endExclusive: range.endExclusive,
        ),
      ),
    );

    final config = configAsync.valueOrNull;
    final ready = config != null && (config.apiKey?.trim().isNotEmpty ?? false);
    final isLoading =
        tasksAsync.isLoading || notesAsync.isLoading || sessionsAsync.isLoading;

    final tasks = tasksAsync.valueOrNull ?? const <domain.Task>[];
    final notes = notesAsync.valueOrNull ?? const <domain.Note>[];
    final sessions =
        sessionsAsync.valueOrNull ?? const <domain.PomodoroSession>[];

    final evidenceAll = _buildEvidence(
      tasks: tasks,
      notes: notes,
      sessions: sessions,
      startInclusive: range.startInclusive,
      endExclusive: range.endExclusive,
    );
    final availableTags = _availableTags(evidenceAll);
    final evidence = _applyFilters(evidenceAll);
    _pruneSelection(evidenceAll);
    _maybeAutoSelectTopEvidence(evidenceAll: evidenceAll, isLoading: isLoading);

    return AppPageScaffold(
      title: '昨日回顾（AI）',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConfigCard(context, configAsync),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range_outlined),
              title: const Text('范围：昨天'),
              subtitle: Text(_formatDateYmd(range.startInclusive)),
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
                    '关注点（可选）',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _focusController,
                    enabled: !_generating && !_saving,
                    decoration: const InputDecoration(
                      hintText: '例如：阻塞/风险、客户沟通、交付节奏',
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
                    child: Text(_generating ? '生成中…（点此停止）' : '生成昨日回顾草稿'),
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
                    '证据（昨天）',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildFilterRow(),
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
                                    final next = _tagFilter == tag ? null : tag;
                                    setState(() => _tagFilter = next);
                                  },
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (isLoading)
                    const LinearProgressIndicator()
                  else if (tasksAsync.hasError ||
                      notesAsync.hasError ||
                      sessionsAsync.hasError)
                    Text(
                      '加载失败：${tasksAsync.error ?? notesAsync.error ?? sessionsAsync.error}',
                    )
                  else if (evidenceAll.isEmpty)
                    const Text('昨天没有可用证据。可以先补充笔记或完成一次专注。')
                  else if (evidence.isEmpty)
                    const Text('没有匹配的证据，请调整筛选条件。')
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
                          '${item.typeLabel} · ${item.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          item.snippet.isEmpty
                              ? _formatDate(item.at)
                              : '${_formatDate(item.at)} · ${item.snippet}',
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

  Widget _buildFilterRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            enabled: !_generating && !_saving,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '筛选（标题/摘要）',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<AiEvidenceType?>(
          tooltip: '类型筛选',
          enabled: !_generating && !_saving,
          onSelected: (v) => setState(() => _typeFilter = v),
          itemBuilder: (context) => const [
            PopupMenuItem(value: null, child: Text('全部类型')),
            PopupMenuItem(value: AiEvidenceType.note, child: Text('笔记')),
            PopupMenuItem(value: AiEvidenceType.task, child: Text('任务')),
            PopupMenuItem(value: AiEvidenceType.pomodoro, child: Text('专注')),
          ],
          child: Chip(
            label: Text(
              _typeFilter == null
                  ? '全部'
                  : _typeFilter == AiEvidenceType.note
                  ? '笔记'
                  : _typeFilter == AiEvidenceType.task
                  ? '任务'
                  : '专注',
            ),
          ),
        ),
      ],
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

    final range = _yesterdayRange(DateTime.now());
    final tasks = await ref.read(tasksStreamProvider.future);
    final notes = await ref.read(notesStreamProvider.future);
    final sessions = await ref.read(
      pomodoroSessionsBetweenProvider(
        TimeRangeKey(
          startInclusive: range.startInclusive,
          endExclusive: range.endExclusive,
        ),
      ).future,
    );

    final evidenceAll = _buildEvidence(
      tasks: tasks,
      notes: notes,
      sessions: sessions,
      startInclusive: range.startInclusive,
      endExclusive: range.endExclusive,
    );
    final selected = evidenceAll
        .where((e) => _selectedKeys.contains(e.key))
        .toList();
    if (selected.length < 2) {
      _showSnack('请至少选择 2 条证据');
      return;
    }
    if (selected.length > 12) {
      _showSnack('证据过多：请控制在 12 条以内（当前 ${selected.length}）');
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
      final focus = _focusController.text.trim();
      final dayText = _formatDateYmd(range.startInclusive);

      final question = [
        '请基于证据，生成昨日回顾草稿（$dayText）。',
        '要求：文案克制、商务稳重；只使用证据内容，禁止编造；缺少信息要明确“证据不足”。',
        '结构：',
        '1) 一句话总结',
        '2) 完成了什么（任务/专注汇总，3–6 条）',
        '3) 关键产出（2–5 条）',
        '4) 风险/阻塞（0–3 条）',
        '5) 明日建议（3–5 条，动词开头）',
        if (focus.isNotEmpty) '用户关注点：$focus',
      ].join('\n');

      final blocks = <String>[];
      for (var i = 0; i < selected.length; i++) {
        final e = selected[i];
        blocks.add(
          '[${i + 1}] ${e.type.name.toUpperCase()} ${e.title}\n${e.snippet}',
        );
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
                const Text('引用不足（应为 2–5 条）。建议补充证据后重试。')
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
                      '${entry.value.typeLabel} · ${entry.value.title}',
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

    final range = _yesterdayRange(DateTime.now());
    final dayKey = _formatDateYmd(range.startInclusive);
    final dayTag = 'daily-review:$dayKey';
    final title = '昨日回顾 $dayKey';

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
        '证据（本次发送 ${selected.length} 条）：',
        for (var i = 0; i < selected.length; i++)
          '- [${i + 1}] ${selected[i].typeLabel} · ${selected[i].title}',
      ].join('\n');

      final citationsList = citations.isEmpty
          ? '引用：无（证据不足或模型未按要求返回）'
          : [
              '引用：',
              for (final c in citations)
                '- [$c] ${selected[c - 1].typeLabel} · ${selected[c - 1].title}',
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
          tags: ['daily-review', dayTag],
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('已保存为昨日回顾笔记'),
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
          content: const Text('已追加到昨日回顾笔记'),
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

  List<AiEvidenceItem> _buildEvidence({
    required List<domain.Task> tasks,
    required List<domain.Note> notes,
    required List<domain.PomodoroSession> sessions,
    required DateTime startInclusive,
    required DateTime endExclusive,
  }) {
    final byTaskId = {for (final t in tasks) t.id: t};
    final items = <AiEvidenceItem>[];

    for (final note in notes) {
      if (!_inRange(note.updatedAt, startInclusive, endExclusive)) continue;
      items.add(
        AiEvidenceItem(
          key: 'note:${note.id}',
          type: AiEvidenceType.note,
          title: note.title.value,
          snippet: _snippet(note.body),
          route: '/notes/${note.id}',
          at: note.updatedAt,
          tags: note.tags,
        ),
      );
    }

    for (final task in tasks) {
      if (!_inRange(task.updatedAt, startInclusive, endExclusive)) continue;
      final status = switch (task.status) {
        domain.TaskStatus.todo => '待办',
        domain.TaskStatus.inProgress => '进行中',
        domain.TaskStatus.done => '已完成',
      };
      final due = task.dueAt == null
          ? null
          : '${task.dueAt!.month}/${task.dueAt!.day}';
      final parts = <String>[
        status,
        if (due != null) '到期 $due',
        if (task.tags.isNotEmpty) task.tags.take(3).join(' · '),
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

    for (final session in sessions) {
      if (!_inRange(session.endAt, startInclusive, endExclusive)) continue;
      final task = byTaskId[session.taskId];
      final title = task?.title.value ?? '未知任务';
      final durationMinutes = session.duration.inMinutes;
      final note = session.progressNote?.trim();
      final snippetParts = <String>[
        '时长 ${durationMinutes}min',
        if (note != null && note.isNotEmpty) note,
      ];

      items.add(
        AiEvidenceItem(
          key: 'pomodoro:${session.id}',
          type: AiEvidenceType.pomodoro,
          title: '$title · 番茄',
          snippet: snippetParts.join('  ·  '),
          route: '/tasks/${session.taskId}',
          at: session.endAt,
          tags: task?.tags ?? const [],
        ),
      );
    }

    items.sort((a, b) => b.at.compareTo(a.at));
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
    final type = _typeFilter;
    final tag = _tagFilter;

    return evidence
        .where((e) {
          if (type != null && e.type != type) return false;
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

  bool _inRange(DateTime dt, DateTime startInclusive, DateTime endExclusive) {
    return !dt.isBefore(startInclusive) && dt.isBefore(endExclusive);
  }

  _DayRange _yesterdayRange(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final startInclusive = today.subtract(const Duration(days: 1));
    final endExclusive = today;
    return _DayRange(
      startInclusive: startInclusive,
      endExclusive: endExclusive,
    );
  }

  String _snippet(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return '';
    final lines = trimmed
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty);
    return lines.take(2).join(' / ');
  }

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

  String _formatDate(DateTime dt) => '${dt.month}/${dt.day}';

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DayRange {
  const _DayRange({required this.startInclusive, required this.endExclusive});

  final DateTime startInclusive;
  final DateTime endExclusive;
}
