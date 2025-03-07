import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db_service.g.dart';

@DataClassName('UnsyncedData')
class UnsyncedDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get myTableName => text()(); // Table name where data belongs
  TextColumn get data => text()(); // JSON data
  TextColumn get endpoint => text()(); // API endpoint
  TextColumn get method => text()(); // "POST", "PUT", "DELETE"
  BoolColumn get synced => boolean().withDefault(Constant(false))();
}

@DriftDatabase(tables: [UnsyncedDataTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Save failed API request for later sync
  Future<void> insertUnsyncedData(
      String tableName, String data, String endpoint, String method) async {
    await into(unsyncedDataTable).insert(UnsyncedDataTableCompanion(
      myTableName: Value(tableName),
      data: Value(data),
      endpoint: Value(endpoint),
      method: Value(method),
      synced: Value(false),
    ));
  }

  // Get all unsynced data
  Future<List<UnsyncedData>> getUnsyncedData() =>
      (select(unsyncedDataTable)..where((d) => d.synced.equals(false))).get();

  // Mark data as synced
  Future<void> markAsSynced(int id) async {
    await (update(unsyncedDataTable)..where((d) => d.id.equals(id)))
        .write(UnsyncedDataTableCompanion(synced: Value(true)));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
