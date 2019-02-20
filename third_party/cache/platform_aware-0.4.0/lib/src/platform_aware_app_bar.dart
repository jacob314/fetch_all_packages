library platform_aware;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

const double _kNavBarPersistentHeight = 44.0;
const double _kNavBarBackButtonTapWidth = 50.0;

PreferredSizeWidget buildAndroidAppBar(BuildContext context,
        {Widget title,
        Iterable<Widget> actions,
        Widget leading,
        Widget bottom}) =>
    new AppBar(
      centerTitle: true,
      title: title,
      actions: actions,
      leading: leading,
      bottom: bottom,
    );

ObstructingPreferredSizeWidget buildCupertinoAppBar(BuildContext context,
        {Widget title, Iterable<Widget> actions, Widget leading}) =>
    new CupertinoNavigationBar(
      leading: leading ??
          (Navigator.of(context)?.canPop() == true
              ? new Tooltip(
                  message: MaterialLocalizations.of(context).backButtonTooltip,
                  child: new CupertinoButton(
                    child: new Container(
                        key: new Key('backButton'),
                        height: _kNavBarPersistentHeight,
                        width: _kNavBarBackButtonTapWidth,
                        alignment: AlignmentDirectional.centerStart,
                        child: const Icon(
                          CupertinoIcons.back,
                          size: 34.0,
                        )),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ))
              : null),
      middle: title,
      trailing: actions == null
          ? null
          : new Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
    );

class PlatformAwareAppBar extends PlatformAwareWidget {
  final Widget title;
  final Widget leading;
  final Iterable<Widget> actions;

  PlatformAwareAppBar({this.title, this.leading, this.actions});

  @override
  Widget buildAndroid(BuildContext context) => buildAndroidAppBar(context,
      title: title, actions: actions, leading: leading);

  @override
  Widget buildCupertino(BuildContext context) => buildCupertinoAppBar(context,
      title: title, actions: actions, leading: leading);
}
