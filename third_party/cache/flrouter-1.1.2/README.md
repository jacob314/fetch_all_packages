# Flrouter [Deprecated]
[![pub package](https://img.shields.io/pub/v/flrouter.svg)](https://pub.dartlang.org/packages/flrouter)

## Deprecated

Use [`flutter_router`](https://pub.dartlang.org/packages/flrouter) instead. Flrouter is a Flutter routing library that adds flexible routing options like parameters and clear route definitions.

## Usage
To use this plugin, add `flrouter` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Usage
``` dart
// Import package
import 'package:flrouter/flrouter.dart';
```

``` dart
runApp(MaterialApp(
  onGenerateRoute: Flrouter({
    '/accounts/{id}': (context, match) => Accounts.View(id: match.parameters['id'),
    '/': (context, match) => Index(),
  }).get,
));
```
