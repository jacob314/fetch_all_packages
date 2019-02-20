## How to use
This widget has the same API as TabBar widget in Flutter
[TabBar API](https://docs.flutter.io/flutter/material/TabBar-class.html)

```dart
import 'package:flutter_tab_bar_no_ripple/flutter_tab_bar_no_ripple.dart';
```

```dart
TabBarNoRipple(
  controller: _controller,
  isScrollable: true,
  indicator: getIndicator(),
  tabs: _allPages.map<Tab>((_Page page) {
    assert(_demoStyle != null);
    switch (_demoStyle) {
      case TabsDemoStyle.iconsAndText:
        return Tab(text: page.text, icon: Icon(page.icon));
      case TabsDemoStyle.iconsOnly:
        return Tab(icon: Icon(page.icon));
      case TabsDemoStyle.textOnly:
        return Tab(text: page.text);
    }
    return null;
  }).toList(),
);

```