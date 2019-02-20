import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/colors.dart';

class CustomTextInput extends StatefulWidget {
  const CustomTextInput(
      {this.fieldKey,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldSubmitted,
      this.maxLength,
      this.maxLine,
      this.focusNode,
      this.textInputAction,
      this.textInputType,
      this.controller});

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final int maxLength;
  final int maxLine;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;

  @override
  _InputFieldViewState createState() => _InputFieldViewState();
}

class _InputFieldViewState extends State<CustomTextInput> {

  GlobalKey<FormFieldState> _key;
  FocusNode _focusNode;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _key = widget.fieldKey ?? new GlobalKey();
    _focusNode = widget.focusNode ?? new FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _isValid = _checkFieldValid();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new TextFormField(
        key: _key,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        focusNode: _focusNode,
        onSaved: widget.onSaved,
        keyboardType: widget.textInputType?? TextInputType.text,
        maxLength: widget.maxLength ?? 10,
        validator: widget.validator,
        maxLines: widget.maxLine ?? 1,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: _onEditingComplete,
        controller: widget.controller,
        decoration: new InputDecoration(
          filled: false,
          hintText: widget.hintText,
          labelText: widget.labelText,
          helperText: widget.helperText,
          contentPadding: new EdgeInsets.all(12.0),
        ),
        style: TextStyle(
          color: (TextInputType.text != null) ? Theme.of(context).primaryColor: kColorGray,
        ),
    );
  }

  bool _checkFieldValid() {
    String value = _key?.currentState?.value;
    if (value == null && widget.controller != null) {
      value = widget.controller.text;
    }

    if (widget.validator != null && value != null) {
      return widget.validator(value) == null;
    }
    return value != null && value.isNotEmpty;
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus == false) {
      setState(() {
        _isValid = _checkFieldValid();
      });
    }
  }

  void _onEditingComplete() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    setState(() {
      _isValid = _checkFieldValid();
    });
  }
}
