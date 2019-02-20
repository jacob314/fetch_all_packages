import 'package:exwidgets/src/helper/ex_instance_manager.dart';
import 'package:flutter/material.dart';

class ExActionButton extends StatefulWidget {
  final String id;
  final String text;
  final IconData iconName;
  final String actionId;
  final TextStyle textStyle;

  final dynamic onPressed;

  ExActionButton({
    this.text,
    this.iconName,
    this.actionId,
    this.id,
    this.textStyle,
    @required this.onPressed,
    Key key,
  });

  @override
  _MenuIconState createState() => _MenuIconState();
}

class _MenuIconState extends State<ExActionButton> {
  @override
  Widget build(BuildContext context) {
    ExInstanceManager.setInstance(widget.id, this);

    return Container(
      height: 50.0,
      width: 140.0,
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      child: RaisedButton(
        onPressed: () {
          widget.onPressed();
        },
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(widget.iconName),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: widget.textStyle != null
                    ? widget.textStyle
                    : TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
