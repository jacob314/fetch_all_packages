import 'package:chamber/src/meta.dart';
import 'package:chamber/src/sql.dart' as sql;
import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: missing_required_param

void main() {
  test("create table sql", () {
    final meta = ChamberMeta(
      tableName: 'user',
      columnMeta: <String, ColumnMeta>{
        'id': ColumnMeta(
          type: ColumnType.int,
          fieldName: 'id',
          columnName: 'id',
          primaryKey: true,
          optional: false,
          index: false,
          unique: false,
        ),
        'name': ColumnMeta(
          type: ColumnType.string,
          fieldName: 'name',
          columnName: 'name',
          primaryKey: false,
          optional: false,
          index: false,
          unique: false,
        ),
        'email': ColumnMeta(
          type: ColumnType.string,
          fieldName: 'email',
          columnName: 'email',
          primaryKey: false,
          optional: true,
          index: false,
          unique: false,
        ),
        'createdAt': ColumnMeta(
          type: ColumnType.datetime,
          fieldName: 'createdAt',
          columnName: 'createdAt',
          primaryKey: false,
          optional: false,
          index: false,
          unique: false,
        ),
        'isAdmin': ColumnMeta(
          type: ColumnType.bool,
          fieldName: 'isAdmin',
          columnName: 'isAdmin',
          primaryKey: false,
          optional: false,
          index: false,
          unique: false,
        ),
        'popularity': ColumnMeta(
          type: ColumnType.double,
          fieldName: 'popularity',
          columnName: 'popularity',
          primaryKey: false,
          optional: false,
          index: true,
          unique: false,
        )
      },
    );
    expect(
        sql.createTable(meta),
        'CREATE TABLE `user` (\n'
        '  `id` INTEGER PRIMARY KEY AUTOINCREMENT,\n'
        '  `name` TEXT NOT NULL,\n'
        '  `email` TEXT,\n'
        '  `createdAt` TEXT NOT NULL,\n'
        '  `isAdmin` INTEGER NOT NULL,\n'
        '  `popularity` REAL NOT NULL\n'
        ')');
  });
}
