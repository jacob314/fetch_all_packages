
import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/helper/instance_manager.dart';

class ActionButton extends StatefulWidget {
  final String id;
  final String text;
  final IconData iconName;
  final String actionId;
  final TextStyle textStyle;

  final dynamic onPressed;

  ActionButton({
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

class _MenuIconState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    InstanceManager.setInstance(widget.id, this);

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
