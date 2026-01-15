import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../providers/ai_providers.dart';

class AiPage extends ConsumerWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(aiConfigProvider);

    return AppPageScaffold(
      title: 'AI（效率台）',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          configAsync.when(
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
              final ready = config != null &&
                  config.apiKey != null &&
                  config.apiKey!.trim().isNotEmpty;

              return Card(
                child: ListTile(
                  leading: Icon(
                    ready ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                  ),
                  title: Text(ready ? 'AI 已就绪' : 'AI 未配置'),
                  subtitle: Text(
                    ready
                        ? '${config.model} · ${_shortBaseUrl(config.baseUrl)}'
                        : '先在设置里配置 baseUrl / model / apiKey',
                  ),
                  trailing: TextButton(
                    onPressed: () => context.push('/settings/ai'),
                    child: const Text('设置'),
                  ),
                  onTap: () => context.push('/settings/ai'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _AiActionCard(
            title: 'AI 速记',
            description: '把零散输入整理成可保存的笔记草稿。',
            cta: '开始',
            onTap: () => context.push('/ai/quick-note'),
          ),
          const SizedBox(height: 12),
          _AiActionCard(
            title: '一句话拆任务',
            description: '把输入变清楚：生成可编辑的任务清单草稿。',
            cta: '开始',
            onTap: () => context.push('/ai/breakdown'),
          ),
          const SizedBox(height: 12),
          _AiActionCard(
            title: '问答检索',
            description: 'Evidence-first：回答必须附可跳转引用。',
            cta: '进入',
            onTap: () => context.push('/ai/ask'),
          ),
          const SizedBox(height: 12),
          _AiActionCard(
            title: '今日计划',
            description: '从现有任务生成“今日计划”草稿（可编辑后保存）。',
            cta: '进入',
            onTap: () => context.push('/ai/today-plan'),
          ),
          const SizedBox(height: 12),
          _AiActionCard(
            title: '昨日回顾',
            description: '基于本地证据生成日报草稿，且只追加不覆盖。',
            cta: '进入',
            onTap: () => context.push('/ai/daily'),
          ),
          const SizedBox(height: 12),
          _AiActionCard(
            title: '周复盘',
            description: '基于本地证据生成草稿，且只追加不覆盖。',
            cta: '进入',
            onTap: () => context.push('/ai/weekly'),
          ),
        ],
      ),
    );
  }

  String _shortBaseUrl(String baseUrl) {
    final trimmed = baseUrl.trim();
    if (trimmed.length <= 32) return trimmed;
    return '${trimmed.substring(0, 32)}…';
  }
}

class _AiActionCard extends StatelessWidget {
  const _AiActionCard({
    required this.title,
    required this.description,
    required this.cta,
    required this.onTap,
  });

  final String title;
  final String description;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onTap,
              child: Text(cta),
            ),
          ],
        ),
      ),
    );
  }
}
