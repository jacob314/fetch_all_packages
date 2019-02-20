library virgil;

import 'package:flutter/material.dart';

// ignore_for_file: avoid_catching_errors
//   Needed to explain routing failures.
// ignore_for_file: avoid_annotating_with_dynamic
//   Needed to allow arbitrary arguments

/// Inferno contains the routes that Virgil will navigate to.
/// It should be placed in the `home:` property of your `*App` widget.
/// You should call .home(context) directly after creating Inferno.
///
///     MaterialApp(
///        home: Inferno(
///          {
///            '/': (context, arguments) => PageOne(),
///            '/hello': (context, arguments) => PageTwo(arguments),
///          },
///        ).home(context, '/'),
///     );
class Inferno {
  /// Creates an Inferno object
  /// The first argument is Map<String, Widget Function(BuildContext, dynamic)>,
  /// The second argument is a pageRouteBuilder
  const Inferno(this._routes,
      {Route Function(RouteSettings, Widget Function(BuildContext))
          pageRouteBuilder = Inferno._defaultBuilder})
      : _pageRouteBuilder = pageRouteBuilder;

  final Map<String, Widget Function(BuildContext, dynamic)> _routes;
  final Route Function(RouteSettings, Widget Function(BuildContext))
      _pageRouteBuilder;

  static Route _defaultBuilder(
          RouteSettings s, Widget Function(BuildContext) b) =>
      MaterialPageRoute(builder: b);

  /// Creates the root immediately,
  /// and inserts a virgil instance at the root.
  Widget home(BuildContext context, [String initialRoute = '/']) => Virgil._(
        this,
        _routes[initialRoute](context, null),
        GlobalObjectKey(this),
      );
}

/// Virgil allows you to navigate to named routes defined in Inferno
/// and provide them with arguments at the same time.
class Virgil extends InheritedWidget {
  const Virgil._(this._inferno, Widget child, Key key)
      : super(key: key, child: child);
  final Inferno _inferno;

  /// Returns an instance of Virgil that contains a context.
  static _Virgil of(BuildContext context) {
    final virgil = context.inheritFromWidgetOfExactType(Virgil);
    if (virgil == null) {
      throw FlutterError('Unable to find Virgil in the tree.');
    }
    return _Virgil(context, virgil);
  }

  /// Push a named route with arguments onto the navigator
  /// that most tightly encloses the given context.
  @optionalTypeArgs
  static Future<T> pushNamed<T, U>(BuildContext context, String routeName,
          {U arguments}) =>
      Virgil.of(context).pushNamed<T, U>(routeName, arguments: arguments);

  /// Push the route with the given name and arguments onto the navigator
  /// that most tightly encloses the given context,
  /// and then remove all the previous routes until the predicate returns true.
  @optionalTypeArgs
  static Future<T> pushNamedAndRemoveUntil<T, U>(
          BuildContext context, String routeName, RoutePredicate predicate,
          {U arguments}) =>
      Virgil.of(context).pushNamedAndRemoveUntil<T, U>(routeName, predicate,
          arguments: arguments);

  /// Replace the current route of the navigator
  /// that most tightly encloses the given context
  /// by pushing the route named routeName with arguments
  /// and then disposing the previous route
  /// once the new route has finished animating in.
  @optionalTypeArgs
  static Future<T> pushReplacementNamed<T, U, TO>(
          BuildContext context, String routeName, {TO result, U arguments}) =>
      Virgil.of(context).pushReplacementNamed<T, U, TO>(routeName,
          result: result, arguments: arguments);

  /// Pop the current route off the navigator
  /// that most tightly encloses the given context
  /// and push a named route with arguments in its place.
  @optionalTypeArgs
  static Future<T> popAndPushNamed<T, U, TO>(
          BuildContext context, String routeName, {TO result, U arguments}) =>
      Virgil.of(context).popAndPushNamed<T, U, TO>(routeName,
          result: result, arguments: arguments);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class _Virgil {
  const _Virgil(BuildContext context, Virgil virgil)
      : _context = context,
        _virgil = virgil;
  final BuildContext _context;
  final Virgil _virgil;

  /// Push a named route with arguments onto the navigator
  /// that most tightly encloses the given context.
  @optionalTypeArgs
  Future<T> pushNamed<T, U>(String routeName, {U arguments}) {
    if (_virgil._inferno._routes[routeName] == null) {
      try {
        return Navigator.of(_context).pushNamed<T>(routeName);
      } on FlutterError {
        _routeNotFound();
        rethrow;
      }
    }
    return Navigator.of(_context).push<T>(
      _routeBuilder<T>(
        _virgil._inferno._routes[routeName](_context, arguments),
        routeName,
      ),
    );
  }

  /// Push the route with the given name and arguments onto the navigator
  /// that most tightly encloses the given context,
  /// and then remove all the previous routes until the predicate returns true.
  @optionalTypeArgs
  Future<T> pushNamedAndRemoveUntil<T, U>(
      String routeName, RoutePredicate predicate,
      {U arguments}) {
    if (_virgil._inferno._routes[routeName] == null) {
      try {
        return Navigator.of(_context)
            .pushNamedAndRemoveUntil<T>(routeName, predicate);
      } on FlutterError {
        _routeNotFound();
        rethrow;
      }
    }
    return Navigator.of(_context).pushAndRemoveUntil<T>(
      _routeBuilder(
        _virgil._inferno._routes[routeName](_context, arguments),
        routeName,
      ),
      predicate,
    );
  }

  /// Replace the current route of the navigator
  /// that most tightly encloses the given context
  /// by pushing the route named routeName with arguments
  /// and then disposing the previous route
  /// once the new route has finished animating in.
  @optionalTypeArgs
  Future<T> pushReplacementNamed<T, U, TO>(String routeName,
      {TO result, U arguments}) {
    if (_virgil._inferno._routes[routeName] == null) {
      try {
        return Navigator.of(_context)
            .pushReplacementNamed<T, TO>(routeName, result: result);
      } on FlutterError {
        _routeNotFound();
        rethrow;
      }
    }
    return Navigator.of(_context).pushReplacement<T, TO>(
      _routeBuilder(
        _virgil._inferno._routes[routeName](_context, arguments),
        routeName,
      ),
      result: result,
    );
  }

  /// Pop the current route off the navigator
  /// that most tightly encloses the given context
  /// and push a named route with arguments in its place.
  @optionalTypeArgs
  Future<T> popAndPushNamed<T, U, TO>(String routeName,
      {TO result, U arguments}) {
    if (_virgil._inferno._routes[routeName] == null) {
      try {
        return Navigator.of(_context)
            .popAndPushNamed<T, TO>(routeName, result: result);
      } on FlutterError {
        _routeNotFound();
        rethrow;
      }
    }
    Navigator.of(_context).pop<TO>(result);
    return Navigator.of(_context).push<T>(
      _routeBuilder(
        _virgil._inferno._routes[routeName](_context, arguments),
        routeName,
      ),
    );
  }

  Route<T> _routeBuilder<T>(Widget child, String name) =>
      _virgil._inferno._pageRouteBuilder(
        RouteSettings(name: name),
        (c) => Virgil._(_virgil._inferno, child, GlobalObjectKey(this)),
      );

  void _routeNotFound() {
    print('══╡ EXCEPTION CAUGHT BY VIRGIL ╞══════════════════\n'
        '══════════════════════════════════════════════════\n'
        'The requested route was not found,\n'
        'and was relayed to the underlying navigator,'
        'which did not find it either.');
  }
}
