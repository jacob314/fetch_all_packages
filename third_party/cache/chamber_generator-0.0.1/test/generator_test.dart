import 'package:chamber/chamber.dart';
import 'package:flutter_test/flutter_test.dart';

import 'model.dart';

final createdAt = DateTime.now();

final user = User(
  id: 5,
  name: 'John Doe',
  email: 'johndoe@example.com',
  isAdmin: false,
  popularity: 15.5,
  createdAt: createdAt,
);

void main() {
  test('table name', () {
    expect(User.$classMeta.tableName, 'user');
    expect(Car.$classMeta.tableName, 'vehicle');
  });

  test('converts object to map', () {
    final map = User.$classMeta.toMap(user);

    expect(map, {
      'id': 5,
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'isAdmin': false,
      'popularity': 15.5,
      'createdAt': createdAt,
    });
  });

  test('converts map to object', () {
    final map = {
      'id': 5,
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'isAdmin': false,
      'popularity': 15.5,
      'createdAt': createdAt,
    };

    final user2 = User.$classMeta.fromMap(map) as User;

    expect(user.id, user2.id);
    expect(user.name, user2.name);
    expect(user.email, user2.email);
    expect(user.isAdmin, user2.isAdmin);
    expect(user.popularity, user2.popularity);
    expect(user.createdAt, user2.createdAt);
  });

  test('column info', () {
    final userColumns = User.$classMeta.columnMeta;

    expect(userColumns, <String, ColumnMeta>{
      'id': ColumnMeta(
          type: ColumnType.int,
          fieldName: 'id',
          columnName: 'id',
          primaryKey: true,
          optional: false,
          index: false,
          unique: false),
      'name': ColumnMeta(
          type: ColumnType.string,
          fieldName: 'name',
          columnName: 'name',
          primaryKey: false,
          optional: false,
          index: false,
          unique: false),
      'email': ColumnMeta(
          type: ColumnType.string,
          fieldName: 'email',
          columnName: 'email',
          primaryKey: false,
          optional: true,
          index: false,
          unique: false),
      'createdAt': ColumnMeta(
          type: ColumnType.datetime,
          fieldName: 'createdAt',
          columnName: 'createdAt',
          primaryKey: false,
          optional: false,
          index: false,
          unique: false),
      'isAdmin': ColumnMeta(
          type: ColumnType.bool,
          fieldName: 'isAdmin',
          columnName: 'isAdmin',
          primaryKey: false,
          optional: false,
          index: false,
          unique: false),
      'popularity': ColumnMeta(
          type: ColumnType.double,
          fieldName: 'popularity',
          columnName: 'popularity',
          primaryKey: false,
          optional: false,
          index: true,
          unique: false)
    });
  });
}
