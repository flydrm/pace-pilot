import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';

class TaskFiltersSheet extends StatefulWidget {
  const TaskFiltersSheet({super.key, required this.initial});

  final domain.TaskListQuery initial;

  @override
  State<TaskFiltersSheet> createState() => _TaskFiltersSheetState();
}

class _TaskFiltersSheetState extends State<TaskFiltersSheet> {
  late domain.TaskStatusFilter _statusFilter;
  domain.TaskPriority? _priority;
  late bool _dueToday;
  late bool _overdue;
  late final TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _statusFilter = widget.initial.statusFilter;
    _priority = widget.initial.priority;
    _dueToday = widget.initial.dueToday;
    _overdue = widget.initial.overdue;
    _tagController = TextEditingController(text: widget.initial.tag ?? '');
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    '筛选',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _statusFilter = domain.TaskStatusFilter.open;
                      _priority = null;
                      _dueToday = false;
                      _overdue = false;
                      _tagController.text = '';
                    });
                  },
                  child: const Text('清除'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<domain.TaskStatusFilter>(
              initialValue: _statusFilter,
              decoration: const InputDecoration(labelText: '状态'),
              items: const [
                DropdownMenuItem(
                  value: domain.TaskStatusFilter.open,
                  child: Text('未完成（默认）'),
                ),
                DropdownMenuItem(
                  value: domain.TaskStatusFilter.all,
                  child: Text('全部'),
                ),
                DropdownMenuItem(
                  value: domain.TaskStatusFilter.todo,
                  child: Text('待办'),
                ),
                DropdownMenuItem(
                  value: domain.TaskStatusFilter.inProgress,
                  child: Text('进行中'),
                ),
                DropdownMenuItem(
                  value: domain.TaskStatusFilter.done,
                  child: Text('已完成'),
                ),
              ],
              onChanged: (value) => setState(() => _statusFilter = value!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<domain.TaskPriority?>(
              initialValue: _priority,
              decoration: const InputDecoration(labelText: '优先级'),
              items: const [
                DropdownMenuItem(value: null, child: Text('不限')),
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
              onChanged: (value) => setState(() => _priority = value),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: '标签（精确匹配）',
                hintText: '例如：客户A',
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _dueToday,
              onChanged: (value) {
                setState(() {
                  _dueToday = value;
                  if (value) _overdue = false;
                });
              },
              title: const Text('今天到期'),
            ),
            SwitchListTile(
              value: _overdue,
              onChanged: (value) {
                setState(() {
                  _overdue = value;
                  if (value) _dueToday = false;
                });
              },
              title: const Text('已逾期'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(
                  domain.TaskListQuery(
                    statusFilter: _statusFilter,
                    priority: _priority,
                    tag: _tagController.text.trim().isEmpty
                        ? null
                        : _tagController.text.trim(),
                    dueToday: _dueToday,
                    overdue: _overdue,
                  ),
                );
              },
              child: const Text('应用'),
            ),
          ],
        ),
      ),
    );
  }
}
