import 'package:flutter/material.dart';

class SectionExpandToggle extends StatefulWidget {
  final String label;
  final String activeLabel;
  final VoidCallback onTap;
  final bool isActive;

  SectionExpandToggle({Key key, this.label, this.activeLabel, this.onTap, this.isActive}):super(key: key);

  @override
  _SectionExpandToggleState createState() => _SectionExpandToggleState(label, activeLabel, onTap, isActive);
}

class _SectionExpandToggleState extends State<SectionExpandToggle>{
  String label;
  String activeLabel;
  VoidCallback onTap;
  bool _isActive;

  _SectionExpandToggleState(this.label, this.activeLabel, this.onTap, this._isActive);

  void _toggleContent(){
    setState(() {
      _isActive = !_isActive;

      if(onTap != null){
        onTap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10.0),
        child: GestureDetector(
          child: Icon(
            !_isActive?Icons.expand_more:Icons.expand_less,
            color: Theme.of(context).unselectedWidgetColor,

            size: 28.0,
          ),
          onTap:() => _toggleContent(),
        )
    );
  }
}
