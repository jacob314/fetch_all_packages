import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/theme.dart';

class FieldTextSpan extends TextSpan{
  @override
  final String text;

  @override
  final TextStyle style;

  FieldTextSpan({this.text, this.style}):super(
      text: text,
      style: TextStyle(
          color: buildAppTheme().textTheme.title.color,
          fontWeight: FontWeight.bold
      )
  );



//  String _text;
//  String get text => text;

  /*EmptyFieldText(this._label);

  @override
  Widget build(BuildContext context) {
    return Text('$_label',
        style: TextStyle(
            color: Theme.of(context).hintColor,
            fontStyle: FontStyle.italic
        )
    );
  }*/
}
