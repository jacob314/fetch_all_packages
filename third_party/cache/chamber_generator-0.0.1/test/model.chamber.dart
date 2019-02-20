// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// ModelGenerator
// **************************************************************************

class User extends ChamberModel implements _User {
  User(
      {this.id,
      @required this.name,
      this.email,
      @required this.createdAt,
      @required this.isAdmin,
      @required this.popularity}) {
    assert(name != null);
    assert(createdAt != null);
    assert(isAdmin != null);
    assert(popularity != null);
  }

  static final ChamberMeta $classMeta = ChamberMeta(
      type: User,
      tableName: 'user',
      columnMeta: <String, ColumnMeta>{
        'id': ColumnMeta(
            type: ColumnType.int,
            fieldName: 'id',
            columnName: 'id',
            primaryKey: true,
            optional: true,
            index: false,
            unique: false),
        'name': ColumnMeta(
            type: ColumnType.string,
            fieldName: 'name',
            columnName: 'name',
            primaryKey: false,
            optional: false,
            index: false,
            unique: false),
        'email': ColumnMeta(
            type: ColumnType.string,
            fieldName: 'email',
            columnName: 'email',
            primaryKey: false,
            optional: true,
            index: false,
            unique: false),
        'createdAt': ColumnMeta(
            type: ColumnType.datetime,
            fieldName: 'createdAt',
            columnName: 'createdAt',
            primaryKey: false,
            optional: false,
            index: false,
            unique: false),
        'isAdmin': ColumnMeta(
            type: ColumnType.bool,
            fieldName: 'isAdmin',
            columnName: 'isAdmin',
            primaryKey: false,
            optional: false,
            index: false,
            unique: false),
        'popularity': ColumnMeta(
            type: ColumnType.double,
            fieldName: 'popularity',
            columnName: 'popularity',
            primaryKey: false,
            optional: false,
            index: true,
            unique: false)
      },
      toMap: (ChamberModel model) {
        assert(model is User);
        final _model = (model as User);
        return <String, dynamic>{
          'id': _model.id,
          'name': _model.name,
          'email': _model.email,
          'createdAt': _model.createdAt,
          'isAdmin': _model.isAdmin,
          'popularity': _model.popularity
        };
      },
      fromMap: (Map map) {
        return User(
            id: (map['id'] as int),
            name: (map['name'] as String),
            email: (map['email'] as String),
            createdAt: (map['createdAt'] as DateTime),
            isAdmin: (map['isAdmin'] as bool),
            popularity: (map['popularity'] as double));
      },
      setPK: (ChamberModel model, dynamic pk) {
        assert(model is User);
        (model as User).id = (pk as int);
      });

  int id;

  String name;

  String email;

  DateTime createdAt;

  bool isAdmin;

  double popularity;

  static User create(
      {@required String name,
      String email,
      @required DateTime createdAt,
      @required bool isAdmin,
      @required double popularity}) {
    final instance = User(
        name: name,
        email: email,
        createdAt: createdAt,
        isAdmin: isAdmin,
        popularity: popularity);
    instance.save();
    return instance;
  }

  ChamberMeta get $meta {
    return User.$classMeta;
  }
}

class Car extends ChamberModel implements _Car {
  Car({this.plate, @required this.model, this.year, this.createdAt}) {
    assert(plate != null);
    assert(model != null);
  }

  static final ChamberMeta $classMeta = ChamberMeta(
      type: Car,
      tableName: 'vehicle',
      columnMeta: <String, ColumnMeta>{
        'plate': ColumnMeta(
            type: ColumnType.string,
            fieldName: 'plate',
            columnName: '',
            primaryKey: true,
            optional: false,
            index: false,
            unique: false),
        'model': ColumnMeta(
            type: ColumnType.string,
            fieldName: 'model',
            columnName: 'model',
            primaryKey: false,
            optional: false,
            index: false,
            unique: false),
        'year': ColumnMeta(
            type: ColumnType.int,
            fieldName: 'year',
            columnName: 'year',
            primaryKey: false,
            optional: true,
            index: false,
            unique: false),
        'createdAt': ColumnMeta(
            type: ColumnType.datetime,
            fieldName: 'createdAt',
            columnName: 'createdAt',
            primaryKey: false,
            optional: true,
            index: true,
            unique: false)
      },
      toMap: (ChamberModel model) {
        assert(model is Car);
        final _model = (model as Car);
        return <String, dynamic>{
          'plate': _model.plate,
          'model': _model.model,
          'year': _model.year,
          'createdAt': _model.createdAt
        };
      },
      fromMap: (Map map) {
        return Car(
            plate: (map['plate'] as String),
            model: (map['model'] as String),
            year: (map['year'] as int),
            createdAt: (map['createdAt'] as DateTime));
      },
      setPK: (ChamberModel model, dynamic pk) {
        assert(model is Car);
        (model as Car).plate = (pk as String);
      });

  String plate;

  String model;

  int year;

  DateTime createdAt;

  static Car create({@required String model, int year, DateTime createdAt}) {
    final instance = Car(model: model, year: year, createdAt: createdAt);
    instance.save();
    return instance;
  }

  ChamberMeta get $meta {
    return Car.$classMeta;
  }
}
