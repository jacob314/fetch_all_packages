import 'package:flutter/material.dart';

/// Primary password text form
///
/// Uses the theme_primary theme
class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.controller});

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FocusNode focusNode;
  final TextInputAction  textInputAction;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;

  @override
  _PasswordFieldViewState createState() => _PasswordFieldViewState();
}

class _PasswordFieldViewState extends State<PasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
        key: widget.fieldKey,
        obscureText: _obscureText,
        onSaved: widget.onSaved,
        maxLength: 15,
        focusNode: widget.focusNode,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
            ),
            labelStyle: new TextStyle(
                fontSize: 14.0
            ),
            filled: false,
            hintText: widget.hintText,
            labelText: widget.labelText,
            helperText: widget.helperText,
            contentPadding: new EdgeInsets.all(12.0),
            suffixIcon: new GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: new Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryIconTheme.color,
                  size: 20.0,
                )
            )));
  }
}
