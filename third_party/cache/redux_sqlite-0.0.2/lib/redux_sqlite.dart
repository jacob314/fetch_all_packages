library redux_sqlite;

import 'package:redux/redux.dart';
import 'package:redux_sqlite/sqlite.dart';

abstract class ApplicationRoot<TApplicationState> {
  Store<TApplicationState> _store;

  DBProvider _dbProvider;

  Store<TApplicationState> get store {
    return this._store ?? (this._store = this.buildStore());
  }

  DBProvider get dbProvider {
    return this._dbProvider ?? (this._dbProvider = this.buildDbProvider());
  }

  Store<TApplicationState> buildStore() {
    return Store<TApplicationState>(this.buildReducers(),
        initialState: this.getEmptyApplicationState(),
        middleware: this.buildMiddleWares());
  }

  List<Function> buildMiddleWares() {
    return this.getMiddleWares().map((m) => m.invoke).toList();
  }

  DBProvider buildDbProvider() {
    var migrations = this.getMigrations();
    return SQLiteDBProvider(migrations);
  }

  Reducer<TApplicationState> buildReducers();

  List<Migration> getMigrations();

  List<MiddleWare> getMiddleWares();

  TApplicationState getEmptyApplicationState();
}

abstract class MiddleWare<TApplicationState> {
  void invoke(Store<TApplicationState> store, action, NextDispatcher next);
}

abstract class DataModel {
  int id;
}

abstract class DataModelConverter<TDataModel extends DataModel> {
  Map<String, dynamic> toMap(TDataModel model);

  TDataModel fromMap(Map<String, dynamic> map);
}

abstract class AbstractDatabase {
  Future<void> execute(String sql);

  Future<List<Map<String, dynamic>>> query(
      String table, Map<String, dynamic> filter);

  Future<List<Map<String, dynamic>>> rawQuery(String sql);

  Future<int> insert(String table, Map<String, dynamic> map);

  Future<void> update(String table, Map<String, dynamic> map);

  Future<void> delete(String table, int id);
}

abstract class TableNameProvider {
  String getTableName(DataModel dataModel) {
    return this.getTableNameByType(dataModel.runtimeType);
  }

  String getTableNameByType(Type modelType) {
    var tableName = this.getTableNames()[modelType];

    if (tableName != null) {
      return tableName;
    }

    throw Exception("Table name not specified for $modelType");
  }

  Map<Type, String> getTableNames();
}

abstract class DBProvider {
  Future<AbstractDatabase> get database;

  Future<void> init();
}

abstract class Repository<TDataModel extends DataModel> {
  Future<void> save(TDataModel item);

  Future<void> delete(int itemId);

  Future<TDataModel> get(int id);

  Future<List<TDataModel>> getAll({Map<String, dynamic> whereParams});
}

abstract class Migration {
  int version;

  up(AbstractDatabase database);

  down(AbstractDatabase database);
}
