import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:chamber/lib.dart';
import 'package:chamber_generator/src/annotations.dart';
import 'package:chamber_generator/src/types.dart';
import 'package:chamber_generator/src/util.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/src/constants/reader.dart';

class GeneratorModel {
  final String tableName;
  final String originalName;
  final String newName;
  final List<GeneratorField> fields;

  List<GeneratorField> get requiredFields =>
      fields.where((f) => !f.optional).toList();

  List<GeneratorField> get fieldsWithoutPk =>
      fields.where((f) => !f.primaryKey).toList();

  GeneratorField get primaryKey => fields.firstWhere((f) => f.primaryKey);

  GeneratorModel._({
    @required this.tableName,
    @required this.originalName,
    @required this.newName,
    @required this.fields,
  });

  factory GeneratorModel(ClassElement cls, ConstantReader annotation) {
    generatorAssert(
      cls.isAbstract,
      'Model must be abstract',
      'Mark ${cls.name} as abstract',
    );

    generatorAssert(
      cls.methods.isEmpty,
      'Model cannot have methods',
      'Remove methods from ${cls.name}',
    );

    generatorAssert(
      cls.name.startsWith('_'),
      'Model class must start with underscore',
      'Rename ${cls.name} to _${cls.name}',
    );

    generatorAssert(
      cls.allSupertypes.length == 1 && cls.allSupertypes[0].isObject,
      'Model class cannot extend or implement or apply mixins',
      'Remove extends/implements/with clauses from ${cls.name}',
    );

    final fields = cls.fields.map((f) => GeneratorField(f)).toList();

    generatorAssert(
      fields.where((f) => f.primaryKey).length == 1,
      'There must be exactly one field marked as @PrimaryKey at ${cls.name}',
    );

    final newName = cls.name.substring(1);

    final tableName =
        annotation.objectValue.getField('tableName').toStringValue() ??
            decamelize(newName);

    return GeneratorModel._(
      tableName: tableName,
      originalName: cls.name,
      newName: newName,
      fields: fields,
    );
  }
}

class GeneratorField {
  final String fieldName;
  final String columnName;
  final DartType type;

  final bool primaryKey;
  final bool autoGenerate;

  final bool optional;
  final bool index;
  final bool unique;
  final FieldElement element;

  GeneratorField._({
    @required this.fieldName,
    @required this.columnName,
    @required this.type,
    @required this.primaryKey,
    @required this.autoGenerate,
    @required this.optional,
    @required this.index,
    @required this.unique,
    @required this.element,
  });

  factory GeneratorField(FieldElement field) {
    final column = getColumnAnnotation(field);
    final primaryKey = getPrimaryKeyAnnotation(field);

    generatorAssert(
      column == null || primaryKey == null,
      'Field ${field.name} cannot have both ColumnInfo and PrimaryKey annotations at the same time',
      'Remove @ColumnInfo or @PrimaryKey from ${field.name}',
    );

    final typeIsInt = isInt(field.type);

    // Default autoGenerate value is true if field type is int, and false otherwise
    final autoGenerate = primaryKey?.autoGenerate ?? typeIsInt;

    if (autoGenerate) {
      generatorAssert(
        typeIsInt,
        'Attribute autoGenerate can only be applied to "int" primary keys',
        'Remove autoGenerate from ${field.name} or change it\'s type to "int"',
      );
    }

    if (primaryKey != null) {
      print('pk ${field.name} $autoGenerate $typeIsInt');
      return GeneratorField._(
        fieldName: field.name,
        columnName: primaryKey?.name ?? field.name,
        type: field.type,
        primaryKey: true,
        autoGenerate: autoGenerate,
        optional: autoGenerate,
        index: ColumnInfo.DEFAULT.index,
        unique: ColumnInfo.DEFAULT.unique,
        element: field,
      );
    }

    return GeneratorField._(
      fieldName: field.name,
      columnName: column?.name ?? field.name,
      type: field.type,
      primaryKey: false,
      autoGenerate: false,
      optional: column?.optional ?? ColumnInfo.DEFAULT.optional,
      index: column?.index ?? ColumnInfo.DEFAULT.index,
      unique: column?.unique ?? ColumnInfo.DEFAULT.unique,
      element: field,
    );
  }
}
