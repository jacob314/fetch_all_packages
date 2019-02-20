import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareListTile extends PlatformAwareWidget {
  final Widget leading;
  final Widget trailing;
  final Widget title;
  final VoidCallback onTap;
  final Key key;
  final bool selected;

  PlatformAwareListTile(
      {this.key,
      this.leading,
      this.trailing,
      this.title,
      this.onTap,
      bool selected})
      : selected = selected ?? false;

  Widget _decorateAndroid(BuildContext context, Widget child) => new Container(
      margin: const EdgeInsets.only(top: 5.0),
      decoration: selected
          ? new BoxDecoration(
              color: Theme.of(context).backgroundColor,
            )
          : null,
      child: child);

  Widget _decorateCupertino(BuildContext context, Widget child) =>
      new Container(
          margin: const EdgeInsets.all(5.0),
          decoration: new ShapeDecoration(
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(5.0)),
                  side: new BorderSide(
                    color: CupertinoColors.activeBlue,
                    style: selected ? BorderStyle.solid : BorderStyle.none,
                  ))),
          child: child);

  @override
  Widget buildCupertino(BuildContext context) => _decorateCupertino(
      context,
      new GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            leading == null
                ? null
                : new Flexible(
                    child: leading,
                  ),
            title == null ? null : new Flexible(child: title, flex: 3),
            trailing == null
                ? null
                : new Flexible(
                    child: trailing,
                  ),
          ].where((Widget widget) => widget != null).toList(),
        ),
      ));

  @override
  Widget buildAndroid(BuildContext context) => _decorateAndroid(
      context,
      new ListTile(
        leading: leading,
        trailing: trailing,
        title: title,
        onTap: onTap,
      ));
}
