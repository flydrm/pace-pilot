import '../value_objects/note_title.dart';

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    this.taskId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final NoteTitle title;
  final String body;
  final List<String> tags;
  final String? taskId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note copyWith({
    NoteTitle? title,
    String? body,
    List<String>? tags,
    String? taskId,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      taskId: taskId ?? this.taskId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

