import 'package:flutter/widgets.dart';
import 'package:its_cache/mem_cache/cache_entry.dart';
import 'package:its_cache/mem_cache/storage.dart';

typedef V LoaderFunc<K, V>(K key, V oldValue);

abstract class Cache<K, V> {
  Storage<K, V> _internalStorage;
  Duration _expiration;

  Cache({@required Storage<K, V> storage}) {
    this._internalStorage = storage;
  }

  /// retun the element identify by [key]
  V get(K key) {
    CacheEntry<K, V> entry = this._get(key);

    if (entry == null) {
      return null;
    }

    // Check if the value hasn't expired
    if (this._expiration != null && DateTime.now().difference(entry.insertTime) > this._expiration) {
      return null;
    }

    entry?.use++;
    entry?.lastUse = DateTime.now();
    return entry?.value;
  }

  /// internal [get]
  CacheEntry<K, V> _get(K key) => this._internalStorage[key];

  /// add [element] in the cache at [key]
  Cache<K, V> set(K key, V element) {
    return this._set(key, element);
  }

  /// internal [set]
  Cache<K, V> _set(K key, V element) {
    this._internalStorage[key] = CacheEntry(key, element, DateTime.now());
    return this;
  }

  /// return the number of element in the cache
  int get length => this._internalStorage.length;

  // Check if the cache contains a specific entry
  bool containsKey(K key) => this._internalStorage.containsKey(key);

  /// return the value at [key]
  dynamic operator [](K key) {
    return this.get(key);
  }

  /// assign [element] for [key]
  void operator []=(K key, V element) {
    this.set(key, element);
  }

  /// remove all the entry inside the cache
  void clear() => this._internalStorage.clear();

  set storage(Storage<K, V> storage) {
    this._internalStorage = storage;
  }

  Storage<K, V> get storage => this._internalStorage;

  set expiration(Duration duration) {
    this._expiration = duration;
  }
}
