import 'package:domain/domain.dart' as domain;
import 'package:drift/drift.dart';

import '../db/app_database.dart';

class DriftTodayPlanRepository implements domain.TodayPlanRepository {
  DriftTodayPlanRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<String>> watchTaskIdsForDay({required DateTime day}) {
    final dayKey = _dayKey(day);
    final query = (_db.select(_db.todayPlanItems)..where((t) => t.dayKey.equals(dayKey)))
      ..orderBy([
        (t) => OrderingTerm(expression: t.orderIndex, mode: OrderingMode.asc),
      ]);
    return query.watch().map((rows) => [for (final r in rows) r.taskId]);
  }

  @override
  Future<void> addTask({required DateTime day, required String taskId}) async {
    final dayKey = _dayKey(day);
    final existing = await (_db.select(_db.todayPlanItems)
          ..where((t) => t.dayKey.equals(dayKey) & t.taskId.equals(taskId)))
        .getSingleOrNull();
    if (existing != null) return;

    final maxIndex = await (_db.selectOnly(_db.todayPlanItems)
          ..addColumns([_db.todayPlanItems.orderIndex.max()])
          ..where(_db.todayPlanItems.dayKey.equals(dayKey)))
        .map((row) => row.read(_db.todayPlanItems.orderIndex.max()))
        .getSingleOrNull();
    final nextIndex = (maxIndex ?? -1) + 1;

    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _db.into(_db.todayPlanItems).insert(
          TodayPlanItemsCompanion.insert(
            dayKey: dayKey,
            taskId: taskId,
            orderIndex: nextIndex,
            createdAtUtcMillis: now,
            updatedAtUtcMillis: now,
          ),
          mode: InsertMode.insert,
        );
  }

  @override
  Future<void> removeTask({required DateTime day, required String taskId}) async {
    final dayKey = _dayKey(day);
    await _db.transaction(() async {
      await (_db.delete(_db.todayPlanItems)
            ..where((t) => t.dayKey.equals(dayKey) & t.taskId.equals(taskId)))
          .go();
      await _compactOrder(dayKey);
    });
  }

  @override
  Future<void> replaceTasks({
    required DateTime day,
    required List<String> taskIds,
  }) async {
    final dayKey = _dayKey(day);
    final unique = <String>[];
    for (final id in taskIds) {
      final trimmed = id.trim();
      if (trimmed.isEmpty) continue;
      if (!unique.contains(trimmed)) unique.add(trimmed);
    }

    await _db.transaction(() async {
      await (_db.delete(_db.todayPlanItems)..where((t) => t.dayKey.equals(dayKey))).go();

      if (unique.isEmpty) return;
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      await _db.batch((batch) {
        batch.insertAll(
          _db.todayPlanItems,
          [
            for (var i = 0; i < unique.length; i++)
              TodayPlanItemsCompanion.insert(
                dayKey: dayKey,
                taskId: unique[i],
                orderIndex: i,
                createdAtUtcMillis: now,
                updatedAtUtcMillis: now,
              ),
          ],
          mode: InsertMode.insert,
        );
      });
    });
  }

  @override
  Future<void> clearDay({required DateTime day}) async {
    final dayKey = _dayKey(day);
    await (_db.delete(_db.todayPlanItems)..where((t) => t.dayKey.equals(dayKey))).go();
  }

  Future<void> _compactOrder(String dayKey) async {
    final rows = await (_db.select(_db.todayPlanItems)..where((t) => t.dayKey.equals(dayKey)))
        .get();
    if (rows.isEmpty) return;

    rows.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;

    await _db.batch((batch) {
      for (var i = 0; i < rows.length; i++) {
        final row = rows[i];
        batch.update(
          _db.todayPlanItems,
          TodayPlanItemsCompanion(
            orderIndex: Value(i),
            updatedAtUtcMillis: Value(now),
          ),
          where: (t) => t.dayKey.equals(dayKey) & t.taskId.equals(row.taskId),
        );
      }
    });
  }

  String _dayKey(DateTime day) {
    final local = DateTime(day.year, day.month, day.day);
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }
}

