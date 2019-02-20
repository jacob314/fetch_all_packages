import 'package:chamber/src/database/interface.dart';
import 'package:chamber/src/meta.dart';
import 'package:chamber/src/model.dart';
import 'package:chamber/src/sql.dart' as sql;
import 'package:chamber/src/util.dart';
import 'package:sqflite/sqflite.dart';

class ChamberDatabaseImpl implements ChamberDatabase {
  Database db;

  ChamberDatabaseImpl([this.db]);

  @override
  Future<void> createTable(ChamberMeta meta) async {
    assert(db != null);

    final statement = sql.createTable(meta);

    flog('table:', statement);

    await db.execute(statement);
  }

  @override
  Future<void> save(ChamberModel model) async {
    final meta = model.$meta;
    final map = meta.toMap(model);
    final convertedValues = convertValues(meta, map);

    final tableName = sql.escape(meta.tableName);

    // try updating. if that doesn't change anything, insert it
    final changedRows = await db.update(
      tableName,
      convertedValues,
      where: '${sql.escape(meta.primaryKey.columnName)} = ?',
      whereArgs: <dynamic>[map[model.$meta.primaryKey.fieldName]],
    );

    // update worked, no need to insert
    if (changedRows != 0) {
      return;
    }

    int pk = await db.insert(tableName, convertedValues);

    meta.setPK(model, pk);
  }

  @override
  Future<void> delete(ChamberModel model) async {
    final meta = model.$meta;
    final map = meta.toMap(model);

    int deletedRows = await db.delete(
      sql.escape(meta.tableName),
      where: '${sql.escape(meta.primaryKey.columnName)} = ?',
      whereArgs: <dynamic>[map[model.$meta.primaryKey.fieldName]],
    );

    assert(deletedRows == 1);
  }
}

Map<String, dynamic> convertValues(
    ChamberMeta meta, Map<String, dynamic> values) {
  return meta.columnMeta.map<String, dynamic>((fieldName, columnMeta) {
    final columnName = sql.escape(columnMeta.columnName);
    final dynamic value = values[fieldName];

    if (columnMeta.type == ColumnType.datetime) {
      return MapEntry<String, dynamic>(columnName, value?.toIso8601String());
    }

    if (columnMeta.type == ColumnType.bool) {
      return MapEntry<String, dynamic>(columnName, (value as bool) ? 1 : 0);
    }

    return MapEntry<String, dynamic>(columnName, value);
  });
}
