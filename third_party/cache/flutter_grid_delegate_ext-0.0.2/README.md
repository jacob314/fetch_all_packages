## Simple SliverGridDelegate extension

Simple SliverGridDelegate extension, Height of big cell and small cell can be adjusted, `BigCellHeight >= SmallCellHeight`.

[![pub package](https://img.shields.io/pub/v/flutter_grid_delegate_ext.svg)](https://pub.dartlang.org/packages/flutter_grid_delegate_ext)

### Installation

Add dependency in `pubspec.yaml`:
```yaml
dependencies:
  flutter_grid_delegate_ext: "^0.0.2"
```

Import in your project:
```dart
import 'package:flutter_grid_delegate_ext/flutter_grid_delegate_ext.dart';
```

### Basic usage

#### Unequal cells height with first cell small
```
GridView.builder(
    gridDelegate: XSliverGridDelegate(
        crossAxisCount: 3,
        smallCellExtent: 100,
        bigCellExtent: 200,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        isFirstCellBig: false
    )
)
```
<img src="https://raw.githubusercontent.com/faob-dev/flutter_grid_delegate_ext/master/screenshots/layout1.jpg" width="200" height="355">

#### Unequal cells height with first cell big
```
GridView.builder(
    gridDelegate: XSliverGridDelegate(
        crossAxisCount: 3,
        smallCellExtent: 100,
        bigCellExtent: 200,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        isFirstCellBig: true
    )
)
```

<img src="https://raw.githubusercontent.com/faob-dev/flutter_grid_delegate_ext/master/screenshots/layout2.jpg" width="200" height="355">

#### Equal cells height
```
GridView.builder(
    gridDelegate: XSliverGridDelegate(
        crossAxisCount: 3,
        smallCellExtent: 200,
        bigCellExtent: 200,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
    )
)
```
<img src="https://raw.githubusercontent.com/faob-dev/flutter_grid_delegate_ext/master/screenshots/layout3.jpg" width="200" height="355">

### Examples

[example](https://github.com/faob-dev/flutter_grid_delegate_ext/tree/master/example) project contains demo


### Bugs/Requests
Reporting issues and requests for new features are always welcome.
