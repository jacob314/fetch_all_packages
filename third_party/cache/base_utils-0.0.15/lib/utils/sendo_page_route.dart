import 'package:base_utils/utils/logging_utils.dart';
import 'package:flutter/cupertino.dart';

class SendoPageRoute extends CupertinoPageRoute {
  SendoPageRoute({WidgetBuilder builder}) : super(builder: builder);

  Widget widget;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    log("~~~~> SendoPageRoute buildPage");

    if (widget == null) {
      widget = super.buildPage(context, animation, secondaryAnimation);
    }

    return widget;
  }

  @override
  void dispose() {
    log("~~~~> SendoPageRoute dispose");
    widget = null;
    super.dispose();
  }
}
