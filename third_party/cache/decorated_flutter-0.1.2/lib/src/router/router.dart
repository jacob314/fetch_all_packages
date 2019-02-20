import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

import '../ui/loading.widget.dart';

typedef void _InitAction<T extends BLoC>(T bloc);
typedef Widget _RouteBuilder(
  BuildContext context,
  Widget child,
  Animation<double> animation,
);

@Deprecated('用系统提供的Navigator代替')
class Router {
  /// 导航
  @Deprecated('建议使用onGenerateRoute方法去路由, 但是这个方法目前没用发现bug, 也还是可以使用的')
  static Future<T> navigate<B extends BLoC, T>(
    /// context
    BuildContext context, {

    /// 是否替换route
    bool replace = false,

    /// 自定义的PageRoute, 如果传入了这个参数, 那么就不再使用本方法构造的[MaterialPageRoute]
    /// 并且以下参数均不再有效
    PageRoute<T> route,

    /// 是否自动关闭输入法
    bool autoCloseKeyboard = true,

    /// 目标Screen
    Widget screen,

    /// 是否全屏dialog, 传递给[MaterialPageRoute]
    bool fullScreenDialog = false,

    /// 是否maintain state, 传递给[MaterialPageRoute]
    bool maintainState = true,

    /// 初始化方法
    _InitAction<B> init,

    /// 直接传递的BLoC, 如果没有设置, 那么就去kiwi里去获取
    B bloc,
  }) {
    B _bloc;
    // 优先使用参数里传递的BLoC
    if (bloc != null) {
      _bloc = bloc;
    } else if (B != BLoC) {
      // 说明BLoC泛型被设置, 那么去kiwi里去获取实例
      _bloc = kiwi.Container().resolve();
    }

    Widget child;
    if (isNotEmpty(_bloc)) {
      child = BLoCProvider<B>(
        bloc: _bloc,
        init: init,
        child: autoCloseKeyboard ? AutoCloseKeyboard(child: screen) : screen,
      );
    } else {
      child = autoCloseKeyboard ? AutoCloseKeyboard(child: screen) : screen;
    }

    route ??= MaterialPageRoute(
      fullscreenDialog: fullScreenDialog,
      maintainState: maintainState,
      builder: (context) => child,
      settings: RouteSettings(name: screen.runtimeType.toString()),
    );

    if (replace) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push<T>(route);
    }
  }

  /// 自定义导航
  @Deprecated('用navigate代替')
  static Future<T> navigateCustom<T>(BuildContext context, PageRoute<T> route) {
    return Navigator.of(context).push<T>(route);
  }

  /// 自定义route的导航
  @Deprecated('用navigate代替')
  static Future<T> navigateRouteBuilder<T>({
    @required BuildContext context,
    @required _RouteBuilder builder,
    @required Widget child,
    bool fullScreenDialog = false,
    Duration transitionDuration = const Duration(milliseconds: 600),
    Color barrierColor,
    bool barrierDismissible = false,
    String barrierLabel,
  }) async {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<Null>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return AnimatedBuilder(
            animation: animation,
            child: child,
            builder: (BuildContext context, Widget child) {
              return builder(context, child, animation);
            },
          );
        },
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        settings: RouteSettings(name: child.runtimeType.toString()),
      ),
    );
  }

  /// 不保留源页面的跳转
  @Deprecated('用navigate代替')
  static void navigateReplace(
    BuildContext context,
    Widget widget, {
    bool fullScreenDialog = false,
  }) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        fullscreenDialog: fullScreenDialog,
        builder: (context) => widget,
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
    );
  }

  /// 提供BLoC的导航
  @Deprecated('用navigate代替')
  static Future<R> navigateWithBLoC<B extends BLoC, R>(
    BuildContext context,
    Widget widget, {
    _InitAction<B> init,
    bool fullScreenDialog = false,
  }) {
    final bloc = kiwi.Container().resolve<B>();
    return Navigator.of(context).push<R>(
      MaterialPageRoute(
        fullscreenDialog: fullScreenDialog,
        builder: (context) {
          return BLoCProvider<B>(
            bloc: bloc,
            child: AutoCloseKeyboard(
              child: Builder(
                builder: (context) {
                  if (init != null) init(bloc);
                  return widget;
                },
              ),
            ),
          );
        },
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
    );
  }

  /// 退出当前页
  static void pop<T>(BuildContext context, [T data]) {
    Navigator.of(context).pop<T>(data);
  }

  /// 退出到目标页
  static void popTo<T>(BuildContext context, Type routeType) {
    Navigator.of(context).popUntil(
      (route) => route.settings.name == routeType.toString(),
    );
  }

  static void pushAndClearAll(BuildContext context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(name: widget.runtimeType.toString()),
      ),
      (route) => false,
    );
  }

  /// 等待页
  static Future<T> loading<T>(BuildContext context, Future<T> futureTask) {
    showDialog(
      context: context,
      builder: (context) => LoadingWidget(),
      barrierDismissible: false,
    );
    return futureTask.whenComplete(() {
      pop(context);
    });
  }
}
