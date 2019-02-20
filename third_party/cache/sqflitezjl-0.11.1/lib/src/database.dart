import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/batch.dart';
import 'package:sqflite/src/constant.dart' hide lockWarningDuration;
import 'package:sqflite/src/database_factory.dart';
import 'package:sqflite/src/exception.dart';
import 'package:sqflite/src/sqflite_impl.dart';
import 'package:sqflite/src/sqflite_impl.dart' as impl;
import 'package:sqflite/src/sql_builder.dart';
import 'package:sqflite/src/transaction.dart';
import 'package:sqflite/src/utils.dart';
import 'package:synchronized/synchronized.dart';

abstract class SqfliteDatabaseExecutor implements DatabaseExecutor {
  SqfliteTransaction get txn;

  SqfliteDatabase get db;

  /// for sql without return values
  @override
  Future execute(String sql, [List arguments]) =>
      db.txnExecute<dynamic>(txn, sql, arguments);

  /// for INSERT sql query
  /// returns the last inserted record id
  @override
  Future<int> rawInsert(String sql, [List arguments]) =>
      db.txnRawInsert(txn, sql, arguments);

  /// INSERT helper
  @override
  Future<int> insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) {
    SqlBuilder builder = new SqlBuilder.insert(table, values,
        nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
    return rawInsert(builder.sql, builder.arguments);
  }

  /// Helper to query a table
  ///
  /// @param distinct true if you want each row to be unique, false otherwise.
  /// @param table The table names to compile the query against.
  /// @param columns A list of which columns to return. Passing null will
  ///            return all columns, which is discouraged to prevent reading
  ///            data from storage that isn't going to be used.
  /// @param where A filter declaring which rows to return, formatted as an SQL
  ///            WHERE clause (excluding the WHERE itself). Passing null will
  ///            return all rows for the given URL.
  /// @param groupBy A filter declaring how to group rows, formatted as an SQL
  ///            GROUP BY clause (excluding the GROUP BY itself). Passing null
  ///            will cause the rows to not be grouped.
  /// @param having A filter declare which row groups to include in the cursor,
  ///            if row grouping is being used, formatted as an SQL HAVING
  ///            clause (excluding the HAVING itself). Passing null will cause
  ///            all row groups to be included, and is required when row
  ///            grouping is not being used.
  /// @param orderBy How to order the rows, formatted as an SQL ORDER BY clause
  ///            (excluding the ORDER BY itself). Passing null will use the
  ///            default sort order, which may be unordered.
  /// @param limit Limits the number of rows returned by the query,
  /// @param offset starting index,
  ///
  /// @return the items found
  ///
  @override
  Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct,
      List<String> columns,
      String where,
      List whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) {
    SqlBuilder builder = new SqlBuilder.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
        whereArgs: whereArgs);
    return rawQuery(builder.sql, builder.arguments);
  }

  /// for SELECT sql query
  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List arguments]) =>
      db.txnRawQuery(txn, sql, arguments);

  /// for UPDATE sql query
  /// return the number of changes made
  @override
  Future<int> rawUpdate(String sql, [List arguments]) =>
      db.txnRawUpdate(txn, sql, arguments);

  /// Convenience method for updating rows in the database.
  ///
  /// update into table [table] with the [values], a map from column names
  /// to new column values. null is a valid value that will be translated to NULL.
  /// [where] is the optional WHERE clause to apply when updating.
  ///            Passing null will update all rows.
  /// You may include ?s in the where clause, which
  ///            will be replaced by the values from [whereArgs]
  /// optional [conflictAlgorithm] for update conflict resolver
  /// return the number of rows affected
  @override
  Future<int> update(String table, Map<String, dynamic> values,
      {String where, List whereArgs, ConflictAlgorithm conflictAlgorithm}) {
    SqlBuilder builder = new SqlBuilder.update(table, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);
    return rawUpdate(builder.sql, builder.arguments);
  }

  /// for DELETE sql query
  /// return the number of changes made
  @override
  Future<int> rawDelete(String sql, [List arguments]) =>
      rawUpdate(sql, arguments);

  /// Convenience method for deleting rows in the database.
  ///
  /// delete from [table]
  /// [where] is the optional WHERE clause to apply when updating.
  ///            Passing null will update all rows.
  /// You may include ?s in the where clause, which
  ///            will be replaced by the values from [whereArgs]
  /// optional [conflictAlgorithm] for update conflict resolver
  /// return the number of rows affected if a whereClause is passed in, 0
  ///         otherwise. To remove all rows and get a count pass "1" as the
  ///         whereClause.
  @override
  Future<int> delete(String table, {String where, List whereArgs}) {
    SqlBuilder builder =
        new SqlBuilder.delete(table, where: where, whereArgs: whereArgs);
    return rawDelete(builder.sql, builder.arguments);
  }
}

