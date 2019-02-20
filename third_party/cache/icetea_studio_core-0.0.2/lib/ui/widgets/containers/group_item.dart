import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  GroupItem({Key key, this.child, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: FractionalOffset.topLeft,
        padding: padding,
        margin: new EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0),
        decoration: new BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(0.0),
            /*border: BorderDirectional(bottom: BorderSide(
                color: Theme.of(context).dividerColor
            )),*/
            boxShadow: <BoxShadow>[
              new BoxShadow(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  blurRadius: 0.0,
                  offset: new Offset(0.0, 0.0))
            ]),
        child: new Padding(padding: const EdgeInsets.all(0.0), child: child));
  }
}
