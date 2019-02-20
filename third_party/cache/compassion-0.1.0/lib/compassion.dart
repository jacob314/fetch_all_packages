library compassion;

import 'package:flutter/material.dart';

typedef ArgumentedRoute = Widget Function(
  BuildContext context,
  Object argument,
);

class Compass {
  const Compass(this.routes);

  final Map<String, ArgumentedRoute> routes;

  Route<dynamic> call(RouteSettings settings) => MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => CompassProvider(
              compass: this,
              child: routes[settings.name](
                context,
                settings.arguments,
              ),
            ),
      );

  static Compass of(BuildContext context, {bool nullOk = false}) {
    var maybeCompass = context.inheritFromWidgetOfExactType(CompassProvider);
    if (maybeCompass is CompassProvider) {
      return maybeCompass._compass;
    }
    if (!nullOk) {
      throw Exception("Unable to find a Compass in the tree.");
    }
    return null;
  }
}

class CompassProvider extends InheritedWidget {
  const CompassProvider({Compass compass, Widget child})
      : _compass = compass,
        super(child: child);

  final Compass _compass;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
