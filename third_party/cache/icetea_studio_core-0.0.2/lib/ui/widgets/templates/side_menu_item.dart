import 'package:flutter/material.dart';

/// This is [MenuItemView]
class MenuItemView extends StatelessWidget {
  const MenuItemView(this.name,
      {Key key,
      this.icon,
      this.iconColor,
      this.isShowDivider,
      this.onItemInteraction,
      this.isShowArrow = true})
      : assert(name != null),
        super(key: key);

  /// icon
  final Icon icon;

  ///
  final bool isShowDivider;

  ///
  final Color iconColor;

  ///
  final String name;

  final bool isShowArrow;

  ///
  final VoidCallback onItemInteraction;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FlatButton(
          onPressed: () {
            onItemInteraction();
          },
          child: new SizedBox(
            child: new Column(
              children: <Widget>[
                new GestureDetector(
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                    child: new Row(
                      children: <Widget>[
                        icon ??
                            new Icon(
                              Icons.audiotrack,
                              color:
                                  iconColor ?? Theme.of(context).primaryColor,
                              size: 22.0,
                            ),
                        new Expanded(
                            child: new Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: new Text(
                                name,
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.title.color),
                          ),
                        )),
                        isShowArrow
                            ? new Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).hintColor,
                                size: 20.0,
                              )
                            : new Container(),
                      ],
                    ),
                  ),
                  onTap: onItemInteraction,
                ),
                isShowDivider != null && isShowDivider
                    ? new Container(
                        height: 0.5,
                        color: Theme.of(context).dividerColor,
                      )
                    : new Container(),
              ],
            ),
          )),
    );
  }
}
