import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../ui/scaffolds/app_page_scaffold.dart';
import '../providers/note_providers.dart';
import 'note_edit_sheet.dart';
import 'note_list_item.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(filteredNotesProvider);
    final tags = ref.watch(availableNoteTagsProvider);
    final selectedTag = ref.watch(selectedNoteTagProvider);
    return AppPageScaffold(
      title: '笔记',
      floatingActionButton: FloatingActionButton(
        tooltip: '新增笔记',
        onPressed: () => _openCreateSheet(context),
        child: const Icon(Icons.add),
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败：$error')),
        data: (notes) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('全部'),
                        selected: selectedTag == null,
                        onSelected: (_) =>
                            ref.read(selectedNoteTagProvider.notifier).state = null,
                      ),
                      for (final tag in tags)
                        ChoiceChip(
                          label: Text(tag),
                          selected: selectedTag == tag,
                          onSelected: (_) {
                            final next = selectedTag == tag ? null : tag;
                            ref.read(selectedNoteTagProvider.notifier).state = next;
                          },
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedTag == null
                                  ? '还没有笔记。'
                                  : '暂无「$selectedTag」相关笔记。',
                            ),
                            const SizedBox(height: 8),
                            if (selectedTag == null)
                              FilledButton(
                                onPressed: () => _openCreateSheet(context),
                                child: const Text('写一条'),
                              )
                            else
                              FilledButton(
                                onPressed: () => ref
                                    .read(selectedNoteTagProvider.notifier)
                                    .state = null,
                                child: const Text('清除筛选'),
                              ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: notes.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 0),
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return NoteListItem(
                            note: note,
                            onTap: () => context.push('/notes/${note.id}'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const NoteEditSheet(),
    );
  }
}
