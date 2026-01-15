import 'package:domain/domain.dart' as domain;
import 'package:drift/drift.dart';

import '../db/app_database.dart';

class DriftAppearanceConfigRepository implements domain.AppearanceConfigRepository {
  DriftAppearanceConfigRepository(this._db);

  static const _singletonId = 1;

  final AppDatabase _db;

  @override
  Stream<domain.AppearanceConfig> watch() {
    final query = _db.select(_db.appearanceConfigs)
      ..where((t) => t.id.equals(_singletonId));
    return query.watchSingleOrNull().map(_toDomainOrDefault);
  }

  @override
  Future<domain.AppearanceConfig> get() async {
    final query = _db.select(_db.appearanceConfigs)
      ..where((t) => t.id.equals(_singletonId));
    final row = await query.getSingleOrNull();
    return _toDomainOrDefault(row);
  }

  @override
  Future<void> save(domain.AppearanceConfig config) async {
    await _db.into(_db.appearanceConfigs).insertOnConflictUpdate(
          AppearanceConfigsCompanion.insert(
            id: const Value(_singletonId),
            themeMode: Value(config.themeMode.index),
            density: Value(config.density.index),
            accent: Value(config.accent.index),
            updatedAtUtcMillis: DateTime.now().toUtc().millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> clear() async {
    await (_db.delete(_db.appearanceConfigs)..where((t) => t.id.equals(_singletonId))).go();
  }

  domain.AppearanceConfig _toDomainOrDefault(AppearanceConfigRow? row) {
    if (row == null) return const domain.AppearanceConfig();

    final themeModeIndex = row.themeMode;
    final densityIndex = row.density;
    final accentIndex = row.accent;

    final themeMode = themeModeIndex >= 0 && themeModeIndex < domain.AppThemeMode.values.length
        ? domain.AppThemeMode.values[themeModeIndex]
        : domain.AppThemeMode.system;

    final density = densityIndex >= 0 && densityIndex < domain.AppDensity.values.length
        ? domain.AppDensity.values[densityIndex]
        : domain.AppDensity.comfortable;

    final accent = accentIndex >= 0 && accentIndex < domain.AppAccent.values.length
        ? domain.AppAccent.values[accentIndex]
        : domain.AppAccent.a;

    return domain.AppearanceConfig(
      themeMode: themeMode,
      density: density,
      accent: accent,
    );
  }
}
