import 'package:flutter/widgets.dart';
import 'package:its_cache/mem_cache/cache.dart';
import 'package:its_cache/mem_cache/cache_entry.dart';
import 'package:its_cache/mem_cache/storage.dart';

class LruCache<K, V> extends Cache<K, V> {
  LruCache({@required Storage<K, V> storage}) : super(storage: storage);

  @override
  LruCache<K, V> set(K key, V element) {
    if (!this.storage.containsKey(key) && this.storage.length >= this.storage.capacity) {
      // Sort by use time
      var values = this.storage.values;
      values.sort((e1, e2) {
        return e1.lastUse.compareTo(e2.lastUse);
      });

      this.storage.remove(values.first.key);
    }
    this.storage[key] = new CacheEntry(key, element, new DateTime.now());
    return this;
  }
}
