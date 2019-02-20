import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:chamber/lib.dart';
import 'package:source_gen/source_gen.dart';

DartObject getAnnotation(FieldElement field, Type type) {
  return TypeChecker.fromRuntime(type)
      .firstAnnotationOf(field, throwOnUnresolved: false);
}

ColumnInfo getColumnAnnotation(FieldElement field) {
  final column = getAnnotation(field, ColumnInfo);

  if (column == null) {
    return null;
  }

  return ColumnInfo(
    name: column.getField('name').toStringValue(),
    optional: column.getField('optional').toBoolValue(),
    index: column.getField('index').toBoolValue(),
  );
}

PrimaryKey getPrimaryKeyAnnotation(FieldElement field) {
  final primaryKey = getAnnotation(field, PrimaryKey);

  if (primaryKey == null) {
    return null;
  }

  return PrimaryKey(
    name: primaryKey.getField('name').toStringValue(),
    autoGenerate: primaryKey.getField('autoGenerate').toBoolValue(),
  );
}
