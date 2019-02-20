library chamber;

import 'package:chamber/src/database/impl.dart';
import 'package:chamber/src/meta.dart';
import 'package:chamber/src/util.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

export 'lib.dart';

class Chamber {
  static final Chamber instance = Chamber();

  final db = ChamberDatabaseImpl();

  final List<ChamberMeta> models = [];

  void onCreateDb(Database db, int version) async {
    flog('creating db');

    final fdb = ChamberDatabaseImpl(db);

    for (final model in models) {
      await fdb.createTable(model);
      flog('created', model.tableName);
    }
  }

  Future<void> _start(
    List<ChamberMeta> _models, {
    String dbName,
  }) async {
    assert(_models.isNotEmpty);
    assert(dbName != null && dbName.isNotEmpty);

    models.addAll(_models);

    String path = join(await getDatabasesPath(), dbName);

    await deleteDatabase(path);

    flog('path is:', path);

    db.db = await openDatabase(
      path,
      version: 1,
      onCreate: onCreateDb,
    );

    assert(db.db != null);

    for (final model in models) {
      model.db = db;
    }

    flog('opened db');
  }

  static Future<void> start({
    @required List<ChamberMeta> models,
    String dbName = 'app.db',
  }) {
    return instance._start(
      models,
      dbName: dbName,
    );
  }
}