class SqfliteDatabaseOpenHelper {
  final SqfliteDatabaseFactory factory;
  final OpenDatabaseOptions options;
  final lock = new Lock();
  final String path;
  SqfliteDatabase sqfliteDatabase;

  SqfliteDatabaseOpenHelper(this.factory, this.path, this.options);

  SqfliteDatabase newDatabase(String path) => factory.newDatabase(this, path);

  bool get isOpened => sqfliteDatabase != null;

  // Future<SqfliteDatabase> get databaseReady => _completer.future;

  // open or return the one opened
  Future<SqfliteDatabase> openDatabase() async {
    if (!isOpened) {
      return await lock.synchronized(() async {
        if (!isOpened) {
          SqfliteDatabase database = newDatabase(path);
          await database.doOpen(options);
          this.sqfliteDatabase = database;
        }
        return this.sqfliteDatabase;
      });
    }
    return sqfliteDatabase;
  }

  Future closeDatabase(SqfliteDatabase sqfliteDatabase) async {
    if (isOpened) {
      await lock.synchronized(() async {
        if (!isOpened) {
          return;
        } else {
          await sqfliteDatabase.doClose();
          factory.doCloseDatabase(sqfliteDatabase);
          this.sqfliteDatabase = null;
        }
      });
    }
  }
}

class SqfliteDatabase extends SqfliteDatabaseExecutor implements Database {
  // save the open helper for proper closing
  final SqfliteDatabaseOpenHelper openHelper;
  OpenDatabaseOptions options;

  SqfliteDatabase(this.openHelper, this._path, {this.options});

  bool get readOnly => openHelper?.options?.readOnly == true;

  @override
  SqfliteDatabase get db => this;

  bool get isOpened => openHelper.isOpened;

  @override
  String get path => _path;
  String _path;

  // only set during inTransaction to allow transaction during open
  int transactionRefCount = 0;

  // Not null during opening
  // default transaction used during opening
  SqfliteTransaction openTransaction;

  @override
  SqfliteTransaction get txn => openTransaction;

  // non-reentrant lock
  final rawLock = new Lock();

  // Its internal id
  int id;

  Map<String, dynamic> get baseDatabaseMethodArguments {
    var map = <String, dynamic>{
      paramId: id,
    };
    return map;
  }

  @override
  Batch batch() {
    return new SqfliteDatabaseBatch(this);
  }

  Future<T> invokeMethod<T>(String method, [dynamic arguments]) =>
      impl.invokeMethod(method, arguments);

  @override
  Future<T> devInvokeMethod<T>(String method, [dynamic arguments]) {
    return invokeMethod<T>(
        method,
        (arguments ?? <String, dynamic>{})
          ..addAll(baseDatabaseMethodArguments));
  }

  @override
  Future<T> devInvokeSqlMethod<T>(String method, String sql, [List arguments]) {
    return devInvokeMethod(
        method, <String, dynamic>{paramSql: sql, paramSqlArguments: arguments});
  }

  /// synchronized call to the database
  /// not re-entrant
  /// Ugly compatibility step to not support older synchronized
  /// mechanism
  Future<T> txnSynchronized<T>(
      Transaction txn, Future<T> action(Transaction txn)) async {
    // If in a transaction, execute right away
    if (txn != null) {
      return await action(txn);
    } else {
      // Simple timeout warning if we cannot get the lock after XX seconds
      bool handleTimeoutWarning =
          (lockWarningDuration != null && lockWarningCallback != null);
      Completer timeoutCompleter;
      if (handleTimeoutWarning) {
        timeoutCompleter = new Completer<dynamic>();
      }

      // Grab the lock
      Future<T> operation = rawLock.synchronized(() {
        if (handleTimeoutWarning) {
          timeoutCompleter.complete();
        }
        return action(txn);
      });
      // Simply warn the developer as this could likely be a deadlock
      if (handleTimeoutWarning) {
        timeoutCompleter.future.timeout(lockWarningDuration, onTimeout: () {
          lockWarningCallback();
        });
      }
      return await operation;
    }
  }

  /// synchronized call to the database
  /// not re-entrant
  Future<T> txnWriteSynchronized<T>(
          Transaction txn, Future<T> action(Transaction txn)) =>
      txnSynchronized(txn, action);

