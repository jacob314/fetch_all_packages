import 'dart:io';

import 'package:redux_sqlite/redux_sqlite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SQLiteDatabase implements AbstractDatabase {
  final Database _database;

  SQLiteDatabase(this._database);

  @override
  execute(sql) async {
    return await this._database.execute(sql);
  }

  @override
  query(table, filter) async {
    var columns = filter?.keys?.toList();
    var values = filter?.values?.toList();
    var where = "";
    for (var column in columns) {
      if (where.isNotEmpty) {
        where += " AND ";
      }

      where += column + " = ?";
    }

    if (where.isEmpty) {
      return await this._database.query(table);
    }

    return await this._database.query(table, where: where, whereArgs: values);
  }

  @override
  rawQuery(sql) async {
    return await this._database.rawQuery(sql);
  }

  @override
  insert(table, map) async {
    return await this._database.insert(table, map);
  }

  @override
  update(table, map) async {
    await this._database.update(table, map);
  }

  @override
  delete(table, id) async {
    await this._database.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}

class SQLiteDBProvider implements DBProvider {
  static const _schemaVersion = 1;

  String get _databaseName {
    return 'FlutterApp.db';
  }

  AbstractDatabase _database;

  List<Migration> _migrations;

  @override
  Future<AbstractDatabase> get database async {
    if (this._database == null) {
      await this.init();
    }

    return this._database;
  }

  SQLiteDBProvider(List<Migration> migrations) {
    migrations.sort((x, y) => x.version.compareTo(y.version));
    this._migrations = migrations;
  }

  @override
  init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, this._databaseName);

    return await openDatabase(path, version: SQLiteDBProvider._schemaVersion,
        onConfigure: (database) {
      this._database = SQLiteDatabase(database);
    }, onCreate: (database, version) async {
      await this.migrate(0, version);
    }, onUpgrade: (database, oldVersion, newVersion) async {
      await this.migrate(oldVersion, newVersion);
    }, onDowngrade: (database, oldVersion, newVersion) async {
      await this.migrate(oldVersion, newVersion);
    }, onOpen: (database) {});
  }

  Future<void> migrate(int oldVersion, int newVersion) async {
    if (oldVersion == newVersion) {
      return;
    } else if (oldVersion < newVersion) {
      for (var migration in this._migrations) {
        if (migration.version >= oldVersion &&
            migration.version <= newVersion) {
          migration.up(this._database);
        }
      }
    } else {
      for (var migration in this._migrations) {
        if (migration.version >= newVersion &&
            migration.version <= oldVersion) {
          migration.down(this._database);
        }
      }
    }
  }
}

class SQLiteRepository<TDataModel extends DataModel>
    implements Repository<TDataModel> {
  final DBProvider _dbProvider;
  final TableNameProvider _tableNameProvider;
  final DataModelConverter<TDataModel> _dataModelConverter;

  String _tableName;
  String get tableName {
    return this._tableName ??
        (this._tableName =
            this._tableNameProvider.getTableNameByType(TDataModel));
  }

  Future<AbstractDatabase> get _database async {
    return await this._dbProvider.database;
  }

  SQLiteRepository(
      this._dbProvider, this._tableNameProvider, this._dataModelConverter);

  @override
  save(item) async {
    var isNewRecord = item.id == null || item.id == 0;
    var database = await this._database;
    if (isNewRecord) {
      var getIdResult = await database
          .rawQuery("SELECT MAX(id)+1 as id FROM ${this.tableName}");
      item.id = getIdResult.first["id"] ?? 1;
    }

    var fieldsMap = this._dataModelConverter.toMap(item);
    if (isNewRecord) {
      await database.insert(this.tableName, fieldsMap);
    } else {
      await database.update(this.tableName, fieldsMap);
    }
  }

  @override
  delete(itemId) async {
    var database = await this._database;
    database.delete(this.tableName, itemId);
  }

  @override
  get(id) async {
    var database = await this._database;
    var resultList = await database.query(this.tableName, {"id": id});
    if (resultList == null || resultList.length == 0) {
      return null;
    }

    return this._dataModelConverter.fromMap(resultList[0]);
  }

  @override
  getAll({whereParams}) async {
    var database = await this._database;
    var resultList = await database.query(this.tableName, whereParams ?? {});

    return resultList
        .map((record) => this._dataModelConverter.fromMap(record))
        .toList();
  }
}
