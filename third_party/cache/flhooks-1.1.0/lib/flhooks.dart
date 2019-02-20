library flhooks;

import 'package:flutter/widgets.dart';

/// [Hook] is the same as a property in the [State] of a [StatefulWidget].
/// [controller], [store] and [dispose] will be saved in the current [State].
///
/// [Hook] can only be created and modified by an [HookTransformer] function,
/// consumed by the [use] function.
class Hook<V, S> {
  const Hook({
    this.controller,
    this.store,
  });

  final V controller;
  final S store;
}

/// Define the type of an hook transformer function.
///
/// [HookTransformer] consume the current [Hook] in the context,
/// and return the new [Hook].
/// [HookTransformer] can only be consumed by the [use] function.
typedef HookTransformer<V, S> = Hook<V, S> Function(Hook<V, S>);

class _DisposableController {
  _DisposableController(this.onDispose);

  final Function onDispose;

  void dispose() {
    if (this.onDispose != null) {
      this.onDispose();
    }
  }
}

void _dispose(Hook hook) {
  if (hook != null && hook.controller is _DisposableController) {
    hook.controller.dispose();
  }
}

class _HookContext {
  _HookContext({
    this.setState,
    this.hooks,
  });

  final StateSetter setState;
  final List<Hook> hooks;
  int index = 0;
}

_HookContext _currentHookContext;

/// Define the type of a builder function how can use Hooks.
typedef HookWidgetBuilder = Widget Function(BuildContext);

class _HookBuilderState extends State<HookBuilder> {
  _HookBuilderState() {
    _hooks = [];
  }

  List<Hook> _hooks;

  @override
  Widget build(BuildContext context) {
    _currentHookContext = _HookContext(
      hooks: _hooks,
      setState: setState,
    );
    final result = widget.builder(context);
    _currentHookContext = null;
    return result;
  }

  @override
  void dispose() {
    _hooks.forEach(_dispose);
    super.dispose();
  }
}

/// [HookBuilder] is like a [StatefulBuilder] how build the [builder] function.
/// Hooks function can be used only in the [builder] function.
///
/// ```dart
/// // Define a Slider Page
/// final SliderPage = () =>
///    HookBuilder(
///      builder: (BuildContext context) {
///        // define a state of type double
///        final example = useState(0.0);
///        final onChanged = useCallback((double newValue) {
///          // set example.value for update the value in state
///          example.value = newValue;
///        }, [example]);
///        return Material(
///          child: Center(
///            child: Slider(
///              key: sliderKey,
///              value: example.value,
///              onChanged: onChanged,
///            ),
///          ),
///        );
///      },
///    );
/// // Start the app
/// void main() =>
///     runApp(MaterialApp(
///       home: SliderPage(),
///     ));
/// ```
class HookBuilder extends StatefulWidget {
  HookBuilder({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);

  final HookWidgetBuilder builder;

  @override
  State<StatefulWidget> createState() {
    return _HookBuilderState();
  }
}

/// [use] consume the [transformer],
/// return the [Hook.controller] of the [Hook] generated by the [transformer],
/// store the [Hook] in the current hooks context.
///
/// All Hooks function will start with use, and call [use] directly or indirectly.
/// [use] can only be used in the [HookBuilder.builder],
/// abort the execution if the hook context is not well formed.
///
/// ### Good
/// ```dart
///   final useAsync = () => use(AsyncTransformer(...));
/// ```
///
/// ### Bad
/// ```dart
///   final asyncHook = () => AsyncTransformer(...)();
/// ```
V use<V, S>(HookTransformer<V, S> transformer) {
  assert(
      _currentHookContext != null, 'the current hooks context cannot be null');
  assert(_currentHookContext.index != null,
      'the current index of the hook context cannot be null');
  assert(_currentHookContext.hooks != null,
      'the current hooks of the hook context cannot be null');
  assert(_currentHookContext.setState != null,
      'the current setState of the hook contect cannot be null');
  final _currentHooks = _currentHookContext.hooks;
  final _currentIndex = _currentHookContext.index;
  if (_currentHooks.length <= _currentIndex) {
    _currentHooks.length = _currentIndex + 1;
  }
  var currentHook = _currentHooks[_currentIndex];
  // check type change for hot reload and eventually dispose
  if (currentHook != null) {
    if (currentHook is! Hook<V, S>) {
      debugPrint(
          'Hook Type change detected, the hook will be disposed and resetted');
      _dispose(currentHook);
      currentHook = null;
    }
  }
  final hook = transformer(currentHook);
  assert(hook != null, 'a transformer cannot return null value');
  _currentHooks[_currentIndex] = hook;
  _currentHookContext.index += 1;
  return hook.controller;
}

bool _storeEquals(List one, List two) =>
    one == two || one.every((o) => two.any((t) => t == o));

/// Return the memoized value of [fn].
///
/// [fn] will be recalled only if [store] change.
/// ```dart
/// final helloMessage = useMemo(() => 'Hello ${name}', [name]);
/// ```
V useMemo<V>(V Function() fn, List store) {
  return use<V, List>((current) {
    if (current != null) {
      if (_storeEquals(store, current.store)) {
        return current;
      }
      _dispose(current);
    }
    return Hook(
      controller: fn(),
      store: store,
    );
  });
}

/// Exec [fn] at first call or if [store] change.
/// If [fn] return a function, this will be called if [store] change
/// or when the widget dispose.
///
/// ```dart
/// final helloMessage = useEffect(() {
///   final pub = stream.listen(callback);
///   return () => pub.cancel();
/// }, [stream]);
/// ```
///
/// [useEffect] is useful for async or stream subscription.
void useEffect(Function Function() fn, List store) {
  useMemo(() => _DisposableController(fn()), store);
}

/// Return the first reference to [fn].
///
/// [fn] reference will change only if [store] change.
/// ```dart
/// final onClick = useCallback(() => ..., [input1, input2]);
/// ```
/// It's the same as passing `() => fn` to [useMemo].
Function useCallback(Function fn, List store) => useMemo(() => fn, store);

/// Is an hook state controller..
class StateController<V> {
  StateController({
    @required V value,
    @required this.setState,
  }) : _value = value;

  V _value;

  V get value => _value;

  set value(V newValue) => setState(() {
        _value = newValue;
      });

  final StateSetter setState;

  @Deprecated(
      'Use `state.value = newValue` instead. Will be removed in future release.')
  void set(V newValue) => value = newValue;
}

/// Return an [StateController] with
/// [StateController.value] as [initial], or the latest set..
/// `state.value = newValue` Will trigger the rebuild of the [StatefulBuilder].
///
/// ```dart
/// final name = useState('');
/// // ... get the value
/// Text(name.value);
/// //... update the value and rebuild the component
/// onChange: (newValue) => name.value = newValue;
/// ```
StateController<V> useState<V>(V initial) {
  return useMemo(
      () => StateController<V>(
            value: initial,
            setState: _currentHookContext.setState,
          ),
      []);
}