  /// for sql without return values
  Future<T> txnExecute<T>(SqfliteTransaction txn, String sql,
      [List arguments]) {
    return txnWriteSynchronized<T>(txn, (_) {
      return invokeExecute<T>(sql, arguments);
    });
  }

  Future<T> invokeExecute<T>(String sql, List arguments) {
    return wrapDatabaseException(() {
      return invokeMethod(
          methodExecute,
          <String, dynamic>{paramSql: sql, paramSqlArguments: arguments}
            ..addAll(baseDatabaseMethodArguments));
    });
  }

  /// for INSERT sql query
  /// returns the last inserted record id
  Future<int> txnRawInsert(SqfliteTransaction txn, String sql, List arguments) {
    return txnWriteSynchronized(txn, (_) {
      return wrapDatabaseException(() {
        return invokeMethod<int>(
            methodInsert,
            <String, dynamic>{paramSql: sql, paramSqlArguments: arguments}
              ..addAll(baseDatabaseMethodArguments));
      });
    });
  }

  Future<List<Map<String, dynamic>>> txnRawQuery(
      SqfliteTransaction txn, String sql, List arguments) {
    return txnSynchronized(txn, (_) {
      return wrapDatabaseException(() async {
        dynamic result = await invokeMethod<dynamic>(
            methodQuery,
            <String, dynamic>{paramSql: sql, paramSqlArguments: arguments}
              ..addAll(baseDatabaseMethodArguments));
        return queryResultToList(result);
      });
    });
  }

  /// for INSERT sql query
  /// returns the last inserted record id
  Future<int> txnRawUpdate(SqfliteTransaction txn, String sql, List arguments) {
    return txnWriteSynchronized(txn, (_) {
      return wrapDatabaseException(() {
        return invokeMethod<int>(
            methodUpdate,
            <String, dynamic>{paramSql: sql, paramSqlArguments: arguments}
              ..addAll(baseDatabaseMethodArguments));
      });
    });
  }

  Future<List<dynamic>> txnApplyBatch(
      SqfliteTransaction txn, SqfliteBatch batch,
      {bool noResult}) {
    return txnWriteSynchronized(txn, (_) {
      return wrapDatabaseException<List>(() async {
        var arguments = <String, dynamic>{paramOperations: batch.operations}
          ..addAll(baseDatabaseMethodArguments);
        if (noResult == true) {
          arguments[paramNoResult] = noResult;
        }
        List results = await invokeMethod(methodBatch, arguments);

        // Typically when noResult is true
        if (results == null) {
          return null;
        }
        // dart2 - wrap if we need to support more results than just int
        return new BatchResults.from(results);
      });
    });
  }

  @override
  Future<List<dynamic>> applyBatch(Batch batch,
      {bool exclusive, bool noResult}) {
    return transaction((txn) {
      return txnApplyBatch(txn as SqfliteTransaction, batch as SqfliteBatch,
          noResult: noResult);
    }, exclusive: exclusive);
  }

  Future<SqfliteTransaction> beginTransaction({bool exclusive}) async {
    SqfliteTransaction txn = new SqfliteTransaction(this);
    // never create transaction in read-only mode
    if (readOnly != true) {
      if (exclusive == true) {
        await txnExecute<dynamic>(txn, "BEGIN EXCLUSIVE");
      } else {
        await txnExecute<dynamic>(txn, "BEGIN IMMEDIATE");
      }
    }
    return txn;
  }

  Future endTransaction(SqfliteTransaction txn) async {
    // never commit transaction in read-only mode
    if (readOnly != true) {
      if (txn.successfull == true) {
        await txnExecute<dynamic>(txn, "COMMIT");
      } else {
        await txnExecute<dynamic>(txn, "ROLLBACK");
      }
    }
  }

  Future<T> _runTransaction<T>(
      Transaction txn, Future<T> action(Transaction txn),
      {bool exclusive}) async {
    bool successfull;
    if (transactionRefCount++ == 0) {
      txn = await beginTransaction(exclusive: exclusive);
    }
    T result;
    try {
      result = await action(txn);
      successfull = true;
    } finally {
      if (--transactionRefCount == 0) {
        (txn as SqfliteTransaction).successfull = successfull;
        await endTransaction((txn as SqfliteTransaction));
      }
    }
    return result;
  }

  @override
  Future<T> transaction<T>(Future<T> action(Transaction txn),
      {bool exclusive}) {
    return txnWriteSynchronized<T>(txn, (txn) async {
      return _runTransaction(txn, action, exclusive: exclusive);
    });
  }

