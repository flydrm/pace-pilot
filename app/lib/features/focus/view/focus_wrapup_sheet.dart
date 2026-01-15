import 'package:ai/ai.dart' as ai;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai/providers/ai_providers.dart';

enum FocusWrapUpAction { save, later, discard }

class FocusWrapUpResult {
  const FocusWrapUpResult({required this.action, this.note});

  final FocusWrapUpAction action;
  final String? note;
}

class FocusWrapUpSheet extends ConsumerStatefulWidget {
  const FocusWrapUpSheet({super.key, required this.taskTitle});

  final String taskTitle;

  @override
  ConsumerState<FocusWrapUpSheet> createState() => _FocusWrapUpSheetState();
}

class _FocusWrapUpSheetState extends ConsumerState<FocusWrapUpSheet> {
  final TextEditingController _controller = TextEditingController();
  ai.AiCancelToken? _cancelToken;
  bool _aiLoading = false;
  bool _hasInput = false;

  @override
  void dispose() {
    _cancelToken?.cancel('dispose');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final configAsync = ref.watch(aiConfigProvider);
    final ready = configAsync.maybeWhen(
      data: (c) => c != null && (c.apiKey?.trim().isNotEmpty ?? false),
      orElse: () => false,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '收尾 · ${widget.taskTitle}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '一句话进展',
                hintText: '例如：完成了接口对齐与参数校验（也可直接点 AI 生成/优化）',
                border: OutlineInputBorder(),
              ),
              minLines: 2,
              maxLines: 5,
              onChanged: (v) => setState(() => _hasInput = v.trim().isNotEmpty),
            ),
            const SizedBox(height: 12),
            const Text(
              '将发送：任务标题 + 你在此处输入的一句话（如有）。',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: !ready
                  ? null
                  : (_aiLoading ? _cancelAiPolish : _aiAssist),
              icon: _aiLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome_outlined),
              label: Text(
                !ready
                    ? 'AI 未配置'
                    : (_aiLoading
                          ? (_hasInput ? 'AI 优化中…（点此停止）' : 'AI 生成中…（点此停止）')
                          : (_hasInput ? 'AI 优化' : 'AI 生成')),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(
                      FocusWrapUpResult(
                        action: FocusWrapUpAction.later,
                        note: _controller.text,
                      ),
                    ),
                    child: const Text('稍后补'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(
                      FocusWrapUpResult(
                        action: FocusWrapUpAction.save,
                        note: _controller.text,
                      ),
                    ),
                    child: const Text('保存'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(
                context,
              ).pop(const FocusWrapUpResult(action: FocusWrapUpAction.discard)),
              child: const Text('不记录这次专注'),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelAiPolish() {
    _cancelToken?.cancel('user');
  }

  Future<void> _aiAssist() async {
    final input = _controller.text.trim();
    final config = await ref.read(aiConfigProvider.future);
    if (config == null || (config.apiKey?.trim().isEmpty ?? true)) {
      _showSnack('请先完成 AI 配置');
      return;
    }

    final cancelToken = ai.AiCancelToken();
    setState(() {
      _aiLoading = true;
      _cancelToken = cancelToken;
    });
    try {
      final client = ref.read(openAiClientProvider);
      final nextText = input.isEmpty
          ? await client.generateProgressNote(
              config: config,
              taskTitle: widget.taskTitle,
              cancelToken: cancelToken,
            )
          : await client.polishProgressNote(
              config: config,
              taskTitle: widget.taskTitle,
              input: input,
              cancelToken: cancelToken,
            );
      if (!mounted) return;
      setState(() {
        _controller.text = nextText;
        _hasInput = nextText.trim().isNotEmpty;
      });
    } on ai.AiClientCancelledException {
      _showSnack('已取消');
    } catch (e) {
      _showSnack('${input.isEmpty ? 'AI 生成' : 'AI 优化'}失败：$e');
    } finally {
      if (identical(_cancelToken, cancelToken)) {
        _cancelToken = null;
      }
      if (mounted) setState(() => _aiLoading = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
