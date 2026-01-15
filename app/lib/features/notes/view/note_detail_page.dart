import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../../tasks/providers/task_providers.dart';
import '../providers/note_providers.dart';
import 'note_ai_action_items_sheet.dart';
import 'note_ai_actions_sheet.dart';
import 'note_ai_rewrite_sheet.dart';
import 'note_ai_summary_sheet.dart';
import 'note_edit_sheet.dart';

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteByIdProvider(noteId));
    return noteAsync.when(
      loading: () => const AppPageScaffold(
        title: '笔记',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => AppPageScaffold(
        title: '笔记',
        body: Center(child: Text('加载失败：$error')),
      ),
      data: (note) {
        if (note == null) {
          return const AppPageScaffold(
            title: '笔记',
            body: Center(child: Text('笔记不存在或已删除')),
          );
        }

        final taskId = note.taskId;
        final taskAsync = taskId == null
            ? null
            : ref.watch(taskByIdProvider(taskId));

        return AppPageScaffold(
          title: note.title.value,
          actions: [
            IconButton(
              tooltip: 'AI 动作',
              onPressed: () => _openAiActionsSheet(context, note.id),
              icon: const Icon(Icons.auto_awesome_outlined),
            ),
            IconButton(
              tooltip: '编辑',
              onPressed: () => _openEditSheet(context, note),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                note.title.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (taskId != null) ...[
                const SizedBox(height: 12),
                Card(
                  child: taskAsync!.when(
                    loading: () => const ListTile(
                      leading: Icon(Icons.checklist_outlined),
                      title: Text('关联任务'),
                      subtitle: Text('加载中…'),
                    ),
                    error: (_, _) => const ListTile(
                      leading: Icon(Icons.checklist_outlined),
                      title: Text('关联任务'),
                      subtitle: Text('加载失败'),
                    ),
                    data: (task) => ListTile(
                      leading: const Icon(Icons.checklist_outlined),
                      title: const Text('关联任务'),
                      subtitle: Text(
                        task == null ? '任务不存在或已删除' : task.title.value,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: task == null
                          ? null
                          : () => context.push('/tasks/${task.id}'),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Text(note.body.isEmpty ? '（空）' : note.body),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openEditSheet(BuildContext context, domain.Note note) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => NoteEditSheet(note: note),
    );
  }

  Future<void> _openAiActionsSheet(BuildContext context, String noteId) async {
    final action = await showModalBottomSheet<NoteAiAction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const NoteAiActionsSheet(),
    );
    if (action == null) return;
    if (!context.mounted) return;

    switch (action) {
      case NoteAiAction.summary:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => NoteAiSummarySheet(noteId: noteId),
        );
        break;
      case NoteAiAction.actionItems:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => NoteAiActionItemsSheet(noteId: noteId),
        );
        break;
      case NoteAiAction.rewriteForSharing:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => NoteAiRewriteSheet(noteId: noteId),
        );
        break;
    }
  }
}
