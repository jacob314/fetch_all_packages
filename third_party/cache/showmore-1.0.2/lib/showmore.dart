

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ShowMore extends StatefulWidget{

  /// The string which will be used by Text widget
  final String content;

  /// The height in pixels of the largest possible size an AnimatedContainer will be
  final double desiredMaxHeight;

  /// The height in pixels of the smallest possible size an AnimatedContainer will be
  final double desiredMinHeight;

  const ShowMore({
    Key key,
    @required this.content, 
    @required this.desiredMaxHeight, 
    @required this.desiredMinHeight}) : 
    assert(content != null),
    assert(desiredMaxHeight != null),
    assert(desiredMinHeight != null),
    super(key: key);

  @override
  ShowMoreState createState()=> ShowMoreState();
}

class ShowMoreState extends State<ShowMore>{

  _ontap update;
  ShowStatus showStatus;
  
  void _update(){
    setState((){
      showStatus = showStatus == ShowStatus.EXPANDED ? ShowStatus.UNEXPANDED : ShowStatus.EXPANDED;
      });
  }


  @override
  void initState(){
    super.initState();
    showStatus = ShowStatus.UNEXPANDED;
    update = _update;
  }

  @override
  Widget build(BuildContext context){

    return Column(
      children: <Widget>[

        AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          width: double.infinity,
          height: showStatus == ShowStatus.EXPANDED ? widget.desiredMaxHeight : widget.desiredMinHeight,
          child: Text(
            widget.content,
            softWrap: true,
            overflow: TextOverflow.fade,
            )
          ),

        GestureDetector(
          onTap: () async{
            update();
            },
          child: Container(
            width: double.infinity,
            height: 56.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showStatus == ShowStatus.EXPANDED ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
                showStatus == ShowStatus.EXPANDED ? Text("Show Less") : Text("Show More"),
              ]
              ) 
            )
          ),
      ]
      );
  }
}

/// Function that is called when updating a widget
typedef void _ontap();

enum ShowStatus {
  UNEXPANDED,
  EXPANDED,
}