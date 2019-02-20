import 'package:flutter/material.dart';
import 'package:generic_form_field/generic_dialog.dart';

class GenericFormField<T> extends FormField<T> {
  GenericFormField(
      {Key key,
      this.initialValue,
      this.searchCallback,
      this.decoration: const InputDecoration(),
      // FocusNode focusNode,
      @required this.dialogTitle,
      this.minimumLenghtRequired: 3,
      this.validator,
      this.onSaved,
      this.onChanged,
      TextEditingController controller})
      : //focusNode = focusNode ?? FocusNode(),
        controller =
            controller ?? TextEditingController(text: '${initialValue ?? ""}'),
        super(key: key, builder: (FormFieldState<T> field) {});

  final T initialValue;
  // final FocusNode focusNode;
  final String dialogTitle;
  final int minimumLenghtRequired;
  final TextEditingController controller;
  final InputDecoration decoration;
  final SearchCallback<T> searchCallback;
  final FormFieldValidator<T> validator;
  final FormFieldSetter<T> onSaved;
  final ValueChanged<T> onChanged;

  @override
  _GenericFormFieldState<T> createState() => _GenericFormFieldState<T>(this);
}

class _GenericFormFieldState<T> extends FormFieldState<T> {
  _GenericFormFieldState(this.parent);

  final GenericFormField<T> parent;

  @override
  void initState() {
    super.initState();
    _setValue(widget.initialValue);
  }

  void _search() {
    getDialog(context, parent.initialValue).then(_setValue);
  }

  void _setValue(T v) {
    setState(() {
      parent.controller.text = '${v ?? ""}';
      setValue(v);
      _valueChanged();
    });
  }

  void _clear() {
    setState(() {
      parent.controller.clear();
      setValue(null);
      _valueChanged();
    });
  }

  void _valueChanged() {
    if (parent.onChanged != null) return parent.onChanged(value);
  }

  Future<T> getDialog(BuildContext context, T initialValue) async {
    var v = await showGenericDialog(
      context: context,
      title: parent.dialogTitle,
      minimumLenghtRequired: parent.minimumLenghtRequired,
      searchCallback: parent.searchCallback,
    );
    return v;
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: FocusScopeNode(),
      child: TextFormField(
        controller: parent.controller,
        decoration: parent.decoration.copyWith(
          suffixIcon: parent.controller.text.isEmpty
              ? IconButton(
                  icon: Icon(Icons.find_in_page),
                  onPressed: _search,
                  tooltip: 'Buscar',
                )
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: _clear,
                  tooltip: 'Limpiar',
                ),
        ),
        validator: (s) {
          if (parent.validator != null) return parent.validator(value);
        },
        onSaved: (s) {
          if (parent.onSaved != null) return parent.onSaved(value);
        },
      ),
    );
  }
}
