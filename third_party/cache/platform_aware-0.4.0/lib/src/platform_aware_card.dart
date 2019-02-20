import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareCard extends PlatformAwareWidget {
  final Widget title;
  final Widget content;

  PlatformAwareCard({@required this.title, @required this.content});

  @override
  Widget buildCupertino(BuildContext context) => _buildCard(context,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(25.0)));

  Widget _buildCard(BuildContext context, {ShapeBorder shape}) => Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        shape: shape,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
                tiles: <Widget>[
                  title,
                  content,
                ],
                context: context,
                color: Theme.of(context).dividerColor).toList()),
      ));

  @override
  Widget buildAndroid(BuildContext context) => _buildCard(context);
}
