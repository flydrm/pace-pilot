import 'package:drift/drift.dart';

@DataClassName('AppearanceConfigRow')
class AppearanceConfigs extends Table {
  IntColumn get id => integer()();
  IntColumn get themeMode => integer().withDefault(const Constant(0))();
  IntColumn get density => integer().withDefault(const Constant(0))();
  IntColumn get accent => integer().withDefault(const Constant(0))();
  IntColumn get updatedAtUtcMillis => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
