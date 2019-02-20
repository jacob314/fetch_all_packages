import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {

  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final EdgeInsetsGeometry padding;


  RemoveButton({@required this.onTap, this.size, this.iconSize, this.padding}) : assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(height: size ?? 48.0, width: size ?? 48.0,
        child: new Stack(
          children: <Widget>[
            new Container(
              alignment: Alignment.center,
              margin: padding ?? new EdgeInsets.all(15.0),
              decoration: new BoxDecoration(shape: BoxShape.circle, color: Theme
                  .of(context)
                  .backgroundColor),
            ),
            new IconButton(
              icon: new Icon (Icons.clear, size: iconSize ?? 15.0, color: Theme
                  .of(context)
                  .primaryColor,),
              onPressed: onTap,
            )
          ],
        )

    );
  }
}
