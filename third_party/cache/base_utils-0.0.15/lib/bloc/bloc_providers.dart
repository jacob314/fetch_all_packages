import 'package:base_utils/bloc/base_bloc.dart';
import 'package:base_utils/utils/logging_utils.dart';
import 'package:flutter/material.dart';

/// Provide [bloc] for it's [child] Widgets, every Widget under this Widget
/// can access the bloc without passing the bloc down the widget tree.
///
/// To access the bloc, use the [of] method
/// E.g:
///
/// BlocProvider<HomeBloc>(
///   child: HomePage(),
///   bloc: HomeBloc()
/// )
///
/// final homeBloc = BlocProvider<HomeBloc>.of(context)

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final Widget child;

  T bloc;

  BlocBuilder builder;

  BlocProvider({Key key, @required this.child, this.bloc, this.builder})
      : super(key: key);

  @override
  BlocProviderState<T> createState() => BlocProviderState<T>();

  static T of<T extends BaseBloc>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();

    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    if (provider?.bloc != null) {
      return provider?.bloc;
    } else if (provider?.builder != null) {
      final state = 
          context.ancestorStateOfType(TypeMatcher<BlocProviderState<T>>());
      if (state is BlocProviderState) {
        log('BlocProvider.of: Retrieving cached bloc');
        if (state.cachedBloc == null) {
          log('BlocProvider.of: Creating new bloc');
          state.cachedBloc = provider?.builder();
        }
        return state.cachedBloc;
      }
    }
  }

  static Type _typeOf<T>() => T;
}

class BlocProviderState<T extends BaseBloc> extends State<BlocProvider<T>> {
  BaseBloc cachedBloc;

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc?.dispose();
    cachedBloc?.dispose();
    super.dispose();
  }
}

typedef BlocBuilder = BaseBloc Function();
