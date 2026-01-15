import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';

class TaskEditSheet extends ConsumerStatefulWidget {
  const TaskEditSheet({super.key, this.task});

  final domain.Task? task;

  @override
  ConsumerState<TaskEditSheet> createState() => _TaskEditSheetState();
}

class _TaskEditSheetState extends ConsumerState<TaskEditSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;
  late final TextEditingController _estimatedController;

  late domain.TaskPriority _priority;
  late domain.TaskStatus _status;
  DateTime? _dueAt;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title.value ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _tagsController = TextEditingController(text: task?.tags.join(',') ?? '');
    _estimatedController =
        TextEditingController(text: task?.estimatedPomodoros?.toString() ?? '');

    _priority = task?.priority ?? domain.TaskPriority.medium;
    _status = task?.status ?? domain.TaskStatus.todo;
    _dueAt = task?.dueAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _estimatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                isEdit ? '编辑任务' : '新增任务',
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
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: '描述（可选）'),
                minLines: 2,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<domain.TaskPriority>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: '优先级'),
                items: const [
                  DropdownMenuItem(
                    value: domain.TaskPriority.high,
                    child: Text('高'),
                  ),
                  DropdownMenuItem(
                    value: domain.TaskPriority.medium,
                    child: Text('中'),
                  ),
                  DropdownMenuItem(
                    value: domain.TaskPriority.low,
                    child: Text('低'),
                  ),
                ],
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<domain.TaskStatus>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: '状态'),
                items: const [
                  DropdownMenuItem(
                    value: domain.TaskStatus.todo,
                    child: Text('待办'),
                  ),
                  DropdownMenuItem(
                    value: domain.TaskStatus.inProgress,
                    child: Text('进行中'),
                  ),
                  DropdownMenuItem(
                    value: domain.TaskStatus.done,
                    child: Text('已完成'),
                  ),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 12),
              _DueDateField(
                value: _dueAt,
                onPick: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueAt ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _dueAt = picked);
                },
                onClear: _dueAt == null ? null : () => setState(() => _dueAt = null),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: '标签（逗号分隔）',
                  hintText: '例如：客户A, 周报',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _estimatedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '预计番茄数（可选）'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final tags = _parseTags(_tagsController.text);
                  final estimated = int.tryParse(_estimatedController.text.trim());

                  try {
                    if (isEdit) {
                      final update = ref.read(updateTaskUseCaseProvider);
                      await update(
                        task: widget.task!,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        status: _status,
                        priority: _priority,
                        dueAt: _dueAt,
                        tags: tags,
                        estimatedPomodoros: estimated,
                      );
                    } else {
                      final create = ref.read(createTaskUseCaseProvider);
                      await create(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        priority: _priority,
                        dueAt: _dueAt,
                        tags: tags,
                        estimatedPomodoros: estimated,
                      );
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } on domain.TaskTitleEmptyException {
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
}

class _DueDateField extends StatelessWidget {
  const _DueDateField({required this.value, required this.onPick, this.onClear});

  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final text =
        value == null ? '未设置' : '${value!.year}-${_two(value!.month)}-${_two(value!.day)}';
    return Row(
      children: [
        Expanded(
          child: InputDecorator(
            decoration: const InputDecoration(labelText: '截止日期（可选）'),
            child: Text(text),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: '选择日期',
          onPressed: onPick,
          icon: const Icon(Icons.calendar_month_outlined),
        ),
        IconButton(
          tooltip: '清除日期',
          onPressed: onClear,
          icon: const Icon(Icons.clear),
        ),
      ],
    );
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}
