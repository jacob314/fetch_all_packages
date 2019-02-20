import 'package:chamber/src/meta.dart';
import 'package:chamber/src/model.dart';

abstract class ChamberDatabase {
  Future<void> createTable(ChamberMeta meta);
  Future<void> save(ChamberModel model);
  Future<void> delete(ChamberModel model);
}
