import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/helper/input.dart';

class ExDropDown extends StatefulWidget {
  final String id;
  final String hintText;
  final Color colorText;
  final double sizeText;
  final FontWeight weightText;
  
  final IconData iconName;
  final Color iconColor;
  final String value;
  final bool enabled;
  final TextInputType keyboardType;
  final String onChangeTextId;

  final List<String> options;

  final bool useOutlineBorder;
  final bool autoSelectText;
  final bool usePasswordMask;

  ExDropDown({
    Key key,
    @required this.id,
    @required this.hintText,
    @required this.options,
    this.colorText:Colors.black,
    this.sizeText:16.0,
    this.weightText,
    this.iconName,
    this.iconColor:Colors.black54,
    this.value: "",
    this.enabled,
    this.keyboardType: TextInputType.text,
    this.onChangeTextId,
    this.useOutlineBorder = false,
    this.autoSelectText = false,
    this.usePasswordMask = false,
  }) : super(key: key);

  @override
  StandartDropdownWidget createState() => StandartDropdownWidget();
}

class StandartDropdownWidget extends State<ExDropDown> {

  String dropDownValue;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      Input.setValue(widget.id, widget.value);
    } 
  }

  @override
  Widget build(BuildContext context) {
    if (Input.getValue(widget.id) != null) {
      for (int i = 0; i < widget.options.length; i++) {
        if (widget.options[i] == Input.getValue(widget.id)) {
          dropDownValue = Input.getValue(widget.id);
          break;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10 ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(widget.iconName, color: widget.iconColor,),
          ),
          Container(
            // width: 300,
            child: DropdownButton<String>(
              // isExpanded: true,
              style: TextStyle(color: widget.colorText ,fontSize: widget.sizeText,fontWeight: widget.weightText),
              hint: Text(widget.hintText),
              items: widget.options.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: new Text(val),
                        );
                      }).toList(),
              value: dropDownValue,
              onChanged: (String value) {
                setState(() {
                  if (value != null) {
                    // print("You Selected $value");
                    dropDownValue = value;
                    Input.setValue(widget.id, value);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
