import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareAlertDialog extends PlatformAwareWidget {
  final Iterable<Widget> actions;
  final Widget title;
  final Widget content;

  PlatformAwareAlertDialog({this.actions, @required this.title, this.content});

  @override
  Widget buildCupertino(BuildContext context) => new CupertinoAlertDialog(
        actions: actions,
        title: title,
        content: content,
      );

  @override
  Widget buildAndroid(BuildContext context) => new AlertDialog(
        actions: actions,
        title: title,
        content: content,
      );
}
