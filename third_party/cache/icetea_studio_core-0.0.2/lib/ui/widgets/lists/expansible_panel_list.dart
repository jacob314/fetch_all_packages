import 'package:flutter/material.dart';

typedef List<Widget> ExpansiblePanelChildrenBuilder();
typedef String ExpansibleItemTitleBuilder(BuildContext context);

class ExpansiblePanelItem {
  final ExpansibleItemTitleBuilder titleBuilder;
  final ExpansiblePanelChildrenBuilder builder;
  final IconData titleIcon;
  final VoidCallback onTitlePressed;
  bool isExpanded;

  ExpansiblePanelItem({
    @required this.titleBuilder,
    @required this.builder,
    this.isExpanded = false,
    this.titleIcon,
    this.onTitlePressed
  });

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {

      List<Widget> children = [];
      if (this.titleIcon != null) {
        children.add(new Expanded(
            flex: 1,
            child: new Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: new Icon(this.titleIcon, size: 18.0, color: Theme
                  .of(context)
                  .accentColor,),
            )
        ));
      }

      children.add(Expanded(
          flex: 5,
          child: new Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: new Text(this.titleBuilder(context),
              style: new TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontWeight: FontWeight.bold),
            ),
          )
      ));

      return new GestureDetector(
          onTap: () {
            if (this.onTitlePressed != null) {
              this.onTitlePressed();
            }
          },
          child:
          new Container(
            child: new Row(
              children: children
            ),
          )
      );
    };
  }

  Widget build() {
    return new Wrap(
      children: this.builder().map((Widget widget) =>
      new Padding(
        padding: const EdgeInsets.all(4.0),
        child: widget,
      )).toList(),
    );
  }

}
