# flutter_parallax

A Flutter widget that moves according to a scroll controller.

[![Pub](https://img.shields.io/pub/v/flutter_parallax.svg)](https://pub.dartlang.org/packages/flutter_parallax)

## Features

* Can contain **any** widget.
* Configurable parallax scroll direction.
* Customizable parallax delegate.
* For widgets inside **and** outside a scroll view (list items and list backgrounds for example). 

![Screenshot](https://raw.githubusercontent.com/letsar/flutter_parallax/master/doc/images/parallax.gif)

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  flutter_parallax: "^0.1.2"
```

In your library add the following import:

```dart
import 'package:flutter_parallax/flutter_parallax.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Example

```dart
new Parallax.inside(
    child: new Image.network('https://flutter.io/images/homepage/header-illustration.png'),
    mainAxisExtent: 150.0,
);
```

You can find more examples in the [Example](https://github.com/letsar/flutter_parallax/tree/master/example) project.

## Constructors

* The `Parallax.inside`, that computes the parallax offset from its position in its first `Scrollable` parent.
Useful for list or grid items.
* The `Parallax.outside`, that computes the parallax offset from the percentage of the scrollable's container extent.
Useful for a list or grid background.
* The `Parallax.custom` takes a `ParallaxDelegate`, which provides the ability to customize additional aspects of the child model. For example, a `ParallaxDelegate`
can control the algorithm used to computes the parallax offset of the child within its parent.

## Changelog

Please see the [Changelog](https://github.com/letsar/flutter_parallax/blob/master/CHANGELOG.md) page to know what's recently changed.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/letsar/flutter_parallax/issues).  
If you fixed a bug or implemented a new feature, please send a [pull request](https://github.com/letsar/flutter_parallax/pulls).