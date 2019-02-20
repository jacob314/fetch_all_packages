import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/i18n/strings.dart';
import 'package:icetea_studio_core/ui/styles/theme_screen_section.dart';

class InlineAddInput extends StatelessWidget {
  final String title;
  final VoidCallback onItemInteraction;

  const InlineAddInput(this.title, {Key key, @required this.onItemInteraction})
      : assert(onItemInteraction != null);

  @override
  Widget build(BuildContext context) {
    return
      new FlatButton(
        color: buildScreenSectionTheme().backgroundColor,
        child: new Container(
          child: new Center(
            child: new SizedBox(
              height: 70.0,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                    size: 25.0,
                  ),
                  new Padding(padding: EdgeInsets.all(10.0),
                    child: new Text(title ?? Strings
                        .of(context)
                        .common_btn_add),
                  ),

                ],
              ),
            ),
          ),
        ),
        onPressed: onItemInteraction,
      );
  }
}
