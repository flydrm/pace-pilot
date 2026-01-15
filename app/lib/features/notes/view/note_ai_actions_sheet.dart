import 'package:flutter/material.dart';

enum NoteAiAction { summary, actionItems, rewriteForSharing }

class NoteAiActionsSheet extends StatelessWidget {
  const NoteAiActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: const [
            Text(
              'AI 动作',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              '只在你点击后发送当前笔记内容；结果先预览再采用，且支持撤销。',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 12),
            _AiActionTile(
              icon: Icons.summarize_outlined,
              title: '总结要点',
              subtitle: '生成可编辑的总结草稿，并可写回笔记（可撤销）。',
              action: NoteAiAction.summary,
            ),
            _AiActionTile(
              icon: Icons.playlist_add_check_outlined,
              title: '提取行动项',
              subtitle: '生成可编辑的行动项清单，并可批量导入为任务（可撤销）。',
              action: NoteAiAction.actionItems,
            ),
            _AiActionTile(
              icon: Icons.share_outlined,
              title: '改写同步版',
              subtitle: '生成可编辑的对外同步文案草稿，并可写回笔记（可撤销）。',
              action: NoteAiAction.rewriteForSharing,
            ),
          ],
        ),
      ),
    );
  }
}

class _AiActionTile extends StatelessWidget {
  const _AiActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final NoteAiAction action;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).pop(action),
      ),
    );
  }
}
