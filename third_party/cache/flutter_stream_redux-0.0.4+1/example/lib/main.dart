import 'package:built_redux/built_redux.dart';
import 'package:example/automatic_stream_connection.dart';
import 'package:example/generated/i18n.dart';
import 'package:example/manual_stream_connection.dart';
import 'package:example/redux/actions.dart';
import 'package:example/redux/middleware.dart';
import 'package:example/redux/models/app_state.dart';
import 'package:example/redux/reducer.dart';
import 'package:example/redux/stream_middleware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_built_redux/flutter_built_redux.dart' hide WidgetBuilder;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  final Store<AppState, AppStateBuilder, AppActions> store = new Store<AppState, AppStateBuilder, AppActions>(
    reducerBuilder,
    new AppState.initialState(),
    new AppActions(),
    middleware: <Middleware<AppState, AppStateBuilder, AppActions>>[
      createStoreMiddleware(),
      getStreamMiddleware(),
    ],
  );

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new ReduxProvider(
      store: widget.store,
      child: new MaterialApp(
        title: 'Stream Redux Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: const ManualStreamConnector(),
        routes: <String, WidgetBuilder>{
          'automatic': (BuildContext context) => const AutomaticStreamConnection(),
        },
      ),
    );
  }
}
