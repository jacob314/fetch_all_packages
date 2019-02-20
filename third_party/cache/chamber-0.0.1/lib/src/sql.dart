import 'package:chamber/src/meta.dart';

String createTable(ChamberMeta meta) {
  final columns = meta.columnMeta.keys.map((fieldName) {
    final columnMeta = meta.columnMeta[fieldName];

    return '  ${escape(columnMeta.columnName)} '
        '${_columnTypeToAffinity(columnMeta.type)}'
        '${_columnModifiers(columnMeta)}';
  }).join(',\n');

  return 'CREATE TABLE ${escape(meta.tableName)} (\n'
      '$columns\n'
      ')';
}

String escape(String name) {
  return '`$name`';
}

String unescape(String name) {
  return name.substring(1, name.length - 1);
}

String _columnModifiers(ColumnMeta columnMeta) {
  final buffer = StringBuffer();

  if (columnMeta.primaryKey) {
    buffer.write(' PRIMARY KEY');
    // TODO: make autoincrement optional
    if (columnMeta.type == ColumnType.int) {
      buffer.write(' AUTOINCREMENT');
    }
  }

  if (columnMeta.unique) {
    buffer.write(' UNIQUE');
  }

  if (!columnMeta.optional && !columnMeta.primaryKey) {
    buffer.write(' NOT NULL');
  }

  return buffer.toString();
}

String _columnTypeToAffinity(ColumnType columnType) {
  assert(ColumnType.values.contains(columnType));

  switch (columnType) {
    case ColumnType.int:
    case ColumnType.bool:
    case ColumnType.fk:
      return 'INTEGER';

    case ColumnType.datetime:
    case ColumnType.string:
      return 'TEXT';

    case ColumnType.double:
      return 'REAL';
  }

  return null;
}
