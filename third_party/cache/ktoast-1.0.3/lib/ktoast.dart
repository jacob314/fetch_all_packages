library ktoast;

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

//export 'src/toast.dart' show showToast, KToast, ToastPosition;
export 'package:oktoast/oktoast.dart' show showToast, ToastPosition;

class KToast extends OKToast {
  final Widget child;
  final TextStyle textStyle;
  final Color backgroundColor;
  final double radius;
  final ToastPosition defaultPosition;

  const KToast({Key key, this.child, this.textStyle, this.radius, this.backgroundColor, this.defaultPosition}) : super(key: key);
}
