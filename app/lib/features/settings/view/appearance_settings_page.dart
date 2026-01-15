import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearanceAsync = ref.watch(appearanceConfigProvider);

    return AppPageScaffold(
      title: '外观',
      showSettingsAction: false,
      body: appearanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败：$error')),
        data: (config) => _AppearanceSettingsBody(config: config),
      ),
    );
  }
}

class _AppearanceSettingsBody extends ConsumerWidget {
  const _AppearanceSettingsBody({required this.config});

  final domain.AppearanceConfig config;

  Color _accentSwatch(domain.AppAccent accent, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (accent) {
      domain.AppAccent.a =>
        isDark ? const Color(0xFF7AA6FF) : const Color(0xFF2F5D9B),
      domain.AppAccent.b =>
        isDark ? const Color(0xFF44C2B3) : const Color(0xFF0F766E),
      domain.AppAccent.c =>
        isDark ? const Color(0xFFB8C48A) : const Color(0xFF5B6B3A),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(appearanceConfigRepositoryProvider);
    final brightness = Theme.of(context).brightness;

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
                  '主题',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SegmentedButton<domain.AppThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: domain.AppThemeMode.system,
                      icon: Icon(Icons.settings_outlined),
                      label: Text('系统'),
                    ),
                    ButtonSegment(
                      value: domain.AppThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('浅色'),
                    ),
                    ButtonSegment(
                      value: domain.AppThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('深色'),
                    ),
                  ],
                  selected: {config.themeMode},
                  onSelectionChanged: (value) async {
                    final next = value.first;
                    if (next == config.themeMode) return;
                    await repo.save(
                      domain.AppearanceConfig(
                        themeMode: next,
                        density: config.density,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '密度',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  value: config.density == domain.AppDensity.compact,
                  onChanged: (v) async {
                    final next = v ? domain.AppDensity.compact : domain.AppDensity.comfortable;
                    if (next == config.density) return;
                    await repo.save(
                      domain.AppearanceConfig(
                        themeMode: config.themeMode,
                        density: next,
                        accent: config.accent,
                      ),
                    );
                  },
                  title: const Text('紧凑模式'),
                  subtitle: const Text('列表更紧凑，信息密度更高'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Accent',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SegmentedButton<domain.AppAccent>(
                  segments: [
                    ButtonSegment(
                      value: domain.AppAccent.a,
                      icon: Icon(
                        Icons.circle,
                        color: _accentSwatch(domain.AppAccent.a, brightness),
                      ),
                      label: const Text('A'),
                    ),
                    ButtonSegment(
                      value: domain.AppAccent.b,
                      icon: Icon(
                        Icons.circle,
                        color: _accentSwatch(domain.AppAccent.b, brightness),
                      ),
                      label: const Text('B'),
                    ),
                    ButtonSegment(
                      value: domain.AppAccent.c,
                      icon: Icon(
                        Icons.circle,
                        color: _accentSwatch(domain.AppAccent.c, brightness),
                      ),
                      label: const Text('C'),
                    ),
                  ],
                  selected: {config.accent},
                  onSelectionChanged: (value) async {
                    final next = value.first;
                    if (next == config.accent) return;
                    await repo.save(
                      domain.AppearanceConfig(
                        themeMode: config.themeMode,
                        density: config.density,
                        accent: next,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: config.themeMode == domain.AppThemeMode.system &&
                          config.density == domain.AppDensity.comfortable &&
                          config.accent == domain.AppAccent.a
                      ? null
                      : () async {
                          await repo.save(const domain.AppearanceConfig());
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已恢复默认外观')),
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
            child: Text('风格默认偏“安静、商务、稳重”：低饱和配色 + 清晰层级。'),
          ),
        ),
      ],
    );
  }
}
