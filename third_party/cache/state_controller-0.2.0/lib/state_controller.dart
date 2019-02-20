///Copyright 2018 Miolin

///Licensed under the Apache License, Version 2.0 (the "License");
///you may not use this file except in compliance with the License.
///You may obtain a copy of the License at

///http://www.apache.org/licenses/LICENSE-2.0

///Unless required by applicable law or agreed to in writing, software
///distributed under the License is distributed on an "AS IS" BASIS,
///WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///See the License for the specific language governing permissions and
///limitations under the License.

library state_controller;

import 'package:flutter/widgets.dart';

abstract class ControllerCreator<W extends StatefulWidget,
    T extends StateController> extends State<W> with LifecycleSubject<W> {
  T _controller;

  T get controller => _controller;

  @protected
  @mustCallSuper
  void initState() {
    _controller = createController();
    _controller._state = this;
    _controller._context = context;
    subscribeToLifecycle(_controller);
    super.initState();
  }

  @mustCallSuper
  @protected
  @override
  Widget build(BuildContext context) {
    return ControllerInheritedWidget(
      controller: _controller,
      child: buildWidget(context),
    );
  }

  @protected
  Widget buildWidget(BuildContext context);

  @protected
  @mustCallSuper
  void didUpdateWidget(covariant W oldWidget) {
    _controller._context = context;
    super.didUpdateWidget(oldWidget);
  }

  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    _controller = null;
  }

  T createController();
}

class ControllerInheritedWidget extends InheritedWidget {
  final StateController controller;

  ControllerInheritedWidget({Key key, @required this.controller, @required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(ControllerInheritedWidget oldWidget) =>
      controller != oldWidget.controller;
}

class ControllerProvider {
  ControllerProvider._();

  static T provide<T extends StateController>(BuildContext context) {
    final inherit = context.inheritFromWidgetOfExactType(ControllerInheritedWidget) as ControllerInheritedWidget;
    final controller = inherit.controller;
    assert(controller is T);
    return controller as T;
  }
}

mixin LifecycleSubject<W extends StatefulWidget> on State<W> {
  final List<LifecycleCallback> _callbacks = List();
  bool _isInit = false;

  @protected
  @mustCallSuper
  void initState() {
    _callbacks.forEach((callback) => callback.onInitState());
    _isInit = true;
    super.initState();
  }

  @protected
  @mustCallSuper
  void dispose() {
    _callbacks.forEach((callback) => callback.onDispose());
    _callbacks.clear();
    super.dispose();
  }

  @protected
  @mustCallSuper
  void didUpdateWidget(covariant W oldWidget) {
    _callbacks.forEach((callback) => callback.onUpdateWidget());
    super.didUpdateWidget(oldWidget);
  }

  @mustCallSuper
  void subscribeToLifecycle(LifecycleCallback callback) {
    _callbacks.add(callback);
    if (_isInit) callback.onInitState();
  }
}

abstract class LifecycleCallback {
  @protected
  void onInitState();

  @protected
  void onUpdateWidget();

  @protected
  void onDispose();
}

mixin ControllerInjector<SC extends StateController> {
  SC get controller => ControllerProvider.provide(context);
  BuildContext get context;
}

abstract class StateController
    implements LifecycleCallback {
  State _state;
  BuildContext _context;

  BuildContext get context => _context;

  void changeState(VoidCallback fn) {
    if (_state == null) return;
    // ignore: invalid_use_of_protected_member
    _state.setState(fn);
  }

  @override
  @protected
  void onInitState() {}

  @override
  @protected
  void onUpdateWidget() {}

  @protected
  @mustCallSuper
  @override
  void onDispose() {
    _context = null;
    _state = null;
  }
}
