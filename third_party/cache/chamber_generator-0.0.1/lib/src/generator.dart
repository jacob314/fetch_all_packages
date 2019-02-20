import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:chamber/lib.dart';
import 'package:chamber_generator/src/generator_model.dart';
import 'package:chamber_generator/src/types.dart';
import 'package:chamber_generator/src/util.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

const classMetaField = r'$classMeta';
const metaField = r'$meta';

final refChamberModel = refer('ChamberModel');
final refChamberMeta = refer('ChamberMeta');
final refColumnType = refer('ColumnType');
final refColumnMeta = refer('ColumnMeta');

class ModelGenerator extends GeneratorForAnnotation<Model> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    generatorAssert(
      element is ClassElement,
      'Generator cannot target ${element.displayName}',
      'Remove [Model] annotation from ${element.displayName}',
    );

    final cls = element as ClassElement;

    return ModelClassGenerator(GeneratorModel(cls, annotation)).generate();
  }
}

class ModelClassGenerator {
  final GeneratorModel model;

  ModelClassGenerator(this.model);

  String generate() {
    final classBuilder = Class((c) {
      c
        ..name = model.newName
        ..extend = refChamberModel
        ..implements.add(refer(model.originalName))
        ..fields.addAll(generateFields())
        ..constructors.add(generateConstructor())
        ..methods.addAll(generateMethods());
    });

    return DartFormatter()
        .format('${classBuilder.accept(DartEmitter.scoped())}');
  }

  Constructor generateConstructor() {
    return Constructor((c) {
      c.optionalParameters.addAll(getParameters(model.fields, toThis: true));

      c.body = Block((b) {
        for (final requiredField in model.requiredFields) {
          final expr = refer('assert').call([
            refer(requiredField.fieldName).notEqualTo(refer('null')),
          ]);

          b.statements.add(expr.statement);
        }
      });
    });
  }

  List<Field> generateFields() {
    return [
          generateChamberMeta(),
        ] +
        model.fields
            .map((field) => Field((f) {
                  f
                    ..name = field.fieldName
                    ..type = refer(field.type.name);
                }))
            .toList();
  }

  Field generateChamberMeta() {
    return Field((f) {
      f
        ..name = classMetaField
        ..static = true
        ..modifier = FieldModifier.final$
        ..type = refChamberMeta
        ..assignment = refChamberMeta.call([], {
          'type': refer(model.newName),
          'tableName': literalString(model.tableName),
          'columnMeta': generateColumnMeta(),
          'toMap': Method((m) {
            m
              ..requiredParameters.add(Parameter((p) {
                p
                  ..name = 'model'
                  ..type = refChamberModel;
              }))
              ..body = Block((b) {
                b.statements.add(
                  refer('assert').call(
                      [refer('model').isA(refer(model.newName))]).statement,
                );

                b.statements.add(
                  refer('model')
                      .asA(refer(model.newName))
                      .assignFinal('_model')
                      .statement,
                );

                b.statements.add(literalMap(
                  mapFromIterable(
                    model.fields,
                    key: (GeneratorField field) => field.fieldName,
                    value: (GeneratorField field) =>
                        refer('_model').property(field.fieldName),
                  ),
                  refer('String'),
                  refer('dynamic'),
                ).returned.statement);
              });
          }).closure,
          'fromMap': Method((m) {
            m
              ..requiredParameters.add(Parameter((p) {
                p
                  ..name = 'map'
                  ..type = refer('Map');
              }))
              ..body = Block((b) {
                final arguments = mapFromIterable(
                  model.fields,
                  key: (GeneratorField field) => field.fieldName,
                  value: (GeneratorField field) => refer('map')
                      .index(literalString(field.fieldName))
                      .asA(refer(field.type.name)),
                );

                b.statements.add(
                  refer(model.newName).call([], arguments).returned.statement,
                );
              });
          }).closure,
          'setPK': Method((m) {
            m
              ..requiredParameters.addAll([
                Parameter((p) {
                  p
                    ..name = 'model'
                    ..type = refChamberModel;
                }),
                Parameter((p) {
                  p
                    ..name = 'pk'
                    ..type = refer('dynamic');
                }),
              ])
              ..body = Block((b) {
                b.statements.addAll([
                  refer('assert').call(
                      [refer('model').isA(refer(model.newName))]).statement,
                  refer('model')
                      .asA(refer(model.newName))
                      .property(model.primaryKey.fieldName)
                      .assign(
                          refer('pk').asA(refer(model.primaryKey.type.name)))
                      .statement,
                ]);
              });
          }).closure,
        }).code;
    });
  }

  Expression generateColumnMeta() {
    return literalMap(
      mapFromIterable(
        model.fields,
        key: (GeneratorField field) => field.fieldName,
        value: (GeneratorField field) => refColumnMeta.call([], {
              'type': resolveColumnType(field.element),
              'fieldName': literalString(field.fieldName),
              'columnName': literalString(field.columnName),
              'primaryKey': literalBool(field.primaryKey),
              'optional': literalBool(field.optional),
              'index': literalBool(field.index),
              'unique': literalBool(field.unique),
            }),
      ),
      refer('String'),
      refColumnMeta,
    );
  }

  List<Method> generateMethods() {
    return [
      generateMethodCreate(),
      generateGetterMeta(),
    ];
  }

  Method generateMethodCreate() {
    return Method((m) {
      m
        ..name = 'create'
        ..static = true
        ..optionalParameters
            .addAll(getParameters(model.fieldsWithoutPk, toThis: false))
        ..body = Block((b) {
          final createInstance = refer(model.newName).call(
            [],
            mapFromIterable(
              model.fields.where((f) => !f.primaryKey),
              key: (GeneratorField field) => field.fieldName,
              value: (GeneratorField field) => refer(field.fieldName),
            ),
          );

          final assignment = createInstance.assignFinal('instance').statement;

          b.statements.add(assignment);

          final saving = refer('instance').property('save').call([]).statement;

          b.statements.add(saving);

          final returning = refer('instance').returned.statement;

          b.statements.add(returning);
        })
        ..returns = refer(model.newName);
    });
  }

  Method generateGetterMeta() {
    return Method((m) {
      m
        ..name = metaField
        ..type = MethodType.getter
        ..returns = refer('ChamberMeta')
        ..body =
            refer(model.newName).property(classMetaField).returned.statement;
    });
  }

  Map<Object, Object> generateColumnTypes() {
    return mapFromIterable(
      model.fields,
      key: (GeneratorField field) => literalString(field.fieldName),
      value: (GeneratorField field) => resolveColumnType(field.element),
    );
  }
}

Expression resolveColumnType(FieldElement f) {
  if (isString(f.type)) {
    return refColumnType.property('string');
  }

  if (isInt(f.type)) {
    return refColumnType.property('int');
  }

  if (isDouble(f.type)) {
    return refColumnType.property('double');
  }

  if (isBool(f.type)) {
    return refColumnType.property('bool');
  }

  if (isDateTime(f.type)) {
    return refColumnType.property('datetime');
  }

  if (isFK(f.type)) {
    return refColumnType.property('fk');
  }

  throw InvalidGenerationSourceError('Unknown type ${f.type}');
}

List<Parameter> getParameters(List<GeneratorField> fields,
    {@required bool toThis}) {
  return fields
      .map((field) => Parameter((p) {
            p
              ..name = field.fieldName
              ..toThis = toThis
              ..named = true;

            if (!toThis) {
              p.type = refer(field.type.name);
            }

            if (!field.optional && !field.primaryKey) {
              p.annotations.add(refer('required'));
            }
          }))
      .toList();
}
