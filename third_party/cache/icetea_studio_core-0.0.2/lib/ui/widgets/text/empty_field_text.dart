import 'package:flutter/material.dart';

class EmptyFieldText extends StatelessWidget {
  final String _label;

  EmptyFieldText(this._label);

  @override
  Widget build(BuildContext context) {
    return Text('$_label',
        style: TextStyle(
            color: Theme.of(context).hintColor,
            fontStyle: FontStyle.italic
        )
    );
  }
}
