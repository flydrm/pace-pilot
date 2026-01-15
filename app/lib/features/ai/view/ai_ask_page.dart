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

class AiAskPage extends ConsumerStatefulWidget {
  const AiAskPage({super.key});

  @override
  ConsumerState<AiAskPage> createState() => _AiAskPageState();
}

class _AiAskPageState extends ConsumerState<AiAskPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  int _rangeDays = 7;
  AiEvidenceType? _typeFilter;
  String? _tagFilter;
  String _query = '';

  final Set<String> _selectedKeys = <String>{};

  ai.AiCancelToken? _cancelToken;
  bool _sending = false;
  bool _saving = false;
  ai.AiEvidenceAnswer? _answer;
  String? _lastQuestion;
  String? _savedNoteId;
  List<AiEvidenceItem> _lastSelectedEvidence = const [];
  bool _didAutoSelectTopEvidence = false;

  @override
  void dispose() {
    _cancelToken?.cancel('dispose');
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(aiConfigProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    final notesAsync = ref.watch(notesStreamProvider);

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final endExclusive = todayStart.add(const Duration(days: 1));
    final startInclusive = _rangeDays >= 3650
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : endExclusive.subtract(Duration(days: _rangeDays));

    final sessionsAsync = ref.watch(
      pomodoroSessionsBetweenProvider(
        TimeRangeKey(
          startInclusive: startInclusive,
          endExclusive: endExclusive,
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
      startInclusive: startInclusive,
      endExclusive: endExclusive,
    );

    final availableTags = _availableTags(evidenceAll);
    final evidence = _applyFilters(evidenceAll);
    _pruneSelection(evidenceAll);
    _maybeAutoSelectTopEvidence(evidenceAll: evidenceAll, isLoading: isLoading);

    return AppPageScaffold(
      title: '问答检索',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConfigCard(context, configAsync),
          const SizedBox(height: 12),
          _buildQuestionCard(ready),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '证据',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildFilterRow(context),
                  if (availableTags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('全部标签'),
                          selected: _tagFilter == null,
                          onSelected: _sending
                              ? null
                              : (_) => setState(() => _tagFilter = null),
                        ),
                        for (final tag in availableTags)
                          ChoiceChip(
                            label: Text(tag),
                            selected: _tagFilter == tag,
                            onSelected: _sending
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
                    Text('当前范围内没有可用证据（默认近 $_rangeDays 天）。')
                  else if (evidence.isEmpty)
                    const Text('没有匹配的证据，请调整筛选条件。')
                  else ...[
                    Row(
                      children: [
                        TextButton(
                          onPressed: _sending
                              ? null
                              : () => setState(
                                  () => _selectedKeys
                                    ..clear()
                                    ..addAll(evidence.map((e) => e.key)),
                                ),
                          child: const Text('全选当前'),
                        ),
                        TextButton(
                          onPressed: _sending
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
                        onChanged: _sending
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
          if (_answer != null) _buildAnswerCard(context),
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
            leading: Icon(
              ready ? Icons.check_circle_outline : Icons.warning_amber_outlined,
            ),
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

  Widget _buildQuestionCard(bool ready) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '问题',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _questionController,
              enabled: !_sending,
              decoration: const InputDecoration(
                hintText: '例如：我这周最重要的风险是什么？',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 6,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: (!ready || _saving)
                  ? null
                  : (_sending ? _cancelSend : _send),
              child: Text(_sending ? '发送中…（点此停止）' : '发送（需选 ≥2 条证据）'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: _rangeDays,
                decoration: const InputDecoration(
                  labelText: '时间范围',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(value: 7, child: Text('近 7 天')),
                  DropdownMenuItem(value: 30, child: Text('近 30 天')),
                  DropdownMenuItem(value: 3650, child: Text('全部')),
                ],
                onChanged: _sending
                    ? null
                    : (v) {
                        if (v == null) return;
                        setState(() {
                          _rangeDays = v;
                          _selectedKeys.clear();
                          _answer = null;
                          _lastSelectedEvidence = const [];
                          _savedNoteId = null;
                          _didAutoSelectTopEvidence = false;
                        });
                      },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                enabled: !_sending,
                decoration: const InputDecoration(
                  labelText: '关键词',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('全部'),
              selected: _typeFilter == null,
              onSelected: _sending
                  ? null
                  : (_) => setState(() => _typeFilter = null),
            ),
            ChoiceChip(
              label: const Text('笔记'),
              selected: _typeFilter == AiEvidenceType.note,
              onSelected: _sending
                  ? null
                  : (_) => setState(() => _typeFilter = AiEvidenceType.note),
            ),
            ChoiceChip(
              label: const Text('任务'),
              selected: _typeFilter == AiEvidenceType.task,
              onSelected: _sending
                  ? null
                  : (_) => setState(() => _typeFilter = AiEvidenceType.task),
            ),
            ChoiceChip(
              label: const Text('专注'),
              selected: _typeFilter == AiEvidenceType.pomodoro,
              onSelected: _sending
                  ? null
                  : (_) =>
                        setState(() => _typeFilter = AiEvidenceType.pomodoro),
            ),
          ],
        ),
      ],
    );
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

  void _cancelSend() {
    _cancelToken?.cancel('user');
  }

  Future<void> _send() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      _showSnack('请输入问题');
      return;
    }

    final config = await ref.read(aiConfigProvider.future);
    if (config == null || (config.apiKey?.trim().isEmpty ?? true)) {
      _showSnack('请先完成 AI 配置');
      return;
    }

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final endExclusive = todayStart.add(const Duration(days: 1));
    final startInclusive = _rangeDays >= 3650
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : endExclusive.subtract(Duration(days: _rangeDays));

    final tasks = await ref.read(tasksStreamProvider.future);
    final notes = await ref.read(notesStreamProvider.future);
    final sessions = await ref.read(
      pomodoroSessionsBetweenProvider(
        TimeRangeKey(
          startInclusive: startInclusive,
          endExclusive: endExclusive,
        ),
      ).future,
    );

    final evidenceAll = _buildEvidence(
      tasks: tasks,
      notes: notes,
      sessions: sessions,
      startInclusive: startInclusive,
      endExclusive: endExclusive,
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

    final cancelToken = ai.AiCancelToken();
    setState(() {
      _sending = true;
      _cancelToken = cancelToken;
      _answer = null;
      _answerController.text = '';
      _lastQuestion = question;
      _savedNoteId = null;
      _lastSelectedEvidence = selected;
    });

    try {
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
        _answerController.text = result.answer;
      });
    } on ai.AiClientCancelledException {
      _showSnack('已取消');
    } catch (e) {
      _showSnack('问答失败：$e');
    } finally {
      if (identical(_cancelToken, cancelToken)) {
        _cancelToken = null;
      }
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _buildAnswerCard(BuildContext context) {
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
              answer.insufficientEvidence ? '回答（证据不足，可编辑）' : '回答（可编辑）',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _answerController,
              enabled: !_saving,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '可在此编辑后保存为笔记',
              ),
              minLines: 6,
              maxLines: 16,
            ),
            const SizedBox(height: 12),
            if (!answer.insufficientEvidence)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '引用',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (cited.length < 2)
                    const Text('引用不足（应为 2–5 条）。请补充更多证据后重试。')
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
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saving ? null : _saveToNote,
              child: Text(_saving ? '保存中…' : '保存为笔记（可撤销）'),
            ),
            if (_savedNoteId != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push('/notes/${_savedNoteId!}'),
                icon: const Icon(Icons.open_in_new_outlined),
                label: const Text('打开已保存笔记'),
              ),
            ],
          ],
        ),
      ),
    );
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

  Future<void> _saveToNote() async {
    final answer = _answer;
    if (answer == null) return;

    final question = _lastQuestion?.trim().isNotEmpty == true
        ? _lastQuestion!.trim()
        : _questionController.text.trim();
    final title = _buildNoteTitle(question);
    final body = _buildNoteBody(
      question: question,
      answer: _answerController.text,
    );

    setState(() => _saving = true);
    try {
      final create = ref.read(createNoteUseCaseProvider);
      final repo = ref.read(noteRepositoryProvider);
      final created = await create(
        title: title,
        body: body,
        tags: const ['ai', 'qa'],
      );

      if (!mounted) return;
      setState(() => _savedNoteId = created.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已保存为笔记'),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () {
              unawaited(repo.deleteNote(created.id));
              if (mounted && _savedNoteId == created.id) {
                setState(() => _savedNoteId = null);
              }
            },
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _buildNoteTitle(String question) {
    final q = question.trim();
    if (q.isEmpty) return 'AI 问答';
    const max = 40;
    final normalized = q.replaceAll('\n', ' ').trim();
    final clipped = normalized.length <= max
        ? normalized
        : '${normalized.substring(0, max)}…';
    return '问答：$clipped';
  }

  String _buildNoteBody({required String question, required String answer}) {
    final selected = _lastSelectedEvidence;
    final citations =
        (_answer?.citations ?? const <int>[])
            .where((i) => i >= 1 && i <= selected.length)
            .toSet()
            .toList()
          ..sort();

    final timestamp = DateTime.now();
    final header = '## AI 问答（${_formatDateTime(timestamp)}）';
    final citationList = citations.isEmpty
        ? '引用：无（证据不足或模型未按要求返回）'
        : [
            '引用：',
            for (final c in citations)
              '- [$c] ${selected[c - 1].typeLabel} · ${selected[c - 1].title}',
          ].join('\n');

    final evidenceList = <String>[
      '证据（本次发送 ${selected.length} 条）：',
      for (var i = 0; i < selected.length; i++)
        '- [${i + 1}] ${selected[i].typeLabel} · ${selected[i].title}',
    ].join('\n');

    return [
      header,
      '',
      '问题：',
      question.trim(),
      '',
      '回答：',
      answer.trimRight(),
      '',
      citationList,
      '',
      evidenceList,
    ].join('\n');
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

  String _formatDateTime(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime dt) => '${dt.month}/${dt.day}';

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