  ///
  /// Get the database inner version
  ///
  @override
  Future<int> getVersion() async {
    List<Map<String, dynamic>> rows = await rawQuery("PRAGMA user_version;");
    return Sqflite.firstIntValue(rows);
  }

  ///
  /// Set the database inner version
  /// Used internally for open helpers and automatic versioning
  ///
  @override
  Future setVersion(int version) async {
    await execute("PRAGMA user_version = $version;");
  }

  /// Close the database. Cannot be access anymore
  @override
  Future close() => openHelper.closeDatabase(this);

  /// Close the database. Cannot be access anymore
  Future doClose() => _closeDatabase(id);

  @override
  String toString() {
    return "${id} $path";
  }

  Future<int> _openDatabase() {
    var params = <String, dynamic>{paramPath: path};
    if (readOnly == true) {
      params[paramReadOnly] = true;
    }
    return wrapDatabaseException<int>(() {
      return invokeMethod<int>(methodOpenDatabase, params);
    });
  }

  Future _closeDatabase(int databaseId) {
    return wrapDatabaseException<dynamic>(() {
      return invokeMethod<dynamic>(
          methodCloseDatabase, <String, dynamic>{paramId: databaseId});
    });
  }

  // To call during open
  // not exported
  Future<SqfliteDatabase> doOpen(OpenDatabaseOptions options) async {
    if (options.version != null) {
      if (options.version == 0) {
        throw new ArgumentError("version cannot be set to 0 in openDatabase");
      }
    } else {
      if (options.onCreate != null) {
        throw new ArgumentError(
            "onCreate must be null if no version is specified");
      }
      if (options.onUpgrade != null) {
        throw new ArgumentError(
            "onUpgrade must be null if no version is specified");
      }
      if (options.onDowngrade != null) {
        throw new ArgumentError(
            "onDowngrade must be null if no version is specified");
      }
    }
    int databaseId = await _openDatabase();
    this.options = options;

    try {
      // Special on downgrade delete database
      if (options.onDowngrade == onDatabaseDowngradeDelete) {
        // Downgrading will delete the database and open it again
        Future _onDatabaseDowngradeDelete(
            Database _db, int oldVersion, int newVersion) async {
          SqfliteDatabase db = _db as SqfliteDatabase;
          // This is tricky as we are in a middel of opening a database
          // need to close what is being done and retart
          await db.execute("ROLLBACK;");
          await db.doClose();
          await deleteDatabase(db.path);

          // get a new database id after open
          db.id = databaseId = await _openDatabase();

          try {
            // Since we deleted the database re-run the needed first steps:
            // onConfigure then onCreate
            if (options.onConfigure != null) {
              await options.onConfigure(db);
            }
          } catch (e) {
            // This exception is sometimes hard te catch
            // during development
            print(e);

            // create a transaction just to make the current transaction happy
            await db.beginTransaction(exclusive: true);
            rethrow;
          }

          // no end transaction it will be done later before calling then onOpen
          await db.beginTransaction(exclusive: true);
          if (options.onCreate != null) {
            await options.onCreate(db, options.version);
          }
        }

        options.onDowngrade = _onDatabaseDowngradeDelete;
      }

      id = databaseId;

      // create dummy open transaction
      openTransaction = new SqfliteTransaction(this);

      // first configure it
      if (options.onConfigure != null) {
        await options.onConfigure(this);
      }

      if (options.version != null) {
        await transaction((txn) async {
          // Set the current transaction as the open one
          // to allow direct database call during open
          openTransaction = txn as SqfliteTransaction;

          int oldVersion = await getVersion();
          if (oldVersion == null || oldVersion == 0) {
            if (options.onCreate != null) {
              await options.onCreate(this, options.version);
            } else if (options.onUpgrade != null) {
              await options.onUpgrade(this, 0, options.version);
            }
          } else if (options.version > oldVersion) {
            if (options.onUpgrade != null) {
              await options.onUpgrade(this, oldVersion, options.version);
            }
          } else if (options.version < oldVersion) {
            if (options.onDowngrade != null) {
              await options.onDowngrade(this, oldVersion, options.version);
            }
          }
          await setVersion(options.version);
        }, exclusive: true);
      }

      if (options.onOpen != null) {
        await options.onOpen(this);
      }

      return this;
    } catch (e) {
      await _closeDatabase(databaseId);
      rethrow;
    } finally {
      // clean up open transaction
      openTransaction = null;
    }
  }
}
