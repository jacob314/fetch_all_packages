import 'package:analyzer/dart/element/type.dart';
import 'package:chamber/lib.dart';
import 'package:source_gen/source_gen.dart';

bool isString(DartType type) {
  return TypeChecker.fromRuntime(String).isExactlyType(type);
}

bool isInt(DartType type) {
  return TypeChecker.fromRuntime(int).isExactlyType(type);
}

bool isDouble(DartType type) {
  return TypeChecker.fromRuntime(double).isExactlyType(type);
}

bool isBool(DartType type) {
  return TypeChecker.fromRuntime(bool).isExactlyType(type);
}

bool isDateTime(DartType type) {
  return TypeChecker.fromRuntime(DateTime).isExactlyType(type);
}

bool isFK(DartType type) {
  return TypeChecker.fromRuntime(ChamberModel).isSuperTypeOf(type);
}
