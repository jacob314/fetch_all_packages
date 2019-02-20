import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/bottom_menu_item_theme.dart';

class BottomMenuItem extends StatefulWidget {
  final IconData icon;
  final VoidCallback onItemInteraction;
  final bool isActive;
  final int counter;

  BottomMenuItem({this.icon, this.isActive, this.counter, this.onItemInteraction});

  @override
  _BottomMenuItemState createState() => _BottomMenuItemState();
}

class _BottomMenuItemState extends State<BottomMenuItem> {

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.all(5.0),
        height: 50.0,
        alignment: FractionalOffset.center,
        child: widget.onItemInteraction == null
            ? new Container()
            : new InkWell(
            child: new SizedBox(
                height: 100.0,
                child: new FlatButton(
                    color: Colors.transparent,
                    onPressed: () {
                      widget.onItemInteraction();
                    },
                    child: new Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        new Container(
                            alignment: Alignment.center,
                            child: new Icon(
                              widget.icon,
                              color: widget.isActive ? Theme
                                  .of(context)
                                  .primaryColor
                                  : Theme
                                  .of(context)
                                  .disabledColor,
                              size: 25.0,
                            )
                        ), (widget.counter != null && widget.counter > 0) ?
                        new Container(
                          padding: new EdgeInsets.all(3.0),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme
                                  .of(context)
                                  .accentColor
                          ),
                          child: new Text('${widget.counter > 10 ? '9+' : widget.counter}', maxLines: 1, overflow: TextOverflow.ellipsis, style: BottomMenuItemTheme(context).textTheme.body1,),
                        ) : new Container()

                      ],
                    )
                )
            )
        )
    );
  }
}