import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

@optionalTypeArgs
Route<T> buildPlatformAwareRoute<T extends Object>(
    {@required BuildContext context, @required WidgetBuilder builder}) {
  if (Theme.of(context).platform == TargetPlatform.iOS)
    return new CupertinoPageRoute<T>(builder: builder);
  return new MaterialPageRoute<T>(builder: builder);
}
