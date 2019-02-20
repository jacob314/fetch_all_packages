import 'package:chamber/src/database/interface.dart';
import 'package:chamber/src/model.dart';
import 'package:meta/meta.dart';

enum ColumnType {
  int,
  string,
  bool,
  double,
  datetime,
  fk,
}

class ColumnMeta {
  final ColumnType type;
  final String fieldName;
  final String columnName;
  final bool primaryKey;
  final bool index;
  final bool optional;
  final bool unique;

  ColumnMeta({
    this.type,
    this.fieldName,
    this.columnName,
    this.primaryKey,
    this.optional,
    this.index,
    this.unique,
  });

  @override
  bool operator ==(dynamic other) {
    if (other is! ColumnMeta) return false;
    final o = other as ColumnMeta;
    return (type == o.type &&
        fieldName == o.fieldName &&
        columnName == o.columnName &&
        primaryKey == o.primaryKey &&
        optional == o.optional &&
        index == o.index &&
        unique == o.unique);
  }
}

class ChamberMeta {
  final String tableName;

  final Map<String, ColumnMeta> columnMeta;

  final Map<String, dynamic> Function(ChamberModel) toMap;
  final ChamberModel Function(Map<String, dynamic>) fromMap;
  final void Function(ChamberModel, dynamic) setPK;

  final Type type;

  ChamberDatabase db;

  ColumnMeta get primaryKey =>
      columnMeta.values.firstWhere((cm) => cm.primaryKey);

  ChamberMeta({
    @required this.tableName,
    @required this.columnMeta,
    @required this.type,
    @required this.toMap,
    @required this.fromMap,
    @required this.setPK,
  });
}
