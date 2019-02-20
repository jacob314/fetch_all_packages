import 'dart:collection';

import 'package:chamber/src/meta.dart';
import 'package:chamber/src/util.dart';

class ModelRegistry {
  List<ChamberMeta> _models = [];

  List<ChamberMeta> get models => UnmodifiableListView(_models);

  void register(ChamberMeta chamberMeta) {
    flog('registered ${chamberMeta.tableName}');
    _models.add(chamberMeta);
  }
}
