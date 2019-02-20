# redurx_persist_flutter [![pub package](https://img.shields.io/pub/v/redurx_persist_flutter.svg)](https://pub.dartlang.org/packages/redurx_persist_flutter)

Flutter Storage Engine for [`redurx_persist`](https://pub.dartlang.org/packages/redurx_persist).

Can either save to [`shared_preferences`](https://pub.dartlang.org/packages/shared_preferences)
(default, recommended), or your
[application document directory](https://pub.dartlang.org/packages/path_provider).

## Usage

```dart
final persistor = Persistor<State>(
  // ...
  storage: FlutterStorage(),
);
```

It is recommended to load initial state before calling `runApp` to let Flutter
show the slash screen until we are ready to render.

## Locations

By default, it saves to `FlutterSaveLocation.documentFile`
([application document directory](https://pub.dartlang.org/packages/path_provider), recommended).

You can also save to your [shared preferences](https://pub.dartlang.org/packages/shared_preferences) by using `FlutterSaveLocation.sharedPreferences`:

```dart
// Use shared preferences
FlutterStorage(location: FlutterSaveLocation.sharedPreferences);
// Use document file
FlutterStorage(location: FlutterSaveLocation.documentFile);
```

## Key

You can pass a `key` argument to `FlutterStorage` to provide a key
for the file name (document file) or the shared preference key.

## Features and bugs

Please file feature requests and bugs at the
[issue tracker](https://github.com/feilfeilundfeil/redurx_persist/issues).
