import 'package:built_bloc/built_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_built_bloc/src/bloc_provider.dart';

class Blocs {
  Widget _result;

  Blocs(Widget child) : _result = child;

  void add<T extends Bloc>(T bloc) =>
      _result = BlocProvider<T>(bloc: bloc, child: _result);

  Widget _build() => _result;
}

/// An helper widget that makes easier to register multiple [Bloc]s.
/// 
/// This will simply produce a tree of [BlocProvider] from all blocs
/// added to the [creator] and with the [child] as the last descendant 
/// widget.
class BlocProviders extends StatelessWidget {
  final Widget child;

  BlocProviders(
      {@required Widget child, @required Blocs blocs(Blocs creator)})
      : assert(blocs != null),
        this.child = blocs(Blocs(child))._build();

  @override
  Widget build(BuildContext context) => this.child;
}