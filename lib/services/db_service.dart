import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db_service.g.dart';

@DataClassName('UnsyncedData')
class UnsyncedDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get myTableName => text()();

  TextColumn get data => text().withDefault(Constant('{}'))(); // ✅ Default JSON
  TextColumn get endpoint => text()();

  TextColumn get method => text()();

  BoolColumn get synced => boolean().withDefault(Constant(false))();
}

@DataClassName('DataFromBackend')
class DataFromBackendTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get myTableName => text().unique()(); // ✅ Prevents duplicates
  TextColumn get data => text().withDefault(Constant('{}'))(); // ✅ Default JSON
  TextColumn get endpoint => text()();
}

@DriftDatabase(tables: [UnsyncedDataTable, DataFromBackendTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  // ✅ Save data from backend (replace existing entry)
  Future<void> insertData(String tableName, String data, String from) async {
    await (delete(dataFromBackendTable)
          ..where((d) => d.myTableName.equals(tableName)))
        .go(); // ✅ Remove old entry
    await into(dataFromBackendTable).insert(DataFromBackendTableCompanion(
      myTableName: Value(tableName),
      data: Value(data),
      endpoint: Value(from),
    ));
  }

  // ✅ Save failed API request for later sync
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

  // ✅ Fetch all unsynced data
  Future<List<UnsyncedData>> getUnsyncedData() async {
    return await (select(unsyncedDataTable)
          ..where((d) => d.synced.equals(false)))
        .get();
  }

  // ✅ Mark a specific entry as synced
  Future<void> markAsSynced(int id) async {
    await (update(unsyncedDataTable)..where((d) => d.id.equals(id))).write(
      UnsyncedDataTableCompanion(synced: Value(true)),
    );
  }

  // ✅ Fetch user data safely
  Future<Map<String, dynamic>> getUserData() async {
    try {
      final query = select(dataFromBackendTable)
        ..where((d) => d.myTableName.equals('userInfo'))
        ..limit(1); // ✅ Ensure only one row is fetched
      final result = await query.getSingleOrNull();
      return result != null ? jsonDecode(result.data) : {};
    } catch (e) {
      print("❌ Error fetching user data: $e");
      return {};
    }
  }

  // ✅ Fetch shift data safely
  Future<Map<String, dynamic>> getShiftData() async {
    try {
      final query = select(dataFromBackendTable)
        ..where((d) => d.myTableName.equals('shiftInfo'))
        ..limit(1); // ✅ Ensure only one row is fetched
      final result = await query.getSingleOrNull();
      return result != null ? jsonDecode(result.data) : {};
    } catch (e) {
      print("❌ Error fetching shift data: $e");
      return {};
    }
  }

  // ✅ Fetch shift data safely
  Future<Map<String, dynamic>> getProductData() async {
    try {
      final query = select(dataFromBackendTable)
        ..where((d) => d.myTableName.equals('products'))
        ..limit(1); // ✅ Ensure only one row is fetched
      final result = await query.getSingleOrNull();
      return result != null ? jsonDecode(result.data) : {};
    } catch (e) {
      print("❌ Error fetching shift data: $e");
      return {};
    }
  }

  // ✅ Fetch sales data safely
  Future<Map<String, dynamic>> getSalesData() async {
    try {
      final query = select(dataFromBackendTable)
        ..where((d) => d.myTableName.equals('mySales'))
        ..limit(1); // ✅ Ensure only one row is fetched
      final result = await query.getSingleOrNull();
      return result != null ? jsonDecode(result.data) : {};
    } catch (e) {
      print("❌ Error fetching sales data: $e");
      return {};
    }
  }

  // ✅ Delete data from backend
  Future<void> deleteDataFromBackend(String tableName) async {
    await (delete(dataFromBackendTable)
          ..where((d) => d.myTableName.equals(tableName)))
        .go();
  }

  // ✅ Delete unsynced data
  Future<void> deleteUnsyncedData(int id) async {
    await (delete(unsyncedDataTable)..where((d) => d.id.equals(id))).go();
  }

  // ✅ Delete all data from backend (optional)
  Future<void> clearAllData() async {
    await delete(dataFromBackendTable).go();
  }

  // ✅ Delete all unsynced data (optional)
  Future<void> clearAllUnsyncedData() async {
    await delete(unsyncedDataTable).go();
  }

  // ✅ Clear all data from backend (optional)
  Future<void> clearDataFromBackend() async {
    await delete(dataFromBackendTable).go();
  }

  // ✅ Clear all unsynced data (optional)
  Future<void> clearUnsyncedData() async {
    await delete(unsyncedDataTable).go();
  }
}

// ✅ Open SQLite connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
