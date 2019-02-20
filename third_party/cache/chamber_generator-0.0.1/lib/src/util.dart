import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

Map<K, V> mapFromIterable<T, K, V>(Iterable<T> iterable,
    {@required K key(T element), @required V value(T element)}) {
  return Map.fromEntries(
    iterable.map(
      (e) => MapEntry(key(e), value(e)),
    ),
  );
}

void generatorAssert(bool test, String message, [String todo]) {
  if (!test) {
    throw InvalidGenerationSourceError(
      message,
      todo: todo,
    );
  }
}

String decamelize(String camelized) {
  return camelized
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .toLowerCase();
}
