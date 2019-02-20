import 'dart:async';

import 'package:adhara/resources/r.dart';
import 'package:flutter/material.dart';

// Inherited widget for managing resources...
class ResInheritedWidget extends InheritedWidget {
  const ResInheritedWidget({Key key, this.res, Widget child})
      : super(key: key, child: child);

  final Resources res;

  @override
  bool updateShouldNotify(ResInheritedWidget old) {
    return res.language != old.res.language;
  }

  static Future<Resources> ofFuture(BuildContext context) async {
    return new Future.delayed(Duration.zero, () {
      return ResInheritedWidget.of(context);
    });
  }

  static Resources of(BuildContext context) {
    try {
      ResInheritedWidget riw =
          context.inheritFromWidgetOfExactType(ResInheritedWidget);
      return riw.res;
    } catch (e) {
      print("unable to get resources...");
      print(e);
      return null;
    }
  }
}
