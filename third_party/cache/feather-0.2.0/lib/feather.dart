library feather;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:rxdart/rxdart.dart';

class AppDb {
  static AppDb _db;
  static ValueStreamCallback<Map> onUpdate = new ValueStreamCallback<Map>();
  Map store;

  AppDb(this.store);

  /// Initialises the app db if it hasn't been already
  static AppDb init(Map initial) {
    return _db = _db ?? new AppDb(initial);
  }

  /// Invokes the given function with the latest known state of the AppDb.
  /// The returned value (if a Map), is adopted as the new state
  static void dispatch(Function fn) {
    var changes = fn(_db.store) ?? null;
    if (changes is Map) {
      _db.store = changes;
      onUpdate.call(changes);
    }
  }

  @override
  String toString() => 'AppDb{store: $store, onUpdate: $onUpdate}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppDb &&
          runtimeType == other.runtimeType &&
          store == other.store;

  @override
  int get hashCode => store.hashCode;
}

class AppDbStream extends StreamView<Map> {
  AppDbStream(StreamCallback<Map> onUpdate) : super(createStream(onUpdate));

  static Stream<Map> createStream(ValueStreamCallback<Map> onUpdate) {
    return new Observable(onUpdate).map((latest) => latest);
  }
}

dynamic _getValue(Map m, String k) => m[k] ?? null;

/// True if the provided map contains the specified key
bool contains(Map m, String k) => m?.keys?.any((v) => v == k) ?? false;

/// Gets the value at the specified key path or uses a notFound default
dynamic getIn(Map m, List<String> keys, [dynamic notFound]) =>
    keys.fold(m, (o, x) => contains(o, x) ? _getValue(o, x) : null) ?? notFound;

/// Gets the value at the specified key or uses a notFound default
dynamic get(Map m, String key, [dynamic notFound]) => getIn(m, [key], notFound);

/// Removes all nulls from a list, returning a new instance
List removeNulls(List list) {
  List l = new List.from(list);
  l.removeWhere((t) => t == null);
  return l;
}

/// Set the value of a given key path in a map, returning a new instance
Map setIn(Map m, List<String> keys, dynamic value) {
  if (keys.length > 1) {
    var fold = keys
        .fold(new List<String>(), (List<String> list, s) {
          var preceding = (list.length > 0) ? list.last + "." : "";
          list.add('$preceding$s');
          return list;
        })
        .reversed
        .skip(1)
        .map((String k) => get(m, k))
        .fold(value, (dynamic o, dynamic n) {
          var k = keys.removeLast();
          o = _vofk(o, n, k);
          var exst = get(n, k);
          //Todo: Find a better way to merge
          if (exst is Map && !(value is Function)) {
            o = {}..addAll(exst)..addAll(o);
          }
          return {}..addAll(n ?? {})..addAll({k: o});
        });
    var k = keys.first;
    return {}..addAll(m)..addAll({k: fold});
  } else {
    var def;
    if (keys.length == 1) {
      def = {}..addAll(m)..addAll({keys.first: _vofk(value, m, keys.first)});
    } else {
      def = _vof(value, m);
    }
    return {}..addAll(def ?? {});
  }
}

_vof(o, dynamic n) {
  return (o is Function) ? o(n) : o;
}

_vofk(o, Map n, String k) {
  return (o is Function) ? o(get(n, k)) : o;
}

/// Set the value of a given key in a map, returning a new instance
Map set(Map m, String key, dynamic value) {
  return setIn(m, [key], value);
}

/// Removes a given key path from a map, returning a new instance
Map removeIn(Map m, List<String> keys) {
  final String k = keys.reversed.first;
  keys.removeLast();
  return setIn(m, keys, (o) {
    var updated = {}..addAll(o);
    updated.remove(k);
    return updated;
  });
}

/// Removes a given key from a map, returning a new instance
Map remove(Map m, String key) => removeIn(m, [key]);

// Merges two maps together, overriding existing keys and returning a new instance
Map merge(Map m, Map n) => {}..addAll(m ?? {})..addAll(n ?? {});

// Casts a List<dynamic> to a List<Widget>
List<Widget> asWidgets(List values) => values.map((v) => v as Widget).toList();

// Casts a List<dynamic> to a List<Map>
List<Map> asMaps(List values) => values.map((v) => v as Map).toList();

// Casts a List<dynamic> to a List<Widget> and removes null values
List<Widget> nonNullWidgets(v) => asWidgets(removeNulls(v));

// Casts a List<dynamic> to a List<Map> and removes null values
List<Map> nonNullMaps(v) => asMaps(removeNulls(v));

// Returns true if x is null
bool isNull(dynamic x) => x == null;

// Returns true if x is not null
bool isNotNull(dynamic x) => !isNull(x);

bool _isTruthy(dynamic val) {
  //TODO: Find a better way
  if (val == null) return false;
  if (val == false) return false;
  if (val == 0) return false;
  if (val is List && val.isEmpty) return false;
  if (val is Map && val.isEmpty) return false;
  return true;
}

// Returns the value of val passed to res (if function otherwise value of res) when res is truthy
// ignore: missing_return
dynamic when(dynamic val, dynamic res) {
  if (_isTruthy(val)) {
    return _vof(res, val);
  }
}

// Returns resTrue or resFalse depending on the truthyness of val
dynamic ifVal(dynamic val, dynamic resTrue, dynamic resFalse) {
  if (_isTruthy(val)) {
    return _vof(resTrue, val);
  } else {
    return _vof(resFalse, val);
  }
}
