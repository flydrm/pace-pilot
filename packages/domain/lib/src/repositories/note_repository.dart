import '../entities/note.dart';

abstract interface class NoteRepository {
  Stream<List<Note>> watchAllNotes();
  Stream<List<Note>> watchNotesByTaskId(String taskId);
  Future<Note?> getNoteById(String noteId);
  Future<void> upsertNote(Note note);
  Future<void> deleteNote(String noteId);
}

