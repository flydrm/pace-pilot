import 'dart:async';

import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../tasks/providers/task_providers.dart';
import '../providers/focus_providers.dart';
import 'focus_wrapup_sheet.dart';
import 'select_task_sheet.dart';

class FocusPage extends ConsumerStatefulWidget {
  const FocusPage({super.key, this.taskId});

  final String? taskId;

  @override
  ConsumerState<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends ConsumerState<FocusPage> {
  String? _selectedTaskId;
  bool _wrapUpOpen = false;
  bool _finishingBreak = false;
  domain.PomodoroPhase? _pendingBreakPhase;
  int? _pendingBreakMinutes;
  String? _pendingBreakTaskId;

  @override
  void initState() {
    super.initState();
    _selectedTaskId = widget.taskId;
  }

  @override
  void didUpdateWidget(covariant FocusPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.taskId != null && widget.taskId != oldWidget.taskId) {
      _selectedTaskId = widget.taskId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activePomodoroProvider);
    return AppPageScaffold(
      title: '专注',
      body: activeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败：$error')),
        data: (active) {
          if (active == null) {
            return _FocusIdleView(
              selectedTaskId: _selectedTaskId,
              pendingBreakPhase: _pendingBreakPhase,
              pendingBreakMinutes: _pendingBreakMinutes,
              pendingBreakTaskId: _pendingBreakTaskId,
              onDismissBreak: () => setState(() {
                _pendingBreakPhase = null;
                _pendingBreakMinutes = null;
                _pendingBreakTaskId = null;
              }),
              onStartBreak: () async {
                final phase = _pendingBreakPhase;
                final minutes = _pendingBreakMinutes;
                final taskId = _pendingBreakTaskId;
                if (phase == null || minutes == null || taskId == null) return;
                final config = await ref.read(pomodoroConfigProvider.future);
                await _startBreak(
                  taskId: taskId,
                  phase: phase,
                  minutes: minutes,
                  config: config,
                );
                if (mounted) {
                  setState(() {
                    _pendingBreakPhase = null;
                    _pendingBreakMinutes = null;
                    _pendingBreakTaskId = null;
                  });
                }
              },
              onPickTask: () async {
                final picked = await _pickTask(context);
                if (picked == null) return;
                setState(() => _selectedTaskId = picked);
              },
              onStart: () async {
                final taskId = _selectedTaskId ?? await _pickTask(context);
                if (taskId == null) return;
                setState(() => _selectedTaskId = taskId);

                final start = ref.read(startPomodoroUseCaseProvider);
                final config = await ref.read(pomodoroConfigProvider.future);
                final active = await start(taskId: taskId, config: config);
                setState(() {
                  _pendingBreakPhase = null;
                  _pendingBreakMinutes = null;
                  _pendingBreakTaskId = null;
                });

                final notifications = ref.read(localNotificationsServiceProvider);
                final granted =
                    await notifications.requestNotificationsPermissionIfNeeded();
                if (!granted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('通知未开启：到点将仅在应用内提示，建议在系统设置开启。'),
                    ),
                  );
                }

                await _schedulePomodoroNotification(active, config);
              },
            );
          }

          return _FocusActiveView(
            active: active,
            onPause: () async {
              await ref.read(pausePomodoroUseCaseProvider)();
              await ref.read(cancelPomodoroNotificationUseCaseProvider)();
            },
            onResume: () async {
              final config = await ref.read(pomodoroConfigProvider.future);
              final resumed = await ref.read(resumePomodoroUseCaseProvider)();
              if (resumed == null) return;

              final notifications = ref.read(localNotificationsServiceProvider);
              final granted =
                  await notifications.requestNotificationsPermissionIfNeeded();
              if (!granted && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('通知未开启：到点将仅在应用内提示，建议在系统设置开启。'),
                  ),
                );
              }

              await _schedulePomodoroNotification(resumed, config);
            },
            onEndEarly: () async {
              if (active.phase != domain.PomodoroPhase.focus) return;
              await _showWrapUp(context, active, actualEndAt: DateTime.now());
            },
            onTimeUp: () async {
              if (active.phase == domain.PomodoroPhase.focus) {
                await _showWrapUp(context, active, actualEndAt: active.endAt);
                return;
              }
              await _finishBreak(active);
            },
            onWrapUp: () async {
              if (active.phase != domain.PomodoroPhase.focus) return;
              final endAt = active.endAt ?? DateTime.now();
              await _showWrapUp(context, active, actualEndAt: endAt);
            },
            onDiscard: () async {
              await ref.read(cancelPomodoroNotificationUseCaseProvider)();
              await ref.read(activePomodoroRepositoryProvider).clear();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(active.isBreak ? '已跳过休息' : '已放弃本次专注记录'),
                ),
              );
            },
            onPickNextTask: () async {
              final picked = await _pickTask(context);
              if (picked == null) return;
              if (!mounted) return;
              setState(() => _selectedTaskId = picked);
            },
            onStartNext: () async {
              final config = await ref.read(pomodoroConfigProvider.future);
              final taskId = _selectedTaskId ?? active.taskId;
              final start = ref.read(startPomodoroUseCaseProvider);
              final next = await start(taskId: taskId, config: config);

              final notifications = ref.read(localNotificationsServiceProvider);
              final granted =
                  await notifications.requestNotificationsPermissionIfNeeded();
              if (!granted && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('通知未开启：到点将仅在应用内提示，建议在系统设置开启。'),
                  ),
                );
              }
              await _schedulePomodoroNotification(next, config);
            },
          );
        },
      ),
    );
  }

  Future<String?> _pickTask(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const SelectTaskSheet(),
    );
  }

  Future<void> _showWrapUp(
    BuildContext context,
    domain.ActivePomodoro active, {
    DateTime? actualEndAt,
  }) async {
    if (active.phase != domain.PomodoroPhase.focus) return;
    if (_wrapUpOpen) return;
    _wrapUpOpen = true;

    try {
      await ref.read(cancelPomodoroNotificationUseCaseProvider)();
      await _markActiveFinished(active, actualEndAt: actualEndAt);
      final taskAsync = await ref.read(taskByIdProvider(active.taskId).future);
      final taskTitle = taskAsync?.title.value ?? '专注结束';

      if (!context.mounted) return;
      final result = await showModalBottomSheet<FocusWrapUpResult>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => FocusWrapUpSheet(taskTitle: taskTitle),
      );

      if (result == null) return;

      final action = result.action;
      final note = result.note;

      if (action == FocusWrapUpAction.discard) {
        await ref.read(activePomodoroRepositoryProvider).clear();
        if (mounted) {
          setState(() {
            _pendingBreakPhase = null;
            _pendingBreakMinutes = null;
            _pendingBreakTaskId = null;
          });
        }
        return;
      }

      final complete = ref.read(completePomodoroUseCaseProvider);
      final session = await complete(
        progressNote: note,
        isDraft: action == FocusWrapUpAction.later,
      );

      if (!context.mounted) return;
      if (session == null) return;

      final message = action == FocusWrapUpAction.later ? '已创建进展草稿，可稍后补' : '已保存进展记录';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: '撤销',
            onPressed: () {
              ref.read(pomodoroSessionRepositoryProvider).deleteSession(session.id);
            },
          ),
        ),
      );

      final config = await ref.read(pomodoroConfigProvider.future);
      final suggestion = await _computeBreakSuggestion(config, session.taskId);
      if (suggestion == null) return;

      if (config.autoStartBreak) {
        await _startBreak(
          taskId: suggestion.taskId,
          phase: suggestion.phase,
          minutes: suggestion.minutes,
          config: config,
        );
        return;
      }

      if (!mounted) return;
      setState(() {
        _pendingBreakPhase = suggestion.phase;
        _pendingBreakMinutes = suggestion.minutes;
        _pendingBreakTaskId = suggestion.taskId;
      });
    } finally {
      _wrapUpOpen = false;
    }
  }

  Future<_BreakSuggestion?> _computeBreakSuggestion(
    domain.PomodoroConfig config,
    String taskId,
  ) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final count = await ref
        .read(pomodoroSessionRepositoryProvider)
        .watchCountBetween(start, end)
        .first;

    final every = config.longBreakEvery.clamp(2, 10);
    final useLongBreak = count > 0 && every > 0 && count % every == 0;
    final phase = useLongBreak ? domain.PomodoroPhase.longBreak : domain.PomodoroPhase.shortBreak;
    final minutes = useLongBreak ? config.longBreakMinutes : config.shortBreakMinutes;
    final safeMinutes = minutes.clamp(1, 120);

    return _BreakSuggestion(taskId: taskId, phase: phase, minutes: safeMinutes);
  }

  Future<void> _markActiveFinished(
    domain.ActivePomodoro active, {
    DateTime? actualEndAt,
  }) async {
    final now = DateTime.now();
    final endAt = actualEndAt ?? active.endAt ?? now;
    if (active.status == domain.ActivePomodoroStatus.finished &&
        active.endAt != null &&
        active.endAt!.isAtSameMomentAs(endAt)) {
      return;
    }
    final finished = domain.ActivePomodoro(
      taskId: active.taskId,
      phase: active.phase,
      status: domain.ActivePomodoroStatus.finished,
      startAt: active.startAt,
      endAt: endAt,
      updatedAt: now,
    );
    await ref.read(activePomodoroRepositoryProvider).upsert(finished);
  }

  Future<void> _schedulePomodoroNotification(
    domain.ActivePomodoro active,
    domain.PomodoroConfig config,
  ) async {
    final endAt = active.endAt;
    if (endAt == null) return;

    final title = await _notificationTitleFor(active);

    await ref.read(schedulePomodoroNotificationUseCaseProvider)(
          taskId: active.taskId,
          taskTitle: title,
          endAt: endAt,
          playSound: config.notificationSound,
          enableVibration: config.notificationVibration,
        );
  }

  Future<String> _notificationTitleFor(domain.ActivePomodoro active) async {
    return switch (active.phase) {
      domain.PomodoroPhase.focus => () async {
          final taskAsync = await ref.read(taskByIdProvider(active.taskId).future);
          final taskTitle = taskAsync?.title.value.trim() ?? '';
          if (taskTitle.isEmpty) return '专注结束';
          return '专注结束 · $taskTitle';
        }(),
      domain.PomodoroPhase.shortBreak => Future.value('短休结束'),
      domain.PomodoroPhase.longBreak => Future.value('长休结束'),
    };
  }

  Future<void> _startBreak({
    required String taskId,
    required domain.PomodoroPhase phase,
    required int minutes,
    required domain.PomodoroConfig config,
  }) async {
    final messenger = ScaffoldMessenger.maybeOf(context);

    final safeMinutes = minutes.clamp(1, 120);
    final now = DateTime.now();
    final endAt = now.add(Duration(minutes: safeMinutes));
    final state = domain.ActivePomodoro(
      taskId: taskId,
      phase: phase,
      status: domain.ActivePomodoroStatus.running,
      startAt: now,
      endAt: endAt,
      updatedAt: now,
    );
    await ref.read(activePomodoroRepositoryProvider).upsert(state);

    if (mounted) {
      setState(() => _selectedTaskId = taskId);
    }

    final notifications = ref.read(localNotificationsServiceProvider);
    final granted = await notifications.requestNotificationsPermissionIfNeeded();
    if (!granted && mounted && messenger != null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('通知未开启：到点将仅在应用内提示，建议在系统设置开启。'),
        ),
      );
    }

    await _schedulePomodoroNotification(state, config);
  }

  Future<void> _finishBreak(domain.ActivePomodoro active) async {
    if (_finishingBreak) return;
    _finishingBreak = true;
    try {
      final messenger = ScaffoldMessenger.maybeOf(context);

      await ref.read(cancelPomodoroNotificationUseCaseProvider)();
      await _markActiveFinished(active, actualEndAt: DateTime.now());

      final config = await ref.read(pomodoroConfigProvider.future);
      if (!config.autoStartFocus) {
        if (mounted && messenger != null) {
          messenger.showSnackBar(const SnackBar(content: Text('休息结束')));
        }
        return;
      }

      final taskId = _selectedTaskId ?? active.taskId;
      final start = ref.read(startPomodoroUseCaseProvider);
      final next = await start(taskId: taskId, config: config);

      final notifications = ref.read(localNotificationsServiceProvider);
      final granted = await notifications.requestNotificationsPermissionIfNeeded();
      if (!granted && mounted && messenger != null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('通知未开启：到点将仅在应用内提示，建议在系统设置开启。'),
          ),
        );
      }
      await _schedulePomodoroNotification(next, config);

      if (mounted && messenger != null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('休息结束，已开始下一段专注')),
        );
      }
    } finally {
      _finishingBreak = false;
    }
  }
}

