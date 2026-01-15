import 'dart:convert';

import 'package:domain/domain.dart' as domain;
import 'package:drift/drift.dart';

import '../db/app_database.dart';

class DriftNoteRepository implements domain.NoteRepository {
  DriftNoteRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<domain.Note>> watchAllNotes() {
    final query = _db.select(_db.notes)
      ..orderBy([
        (t) => OrderingTerm(expression: t.updatedAtUtcMillis, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<List<domain.Note>> watchNotesByTaskId(String taskId) {
    final query = (_db.select(_db.notes)..where((t) => t.taskId.equals(taskId)))
      ..orderBy([
        (t) => OrderingTerm(expression: t.updatedAtUtcMillis, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<domain.Note?> getNoteById(String noteId) async {
    final query = _db.select(_db.notes)..where((t) => t.id.equals(noteId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> upsertNote(domain.Note note) async {
    await _db.into(_db.notes).insertOnConflictUpdate(_toCompanion(note));
  }

  @override
  Future<void> deleteNote(String noteId) async {
    await (_db.delete(_db.notes)..where((t) => t.id.equals(noteId))).go();
  }

  NotesCompanion _toCompanion(domain.Note note) {
    return NotesCompanion.insert(
      id: note.id,
      title: note.title.value,
      body: Value(note.body),
      tagsJson: Value(jsonEncode(note.tags)),
      taskId: Value(note.taskId),
      createdAtUtcMillis: note.createdAt.toUtc().millisecondsSinceEpoch,
      updatedAtUtcMillis: note.updatedAt.toUtc().millisecondsSinceEpoch,
    );
  }

  domain.Note _toDomain(NoteRow row) {
    return domain.Note(
      id: row.id,
      title: domain.NoteTitle(row.title),
      body: row.body,
      tags: _decodeTags(row.tagsJson),
      taskId: row.taskId,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtUtcMillis, isUtc: true).toLocal(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtUtcMillis, isUtc: true).toLocal(),
    );
  }

  List<String> _decodeTags(String tagsJson) {
    try {
      final decoded = jsonDecode(tagsJson);
      if (decoded is List) {
        return decoded.whereType<String>().toList();
      }
    } catch (_) {}
    return const [];
  }
}

