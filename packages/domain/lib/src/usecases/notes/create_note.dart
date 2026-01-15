import '../../entities/note.dart';
import '../../repositories/note_repository.dart';
import '../../value_objects/note_title.dart';

typedef NoteIdGenerator = String Function();
typedef _Now = DateTime Function();

class CreateNoteUseCase {
  CreateNoteUseCase({
    required NoteRepository repository,
    required NoteIdGenerator generateId,
    _Now now = DateTime.now,
  })  : _repository = repository,
        _generateId = generateId,
        _now = now;

  final NoteRepository _repository;
  final NoteIdGenerator _generateId;
  final _Now _now;

  Future<Note> call({
    required String title,
    String? body,
    List<String> tags = const [],
    String? taskId,
  }) async {
    final now = _now();
    final note = Note(
      id: _generateId(),
      title: NoteTitle(title),
      body: _normalizeBody(body),
      tags: tags,
      taskId: taskId?.trim().isEmpty == true ? null : taskId?.trim(),
      createdAt: now,
      updatedAt: now,
    );
    await _repository.upsertNote(note);
    return note;
  }

  String _normalizeBody(String? value) => value?.trimRight() ?? '';
}

