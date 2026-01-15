import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroAsync = ref.watch(pomodoroConfigProvider);
    final pomodoroSubtitle = pomodoroAsync.maybeWhen(
      data: (c) => '专注时长：${c.workDurationMinutes} 分钟',
      orElse: () => '专注时长：加载中…',
    );

    final appearanceAsync = ref.watch(appearanceConfigProvider);
    final appearanceSubtitle = appearanceAsync.maybeWhen(
      data: (c) => '主题：${_themeModeLabel(c.themeMode)} / 密度：${_densityLabel(c.density)}',
      orElse: () => '主题：加载中…',
    );

    return AppPageScaffold(
      title: '设置',
      showSettingsAction: false,
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.auto_awesome_outlined),
            title: Text('AI'),
            subtitle: Text('baseUrl / model / apiKey'),
            onTap: () => context.push('/settings/ai'),
          ),
          ListTile(
            leading: Icon(Icons.timer_outlined),
            title: Text('番茄'),
            subtitle: Text(pomodoroSubtitle),
            onTap: () => context.push('/settings/pomodoro'),
          ),
          ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('数据'),
            subtitle: Text('导出/备份/恢复/清空'),
            onTap: () => context.push('/settings/data'),
          ),
          ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('外观'),
            subtitle: Text(appearanceSubtitle),
            onTap: () => context.push('/settings/appearance'),
          ),
        ],
      ),
    );
  }
}

String _themeModeLabel(domain.AppThemeMode mode) {
  return switch (mode) {
    domain.AppThemeMode.system => '系统',
    domain.AppThemeMode.light => '浅色',
    domain.AppThemeMode.dark => '深色',
  };
}

String _densityLabel(domain.AppDensity density) {
  return switch (density) {
    domain.AppDensity.comfortable => '舒适',
    domain.AppDensity.compact => '紧凑',
  };
}