class _BreakSuggestion {
  const _BreakSuggestion({
    required this.taskId,
    required this.phase,
    required this.minutes,
  });

  final String taskId;
  final domain.PomodoroPhase phase;
  final int minutes;
}

class _FocusIdleView extends ConsumerWidget {
  const _FocusIdleView({
    required this.selectedTaskId,
    required this.pendingBreakPhase,
    required this.pendingBreakMinutes,
    required this.pendingBreakTaskId,
    required this.onStartBreak,
    required this.onDismissBreak,
    required this.onPickTask,
    required this.onStart,
  });

  final String? selectedTaskId;
  final domain.PomodoroPhase? pendingBreakPhase;
  final int? pendingBreakMinutes;
  final String? pendingBreakTaskId;
  final VoidCallback onStartBreak;
  final VoidCallback onDismissBreak;
  final VoidCallback onPickTask;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = selectedTaskId;
    final taskAsync = id == null ? null : ref.watch(taskByIdProvider(id));
    final durationAsync = ref.watch(pomodoroConfigProvider);
    final minutes = durationAsync.maybeWhen(
      data: (c) => c.workDurationMinutes,
      orElse: () => 25,
    );

    final breakPhase = pendingBreakPhase;
    final breakMinutes = pendingBreakMinutes;
    final breakTaskId = pendingBreakTaskId;
    final breakTaskAsync =
        breakTaskId == null ? null : ref.watch(taskByIdProvider(breakTaskId));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (breakPhase != null && breakMinutes != null && breakTaskId != null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '建议休息',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_breakLabel(breakPhase)} ${breakMinutes}min'
                    '${breakTaskAsync == null ? '' : ' · ${_taskTitleText(breakTaskAsync)}'}',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDismissBreak,
                          child: const Text('忽略'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: onStartBreak,
                          child: const Text('开始休息'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '本次专注任务',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (taskAsync == null)
                  const Text('未选择任务')
                else
                  taskAsync.when(
                    loading: () => const Text('加载中…'),
                    error: (e, st) => const Text('任务加载失败'),
                    data: (task) =>
                        Text(task == null ? '任务不存在或已删除' : task.title.value),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPickTask,
                        child: const Text('选择/更换任务'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: onStart,
                        child: Text('开始专注 ${minutes}min'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('提示：专注到点后会进入收尾（保存/稍后补）。'),
          ),
        ),
      ],
    );
  }

