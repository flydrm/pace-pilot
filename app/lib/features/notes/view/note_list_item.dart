import 'package:domain/domain.dart' as domain;
import 'package:flutter/material.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem({super.key, required this.note, required this.onTap});

  final domain.Note note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final snippet = _firstLine(note.body);
    final subtitleParts = <String>[];
    if (snippet != null) subtitleParts.add(snippet);
    if (note.tags.isNotEmpty) subtitleParts.add(note.tags.take(3).join(' · '));
    final subtitle =
        subtitleParts.isEmpty ? null : subtitleParts.join('  ·  ');

    return ListTile(
      title: Text(note.title.value, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        _formatDate(note.updatedAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }

  String? _firstLine(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.split('\n').first.trim();
  }

  String _formatDate(DateTime dt) => '${dt.month}/${dt.day}';
}

