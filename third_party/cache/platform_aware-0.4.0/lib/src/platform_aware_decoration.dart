import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareDecoration extends PlatformAwareWidget {
  final Key key;
  final String title;

  PlatformAwareDecoration({@required this.title, this.key});

  @override
  Widget buildCupertino(BuildContext context) => new Container(
        child: new Column(
          children: <Widget>[
            new Row(children: <Widget>[
              new Expanded(
                  child: new Container(
                child: new Text(
                  title,
                  style: Theme.of(context).textTheme.caption,
                ),
                color: CupertinoColors.lightBackgroundGray,
                padding: const EdgeInsets.all(10.0),
              ))
            ], mainAxisAlignment: MainAxisAlignment.start),
          ],
        ),
      );

  @override
  Widget buildAndroid(BuildContext context) => Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.caption,
              )
            ], mainAxisAlignment: MainAxisAlignment.start),
            Container(
              height: 0.0,
              margin: EdgeInsets.only(top: 4.0, bottom: 5.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).accentColor, width: 2.0),
                ),
              ),
            ),
          ],
        ),
      );
}
