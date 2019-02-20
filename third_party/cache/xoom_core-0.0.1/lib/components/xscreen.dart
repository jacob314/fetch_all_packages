library xoom_core;

import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:xoom_core/components/xlayout.dart';

/* -----------------------------------------------
    Variable Type Alias
  ------------------------------------------------ */

typedef _WidgetIFunction = Widget Function();
typedef _XScreenIFunction = XScreen Function();

/* -----------------------------------------------
    XOOM Screen Class Helpers
  ------------------------------------------------ */

class _XOOMScreen extends StatelessWidget {
  final _WidgetIFunction _ae;
  _XOOMScreen(this._ae);

  @override
  Widget build(BuildContext context) =>
      _Store()._statusVerify == 0 ? null : _ae();
}

class _XOOMPage extends StatefulWidget {
  final _XScreenIFunction _ae;
  _XOOMPage(this._ae);

  @override
  State<StatefulWidget> createState() =>
      _Store()._statusVerify == 0 ? null : _ae();
}

abstract class _XOOMPageState extends State<_XOOMPage> {
  final _screenModel = _XOOMScreenModel();
  var _canSetState = true;

  _XOOMPageState() {
    var statusVerify = _Store()._statusVerify;
    if (statusVerify == -1) {
      _doSetup();
      _packageVerify();
    } else if (statusVerify == 0) {
      _canSetState = false;
    } else if (statusVerify == 1) {
      _doSetup();
    }
  }

  _packageVerify() async {
    final apps = [
      "com.asuransiastra.spro",
    ];

    final info = await PackageInfo.fromPlatform();
    final packageName = info.packageName.toLowerCase();
    final index = apps.indexWhere((app) => app == packageName);

    if (index == -1) {
      _canSetState = false;
      _screenModel._setupModel.layout.screen = null;
      _Store()._statusVerify = 0;
    } else {
      _Store()._statusVerify = 1;
    }
  }

  _doSetup();

  main(_XOOMScreenSetupModel model);

  @override
  void setState(fn) {
    if (_canSetState) {
      super.setState(fn);
    }
  }
}

/* -----------------------------------------------
    Class Models
  ------------------------------------------------ */

class _XOOMScreenModel {
  _XOOMScreen _screen;
  _XOOMPage _page;
  var _setupModel = _XOOMScreenSetupModel();
}

class _XOOMScreenSetupModel {
  Widget app;
  XLayout layout;
}

/* -----------------------------------------------
    Class Store
  ------------------------------------------------ */

class _Store {
  static _Store _instance;
  factory _Store() => _instance ??= new _Store._();
  _Store._();

  var _statusVerify = -1;
}

/* -----------------------------------------------
    XOOM Screen
  ------------------------------------------------ */

abstract class XScreen extends _XOOMPageState {
  show() => _screenModel._screen;
  @protected
  home() => _screenModel._page;

  @override
  Widget build(BuildContext context) => _Store()._statusVerify == 0
      ? null
      : _screenModel._setupModel.layout.build();

  @override
  _doSetup() {
    _screenModel._screen = _XOOMScreen(() => _screenModel._setupModel.app);
    _screenModel._page = _XOOMPage(() => this);
    main(_screenModel._setupModel);
    _screenModel._setupModel.layout.screen = this;
  }

  /// Refresh the User Interface
  @protected
  refreshUI() => setState(() {});

  /// Use on async function, this same like sleep on java.
  @protected
  delay(int milliseconds) =>
      new Future.delayed(Duration(milliseconds: milliseconds));
}
