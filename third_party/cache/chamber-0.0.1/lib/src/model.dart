import 'package:chamber/src/meta.dart';

abstract class ChamberModel {
  ChamberMeta $meta;

  Future<void> save() => $meta.db.save(this);

  Future<void> delete() => $meta.db.delete(this);
}
