// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_service.dart';

// ignore_for_file: type=lint
class $UnsyncedDataTableTable extends UnsyncedDataTable
    with TableInfo<$UnsyncedDataTableTable, UnsyncedData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnsyncedDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _myTableNameMeta =
      const VerificationMeta('myTableName');
  @override
  late final GeneratedColumn<String> myTableName = GeneratedColumn<String>(
      'my_table_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endpointMeta =
      const VerificationMeta('endpoint');
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
      'endpoint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, myTableName, data, endpoint, method, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unsynced_data_table';
  @override
  VerificationContext validateIntegrity(Insertable<UnsyncedData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('my_table_name')) {
      context.handle(
          _myTableNameMeta,
          myTableName.isAcceptableOrUnknown(
              data['my_table_name']!, _myTableNameMeta));
    } else if (isInserting) {
      context.missing(_myTableNameMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('endpoint')) {
      context.handle(_endpointMeta,
          endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta));
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnsyncedData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnsyncedData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      myTableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}my_table_name'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      endpoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endpoint'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $UnsyncedDataTableTable createAlias(String alias) {
    return $UnsyncedDataTableTable(attachedDatabase, alias);
  }
}

class UnsyncedData extends DataClass implements Insertable<UnsyncedData> {
  final int id;
  final String myTableName;
  final String data;
  final String endpoint;
  final String method;
  final bool synced;
  const UnsyncedData(
      {required this.id,
      required this.myTableName,
      required this.data,
      required this.endpoint,
      required this.method,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['my_table_name'] = Variable<String>(myTableName);
    map['data'] = Variable<String>(data);
    map['endpoint'] = Variable<String>(endpoint);
    map['method'] = Variable<String>(method);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  UnsyncedDataTableCompanion toCompanion(bool nullToAbsent) {
    return UnsyncedDataTableCompanion(
      id: Value(id),
      myTableName: Value(myTableName),
      data: Value(data),
      endpoint: Value(endpoint),
      method: Value(method),
      synced: Value(synced),
    );
  }

  factory UnsyncedData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnsyncedData(
      id: serializer.fromJson<int>(json['id']),
      myTableName: serializer.fromJson<String>(json['myTableName']),
      data: serializer.fromJson<String>(json['data']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      method: serializer.fromJson<String>(json['method']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'myTableName': serializer.toJson<String>(myTableName),
      'data': serializer.toJson<String>(data),
      'endpoint': serializer.toJson<String>(endpoint),
      'method': serializer.toJson<String>(method),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  UnsyncedData copyWith(
          {int? id,
          String? myTableName,
          String? data,
          String? endpoint,
          String? method,
          bool? synced}) =>
      UnsyncedData(
        id: id ?? this.id,
        myTableName: myTableName ?? this.myTableName,
        data: data ?? this.data,
        endpoint: endpoint ?? this.endpoint,
        method: method ?? this.method,
        synced: synced ?? this.synced,
      );
  UnsyncedData copyWithCompanion(UnsyncedDataTableCompanion data) {
    return UnsyncedData(
      id: data.id.present ? data.id.value : this.id,
      myTableName:
          data.myTableName.present ? data.myTableName.value : this.myTableName,
      data: data.data.present ? data.data.value : this.data,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      method: data.method.present ? data.method.value : this.method,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnsyncedData(')
          ..write('id: $id, ')
          ..write('myTableName: $myTableName, ')
          ..write('data: $data, ')
          ..write('endpoint: $endpoint, ')
          ..write('method: $method, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, myTableName, data, endpoint, method, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnsyncedData &&
          other.id == this.id &&
          other.myTableName == this.myTableName &&
          other.data == this.data &&
          other.endpoint == this.endpoint &&
          other.method == this.method &&
          other.synced == this.synced);
}

class UnsyncedDataTableCompanion extends UpdateCompanion<UnsyncedData> {
  final Value<int> id;
  final Value<String> myTableName;
  final Value<String> data;
  final Value<String> endpoint;
  final Value<String> method;
  final Value<bool> synced;
  const UnsyncedDataTableCompanion({
    this.id = const Value.absent(),
    this.myTableName = const Value.absent(),
    this.data = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.method = const Value.absent(),
    this.synced = const Value.absent(),
  });
  UnsyncedDataTableCompanion.insert({
    this.id = const Value.absent(),
    required String myTableName,
    required String data,
    required String endpoint,
    required String method,
    this.synced = const Value.absent(),
  })  : myTableName = Value(myTableName),
        data = Value(data),
        endpoint = Value(endpoint),
        method = Value(method);
  static Insertable<UnsyncedData> custom({
    Expression<int>? id,
    Expression<String>? myTableName,
    Expression<String>? data,
    Expression<String>? endpoint,
    Expression<String>? method,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (myTableName != null) 'my_table_name': myTableName,
      if (data != null) 'data': data,
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
      if (synced != null) 'synced': synced,
    });
  }

  UnsyncedDataTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? myTableName,
      Value<String>? data,
      Value<String>? endpoint,
      Value<String>? method,
      Value<bool>? synced}) {
    return UnsyncedDataTableCompanion(
      id: id ?? this.id,
      myTableName: myTableName ?? this.myTableName,
      data: data ?? this.data,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (myTableName.present) {
      map['my_table_name'] = Variable<String>(myTableName.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnsyncedDataTableCompanion(')
          ..write('id: $id, ')
          ..write('myTableName: $myTableName, ')
          ..write('data: $data, ')
          ..write('endpoint: $endpoint, ')
          ..write('method: $method, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UnsyncedDataTableTable unsyncedDataTable =
      $UnsyncedDataTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [unsyncedDataTable];
}

typedef $$UnsyncedDataTableTableCreateCompanionBuilder
    = UnsyncedDataTableCompanion Function({
  Value<int> id,
  required String myTableName,
  required String data,
  required String endpoint,
  required String method,
  Value<bool> synced,
});
typedef $$UnsyncedDataTableTableUpdateCompanionBuilder
    = UnsyncedDataTableCompanion Function({
  Value<int> id,
  Value<String> myTableName,
  Value<String> data,
  Value<String> endpoint,
  Value<String> method,
  Value<bool> synced,
});

class $$UnsyncedDataTableTableFilterComposer
    extends Composer<_$AppDatabase, $UnsyncedDataTableTable> {
  $$UnsyncedDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get myTableName => $composableBuilder(
      column: $table.myTableName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));
}

class $$UnsyncedDataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UnsyncedDataTableTable> {
  $$UnsyncedDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get myTableName => $composableBuilder(
      column: $table.myTableName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));
}

class $$UnsyncedDataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnsyncedDataTableTable> {
  $$UnsyncedDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get myTableName => $composableBuilder(
      column: $table.myTableName, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$UnsyncedDataTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UnsyncedDataTableTable,
    UnsyncedData,
    $$UnsyncedDataTableTableFilterComposer,
    $$UnsyncedDataTableTableOrderingComposer,
    $$UnsyncedDataTableTableAnnotationComposer,
    $$UnsyncedDataTableTableCreateCompanionBuilder,
    $$UnsyncedDataTableTableUpdateCompanionBuilder,
    (
      UnsyncedData,
      BaseReferences<_$AppDatabase, $UnsyncedDataTableTable, UnsyncedData>
    ),
    UnsyncedData,
    PrefetchHooks Function()> {
  $$UnsyncedDataTableTableTableManager(
      _$AppDatabase db, $UnsyncedDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnsyncedDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnsyncedDataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnsyncedDataTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> myTableName = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<String> endpoint = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<bool> synced = const Value.absent(),
          }) =>
              UnsyncedDataTableCompanion(
            id: id,
            myTableName: myTableName,
            data: data,
            endpoint: endpoint,
            method: method,
            synced: synced,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String myTableName,
            required String data,
            required String endpoint,
            required String method,
            Value<bool> synced = const Value.absent(),
          }) =>
              UnsyncedDataTableCompanion.insert(
            id: id,
            myTableName: myTableName,
            data: data,
            endpoint: endpoint,
            method: method,
            synced: synced,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnsyncedDataTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UnsyncedDataTableTable,
    UnsyncedData,
    $$UnsyncedDataTableTableFilterComposer,
    $$UnsyncedDataTableTableOrderingComposer,
    $$UnsyncedDataTableTableAnnotationComposer,
    $$UnsyncedDataTableTableCreateCompanionBuilder,
    $$UnsyncedDataTableTableUpdateCompanionBuilder,
    (
      UnsyncedData,
      BaseReferences<_$AppDatabase, $UnsyncedDataTableTable, UnsyncedData>
    ),
    UnsyncedData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UnsyncedDataTableTableTableManager get unsyncedDataTable =>
      $$UnsyncedDataTableTableTableManager(_db, _db.unsyncedDataTable);
}
