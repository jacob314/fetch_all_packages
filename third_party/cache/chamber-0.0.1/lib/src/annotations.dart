import 'package:meta/meta.dart';

class Model {
  final String tableName;

  const Model({
    this.tableName,
  });

  String toString() => 'Model(tableName: $tableName)';
}

class PrimaryKey {
  final String name;
  final bool autoGenerate;

  const PrimaryKey({
    this.name,
    this.autoGenerate,
  });

  @override
  String toString() => 'PrimaryKey(name: $name, autoGenerate: $autoGenerate)';
}

class ColumnInfo {
  final String name;
  final bool index;
  final bool optional;
  final bool unique;

  const ColumnInfo({
    this.name,
    this.index = false,
    this.optional = false,
    this.unique = false,
  });

  @override
  String toString() =>
      'Column(name: $name, index: $index, optional: $optional, unique: $unique)';

  static const DEFAULT = ColumnInfo(
    index: false,
    optional: false,
  );
}

// TODO: foreign keys

enum OnDelete {
  restrict,
  cascade,
  setNull,
}

class ForeignKey {
  final OnDelete onDelete;

  const ForeignKey({@required this.onDelete});
}
