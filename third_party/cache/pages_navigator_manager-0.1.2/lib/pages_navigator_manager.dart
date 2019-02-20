import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class PagesNavigatorManager extends StatefulWidget {
  final Widget rootPage;
  PagesNavigatorManager({Key key, @required this.rootPage}) : super(key: key);

  @override
  _PagesNavigatorManagerState createState() => _PagesNavigatorManagerState();
}

class _PagesNavigatorManagerState extends State<PagesNavigatorManager> {
  @override
  Widget build(BuildContext context) {
    final PageNavigator pageNavigatorBloc =
    PageNavigator(context: context);
    return BlocProvider<PageNavigator>(
      bloc: pageNavigatorBloc,
      child: Navigator(key:GlobalKey(),onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          return widget.rootPage;
        }, settings: routeSettings);
      }),
    );
  }
}

/// A class to keep the root context
class PageNavigator extends BlocBase {
  final BuildContext context;

  PageNavigator({@required this.context});

  dismissPageNavigator(dynamic result) {
    Navigator.of(context).pop(result);
  }
  static of(BuildContext ctx){
    return BlocProvider.of<PageNavigator>(ctx);
  }

  dispose() {}
}
