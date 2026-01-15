import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../ai/providers/ai_providers.dart';

class AiSettingsPage extends ConsumerStatefulWidget {
  const AiSettingsPage({super.key});

  @override
  ConsumerState<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends ConsumerState<AiSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _baseUrlController;
  late final TextEditingController _modelController;
  late final TextEditingController _apiKeyController;

  bool _saving = false;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController();
    _modelController = TextEditingController();
    _apiKeyController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _modelController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final existing = await ref.read(aiConfigRepositoryProvider).getConfig();
    if (!mounted) return;
    setState(() {
      _baseUrlController.text = existing?.baseUrl ?? 'https://api.openai.com';
      _modelController.text = existing?.model ?? 'gpt-4o-mini';
      _apiKeyController.text = existing?.apiKey ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'AI 设置',
      showSettingsAction: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '提示：apiKey 仅本地密文存储，不会被备份导出。',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _baseUrlController,
                  decoration: const InputDecoration(
                    labelText: 'baseUrl',
                    hintText: '例如：https://api.openai.com 或 https://xxx/v1',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return '请输入 baseUrl';
                    if (!v.startsWith('http://') && !v.startsWith('https://')) {
                      return 'baseUrl 需以 http:// 或 https:// 开头';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(
                    labelText: 'model',
                    hintText: '例如：gpt-4o-mini',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) return '请输入 model';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'apiKey',
                    hintText: '以 sk-... 开头（不会展示）',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _testing ? null : _testConnection,
                        child: Text(_testing ? '测试中…' : '测试连接'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: _saving ? null : _save,
                        child: Text(_saving ? '保存中…' : '保存'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _saving || _testing ? null : _clear,
                  child: const Text('清除配置'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  domain.AiProviderConfig _configFromForm() {
    return domain.AiProviderConfig(
      baseUrl: _baseUrlController.text,
      model: _modelController.text,
      apiKey: _apiKeyController.text.trim().isEmpty ? null : _apiKeyController.text,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final config = _configFromForm();
      await ref.read(aiConfigRepositoryProvider).saveConfig(config);
      ref.invalidate(aiConfigProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已保存 AI 配置')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _testing = true);
    try {
      final config = _configFromForm();
      await ref.read(openAiClientProvider).testConnection(config: config);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('连接成功')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('连接失败：$e')),
      );
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _clear() async {
    setState(() => _saving = true);
    try {
      await ref.read(aiConfigRepositoryProvider).clear();
      ref.invalidate(aiConfigProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已清除 AI 配置')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