  String _breakLabel(domain.PomodoroPhase phase) => switch (phase) {
        domain.PomodoroPhase.focus => '专注',
        domain.PomodoroPhase.shortBreak => '短休',
        domain.PomodoroPhase.longBreak => '长休',
      };

  String _taskTitleText(AsyncValue<domain.Task?> taskAsync) {
    return taskAsync.when(
      loading: () => '加载中…',
      error: (_, stackTrace) => '任务加载失败',
      data: (task) => task?.title.value ?? '任务不存在或已删除',
    );
  }
}

class _FocusActiveView extends ConsumerWidget {
  const _FocusActiveView({
    required this.active,
    required this.onPause,
    required this.onResume,
    required this.onEndEarly,
    required this.onTimeUp,
    required this.onWrapUp,
    required this.onDiscard,
    required this.onPickNextTask,
    required this.onStartNext,
  });

  final domain.ActivePomodoro active;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onEndEarly;
  final VoidCallback onTimeUp;
  final VoidCallback onWrapUp;
  final VoidCallback onDiscard;
  final VoidCallback onPickNextTask;
  final VoidCallback onStartNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskByIdProvider(active.taskId));
    final taskTitle = taskAsync.when(
      loading: () => '加载中…',
      error: (e, st) => '任务加载失败',
      data: (task) => task?.title.value ?? '任务不存在或已删除',
    );

    final isRunning = active.status == domain.ActivePomodoroStatus.running;
    final isPaused = active.status == domain.ActivePomodoroStatus.paused;
    final isFinished = active.status == domain.ActivePomodoroStatus.finished;
    final isBreak = active.isBreak;
    final phaseLabel = switch (active.phase) {
      domain.PomodoroPhase.focus => '专注',
      domain.PomodoroPhase.shortBreak => '短休',
      domain.PomodoroPhase.longBreak => '长休',
    };

    final todayCountAsync = ref.watch(todayPomodoroCountProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '当前状态',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (isBreak)
                  Text('$phaseLabel · 上一任务：$taskTitle')
                else
                  Text('$phaseLabel · $taskTitle'),
                const SizedBox(height: 16),
                if (isRunning && active.endAt != null)
                  _CountdownText(endAt: active.endAt!, onFinished: onTimeUp)
                else if (isPaused)
                  _StaticRemainingText(remaining: Duration(milliseconds: active.remainingMs ?? 0))
                else if (isFinished)
                  Text(
                    isBreak ? '休息结束' : '已结束，待收尾…',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )
                else
                  const Text('等待收尾…'),
                const SizedBox(height: 16),
                if (isFinished)
                  isBreak
                      ? Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: onDiscard,
                                child: const Text('结束休息'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: onStartNext,
                                child: const Text('开始下一段'),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: onDiscard,
                                child: const Text('不记录'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: onWrapUp,
                                child: const Text('去收尾'),
                              ),
                            ),
                          ],
                        )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isBreak ? onDiscard : onEndEarly,
                          child: Text(isBreak ? '跳过' : '结束'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: isRunning
                              ? onPause
                              : isPaused
                                  ? onResume
                                  : null,
                          child: Text(isRunning ? '暂停' : '继续'),
                        ),
                      ),
                    ],
                  ),
                if (isBreak && isFinished) ...[
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: onPickNextTask,
                    child: const Text('换任务再开始'),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        todayCountAsync.when(
          data: (count) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('今日已完成 $count 个番茄'),
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _CountdownText extends StatefulWidget {
  const _CountdownText({required this.endAt, required this.onFinished});

  final DateTime endAt;
  final VoidCallback onFinished;

  @override
  State<_CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<_CountdownText> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void didUpdateWidget(covariant _CountdownText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endAt != widget.endAt) {
      _tick();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    final now = DateTime.now();
    final remaining = widget.endAt.difference(now);
    final next = remaining.isNegative ? Duration.zero : remaining;
    if (mounted) {
      setState(() => _remaining = next);
    }
    if (next == Duration.zero) {
      _timer?.cancel();
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return Text(
      '$mm:$ss',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
    );
  }
}

class _StaticRemainingText extends StatelessWidget {
  const _StaticRemainingText({required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    return Text(
      '$mm:$ss',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
    );
  }
}
