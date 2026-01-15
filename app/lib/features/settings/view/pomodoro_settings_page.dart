import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';

class PomodoroSettingsPage extends ConsumerWidget {
  const PomodoroSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(pomodoroConfigProvider);

    return AppPageScaffold(
      title: '番茄',
      showSettingsAction: false,
      body: configAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败：$error')),
        data: (config) => _PomodoroSettingsBody(config: config),
      ),
    );
  }
}

class _PomodoroSettingsBody extends ConsumerWidget {
  const _PomodoroSettingsBody({required this.config});

  final domain.PomodoroConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(pomodoroConfigRepositoryProvider);
    final current = config.workDurationMinutes;
    final shortBreak = config.shortBreakMinutes;
    final longBreak = config.longBreakMinutes;
    final longBreakEvery = config.longBreakEvery;
    final autoStartBreak = config.autoStartBreak;
    final autoStartFocus = config.autoStartFocus;
    final sound = config.notificationSound;
    final vibration = config.notificationVibration;
    final isDefault = current == 25 &&
        shortBreak == 5 &&
        longBreak == 15 &&
        longBreakEvery == 4 &&
        autoStartBreak == false &&
        autoStartFocus == false &&
        sound == false &&
        vibration == false;

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
                  '番茄配置',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('当前：专注 $current 分钟 / 短休 $shortBreak 分钟 / 长休 $longBreak 分钟'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownMenu<int>(
                        initialSelection: current,
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('专注（分钟）'),
                        dropdownMenuEntries: [
                          for (var m = 10; m <= 60; m += 5)
                            DropdownMenuEntry(value: m, label: '$m'),
                        ],
                        onSelected: (value) async {
                          if (value == null || value == current) return;
                          await repo.save(
                            domain.PomodoroConfig(
                              workDurationMinutes: value,
                              shortBreakMinutes: shortBreak,
                              longBreakMinutes: longBreak,
                              longBreakEvery: longBreakEvery,
                              autoStartBreak: autoStartBreak,
                              autoStartFocus: autoStartFocus,
                              notificationSound: sound,
                              notificationVibration: vibration,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownMenu<int>(
                        initialSelection: shortBreak,
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('短休（分钟）'),
                        dropdownMenuEntries: [
                          for (var m = 3; m <= 30; m += 1)
                            DropdownMenuEntry(value: m, label: '$m'),
                        ],
                        onSelected: (value) async {
                          if (value == null || value == shortBreak) return;
                          await repo.save(
                            domain.PomodoroConfig(
                              workDurationMinutes: current,
                              shortBreakMinutes: value,
                              longBreakMinutes: longBreak,
                              longBreakEvery: longBreakEvery,
                              autoStartBreak: autoStartBreak,
                              autoStartFocus: autoStartFocus,
                              notificationSound: sound,
                              notificationVibration: vibration,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownMenu<int>(
                        initialSelection: longBreak,
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('长休（分钟）'),
                        dropdownMenuEntries: [
                          for (var m = 5; m <= 60; m += 5)
                            DropdownMenuEntry(value: m, label: '$m'),
                        ],
                        onSelected: (value) async {
                          if (value == null || value == longBreak) return;
                          await repo.save(
                            domain.PomodoroConfig(
                              workDurationMinutes: current,
                              shortBreakMinutes: shortBreak,
                              longBreakMinutes: value,
                              longBreakEvery: longBreakEvery,
                              autoStartBreak: autoStartBreak,
                              autoStartFocus: autoStartFocus,
                              notificationSound: sound,
                              notificationVibration: vibration,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownMenu<int>(
                        initialSelection: longBreakEvery,
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('长休间隔（N）'),
                        dropdownMenuEntries: [
                          for (var n = 2; n <= 10; n += 1)
                            DropdownMenuEntry(value: n, label: '$n'),
                        ],
                        onSelected: (value) async {
                          if (value == null || value == longBreakEvery) return;
                          await repo.save(
                            domain.PomodoroConfig(
                              workDurationMinutes: current,
                              shortBreakMinutes: shortBreak,
                              longBreakMinutes: longBreak,
                              longBreakEvery: value,
                              autoStartBreak: autoStartBreak,
                              autoStartFocus: autoStartFocus,
                              notificationSound: sound,
                              notificationVibration: vibration,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: autoStartBreak,
                  onChanged: (v) async {
                    if (v == autoStartBreak) return;
                    await repo.save(
                      domain.PomodoroConfig(
                        workDurationMinutes: current,
                        shortBreakMinutes: shortBreak,
                        longBreakMinutes: longBreak,
                        longBreakEvery: longBreakEvery,
                        autoStartBreak: v,
                        autoStartFocus: autoStartFocus,
                        notificationSound: sound,
                        notificationVibration: vibration,
                      ),
                    );
                  },
                  title: const Text('自动开始休息'),
                  subtitle: const Text('专注结束并保存后，自动进入短休/长休'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: autoStartFocus,
                  onChanged: (v) async {
                    if (v == autoStartFocus) return;
                    await repo.save(
                      domain.PomodoroConfig(
                        workDurationMinutes: current,
                        shortBreakMinutes: shortBreak,
                        longBreakMinutes: longBreak,
                        longBreakEvery: longBreakEvery,
                        autoStartBreak: autoStartBreak,
                        autoStartFocus: v,
                        notificationSound: sound,
                        notificationVibration: vibration,
                      ),
                    );
                  },
                  title: const Text('休息结束自动开始下一段'),
                  subtitle: const Text('默认关闭，避免打扰；开启后会自动开始下一段专注'),
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(height: 24),
                const Text(
                  '提醒',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SwitchListTile(
                  value: sound,
                  onChanged: (v) async {
                    if (v == sound) return;
                    await repo.save(
                      domain.PomodoroConfig(
                        workDurationMinutes: current,
                        shortBreakMinutes: shortBreak,
                        longBreakMinutes: longBreak,
                        longBreakEvery: longBreakEvery,
                        autoStartBreak: autoStartBreak,
                        autoStartFocus: autoStartFocus,
                        notificationSound: v,
                        notificationVibration: vibration,
                      ),
                    );
                  },
                  title: const Text('声音'),
                  subtitle: const Text('到点提醒播放系统提示音'),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  value: vibration,
                  onChanged: (v) async {
                    if (v == vibration) return;
                    await repo.save(
                      domain.PomodoroConfig(
                        workDurationMinutes: current,
                        shortBreakMinutes: shortBreak,
                        longBreakMinutes: longBreak,
                        longBreakEvery: longBreakEvery,
                        autoStartBreak: autoStartBreak,
                        autoStartFocus: autoStartFocus,
                        notificationSound: sound,
                        notificationVibration: v,
                      ),
                    );
                  },
                  title: const Text('震动'),
                  subtitle: const Text('到点提醒震动'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: isDefault
                      ? null
                      : () async {
                          await repo.save(const domain.PomodoroConfig());
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已恢复默认番茄配置')),
                          );
                        },
                  child: const Text('恢复默认'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('建议：专注 25–45 分钟更稳；短休 5–10 分钟；长休 15–20 分钟。'),
          ),
        ),
      ],
    );
  }
}
