import 'package:chamber/chamber.dart';

part 'model.chamber.dart';

@Model()
abstract class _User {
  @PrimaryKey()
  int id;

  @ColumnInfo(unique: true)
  String name;

  @ColumnInfo(optional: true)
  String email;

  DateTime createdAt;

  bool isAdmin;

  @ColumnInfo(index: true)
  double popularity;
}

@Model(tableName: 'vehicle')
abstract class _Car {
  @PrimaryKey(name: '')
  String plate;

  String model;

  @ColumnInfo(optional: true)
  int year;

  @ColumnInfo(index: true, optional: true)
  DateTime createdAt;
}
