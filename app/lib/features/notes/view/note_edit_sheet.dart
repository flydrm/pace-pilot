import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../tasks/providers/task_providers.dart';
import 'select_task_for_note_sheet.dart';

class NoteEditSheet extends ConsumerStatefulWidget {
  const NoteEditSheet({super.key, this.note, this.taskId});

  final domain.Note? note;
  final String? taskId;

  @override
  ConsumerState<NoteEditSheet> createState() => _NoteEditSheetState();
}

class _NoteEditSheetState extends ConsumerState<NoteEditSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _tagsController;
  String? _taskId;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _titleController = TextEditingController(text: note?.title.value ?? '');
    _bodyController = TextEditingController(text: note?.body ?? '');
    _tagsController = TextEditingController(text: note?.tags.join(',') ?? '');
    _taskId = widget.taskId ?? note?.taskId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    final taskId = _taskId;
    final taskAsync = taskId == null ? null : ref.watch(taskByIdProvider(taskId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                isEdit ? '编辑笔记' : '新增笔记',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                autofocus: !isEdit,
                decoration: const InputDecoration(labelText: '标题（必填）'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入标题';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: '正文',
                  hintText: '支持 Markdown（先按纯文本保存）',
                ),
                minLines: 6,
                maxLines: 16,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: '关联任务（可选）'),
                      child: taskId == null
                          ? const Text('未关联')
                          : taskAsync!.when(
                              loading: () => const Text('加载中…'),
                              error: (_, _) => const Text('加载失败'),
                              data: (task) => Text(
                                task == null ? '任务不存在或已删除' : task.title.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: '选择任务',
                    onPressed: () => _pickTask(context),
                    icon: const Icon(Icons.link_outlined),
                  ),
                  IconButton(
                    tooltip: '清除关联',
                    onPressed: taskId == null ? null : () => setState(() => _taskId = null),
                    icon: const Icon(Icons.link_off_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: '标签（逗号分隔）',
                  hintText: '例如：周报, 会议纪要',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final tags = _parseTags(_tagsController.text);
                  try {
                    if (isEdit) {
                      final update = ref.read(updateNoteUseCaseProvider);
                      await update(
                        note: widget.note!,
                        title: _titleController.text,
                        body: _bodyController.text,
                        tags: tags,
                        taskId: taskId,
                      );
                    } else {
                      final create = ref.read(createNoteUseCaseProvider);
                      await create(
                        title: _titleController.text,
                        body: _bodyController.text,
                        tags: tags,
                        taskId: taskId,
                      );
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } on domain.NoteTitleEmptyException {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('标题不能为空')),
                    );
                  }
                },
                child: Text(isEdit ? '保存' : '创建'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> _pickTask(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const SelectTaskForNoteSheet(),
    );
    if (picked == null) return;
    if (!mounted) return;
    setState(() => _taskId = picked);
  }
}
