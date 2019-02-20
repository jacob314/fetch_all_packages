import 'dart:async';
import 'dart:io';

import 'package:fake_http/okhttp3/cookie_jar.dart';
import 'package:fake_http/okhttp3/http_url.dart';
import 'package:fake_http/okhttp3/lang/integer.dart';

class PersistentCookieJar implements CookieJar {
  final _PersistentCookieStore _cookieStore;

  PersistentCookieJar._internal(_PersistentCookieStore cookieStore)
      : _cookieStore = cookieStore;

  @override
  Future<void> saveFromResponse(HttpUrl url, List<Cookie> cookies) async {
    if (_cookieStore != null) {
      if (cookies != null && cookies.isNotEmpty) {
        List<PersistentCookie> persistentCookies = cookies.map((Cookie cookie) {
          return new PersistentCookie._internal(cookie);
        }).toList();
        await _cookieStore.put(url, List.unmodifiable(persistentCookies));
      }
    }
  }

  @override
  Future<List<Cookie>> loadForRequest(HttpUrl url) async {
    List<Cookie> cookies = [];
    if (_cookieStore != null) {
      List<PersistentCookie> persistentCookies = await _cookieStore.get(url);
      if (persistentCookies != null && persistentCookies.isNotEmpty) {
        persistentCookies.forEach((PersistentCookie persistentCookie) {
          if (!persistentCookie.isExpired()) {
            cookies.add(persistentCookie._cookie);
          }
        });
      }
    }
    return List.unmodifiable(cookies);
  }

  static PersistentCookieJar persistent(CookiePersistor persistor) {
    return new PersistentCookieJar._internal(
        new _PersistentCookieStore._internal(persistor));
  }
}

class PersistentCookie {
  static const String _COOKIE_CTS = '_CTS';

  Cookie _cookie;
  int _createTimestamp;

  PersistentCookie._internal(Cookie cookie)
      : assert(cookie != null),
        _cookie = cookie,
        _createTimestamp = (new DateTime.now().millisecondsSinceEpoch ~/
                Duration.millisecondsPerSecond)
            .toInt();

  PersistentCookie.fromValue(String value) {
    List<String> params = value.split('; $_COOKIE_CTS=');
    _cookie = new Cookie.fromSetCookieValue(params[0]);
    _createTimestamp = int.parse(params[1]);
  }

  String name() {
    return _cookie.name;
  }

  String domain() {
    return _cookie.domain;
  }

  String path() {
    return _cookie.path;
  }

  bool persistent() {
    return _cookie.expires != null || _cookie.maxAge != null;
  }

  int expiresAt() {
    // http 1.1
    if (_cookie.maxAge != null) {
      return _createTimestamp + _cookie.maxAge;
    }
    // http 1.0
    if (_cookie.expires != null) {
      return (_cookie.expires.millisecondsSinceEpoch ~/
              Duration.millisecondsPerSecond)
          .toInt();
    }
    return Integer.MIN_VALUE;
  }

  bool isExpired() {
    return (new DateTime.now().millisecondsSinceEpoch ~/
                Duration.millisecondsPerSecond)
            .toInt() >
        expiresAt();
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PersistentCookie &&
        runtimeType == other.runtimeType &&
        toString() == other.toString();
  }

  @override
  int get hashCode {
    return toString().hashCode;
  }

  @override
  String toString() {
    return _cookie.toString() + "; $_COOKIE_CTS=$_createTimestamp";
  }
}

class _PersistentCookieStore {
  final CookiePersistor _persistor;

  _PersistentCookieStore._internal(CookiePersistor persistor)
      : assert(persistor != null),
        _persistor = persistor;

  Future<void> put(
      HttpUrl url, List<PersistentCookie> persistentCookies) async {
    if (persistentCookies != null && persistentCookies.isNotEmpty) {
      HttpUrl index = _getEffectiveUrl(url);

      List<PersistentCookie> persistPersistentCookies =
          await _persistor.load(index);
      List<PersistentCookie> effectivePersistentCookies =
          persistPersistentCookies != null
              ? List.from(persistPersistentCookies)
              : [];

      List<PersistentCookie> shouldRemovePersistentCookies = [];
      persistentCookies.forEach((PersistentCookie persistentCookie) {
        effectivePersistentCookies
            .forEach((PersistentCookie effectivePersistentCookie) {
          if (effectivePersistentCookie._cookie == persistentCookie._cookie) {
            shouldRemovePersistentCookies.add(effectivePersistentCookie);
          } else if (effectivePersistentCookie.name() ==
                  persistentCookie.name() &&
              effectivePersistentCookie.domain() == persistentCookie.domain() &&
              effectivePersistentCookie.path() == persistentCookie.path()) {
            shouldRemovePersistentCookies.add(effectivePersistentCookie);
          }
        });
      });
      shouldRemovePersistentCookies
          .forEach((PersistentCookie shouldRemovePersistentCookie) {
        effectivePersistentCookies.remove(shouldRemovePersistentCookie);
      });
      effectivePersistentCookies.addAll(persistentCookies);

      await _persistor.update(index, effectivePersistentCookies);
    }
  }

  Future<List<PersistentCookie>> get(HttpUrl url) async {
    HttpUrl index = _getEffectiveUrl(url);

    List<PersistentCookie> persistPersistentCookies =
        await _persistor.load(index);
    List<PersistentCookie> effectivePersistentCookies =
        persistPersistentCookies != null
            ? List.from(persistPersistentCookies)
            : [];

    return List.unmodifiable(effectivePersistentCookies);
  }

  HttpUrl _getEffectiveUrl(HttpUrl url) {
    return HttpUrl.from(new Uri(scheme: 'http', host: url.host()));
  }
}

abstract class CookiePersistor {
  static final CookiePersistor MEMORY = new _MemoryCookiePersistor();

  Future<List<PersistentCookie>> load(HttpUrl index);

  Future<bool> update(HttpUrl index, List<PersistentCookie> persistentCookies);

  Future<bool> clear();
}

class _MemoryCookiePersistor implements CookiePersistor {
  final Map<HttpUrl, List<PersistentCookie>> _uriIndex = {};

  _MemoryCookiePersistor();

  @override
  Future<List<PersistentCookie>> load(HttpUrl index) async {
    List<PersistentCookie> persistentCookies = _uriIndex[index];
    return persistentCookies != null
        ? List.unmodifiable(persistentCookies)
        : null;
  }

  @override
  Future<bool> update(
      HttpUrl index, List<PersistentCookie> persistentCookies) async {
    if (persistentCookies != null) {
      _uriIndex.putIfAbsent(index, () => persistentCookies);
    } else {
      _uriIndex.remove(index);
    }
    return true;
  }

  @override
  Future<bool> clear() async {
    _uriIndex.clear();
    return true;
  }
}