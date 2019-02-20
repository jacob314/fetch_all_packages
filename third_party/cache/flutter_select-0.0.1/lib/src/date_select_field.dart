import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateSelectingValue {
  DateTime selected;

  DateSelectingValue({selected}) {
    this.selected = selected ?? null;
  }

  static DateSelectingValue get empty => DateSelectingValue();

  DateSelectingValue copyWith({DateTime selected}) {
    return DateSelectingValue(
      selected: selected ?? this.selected,
    );
  }

  @override
  String toString() => '$runtimeType(selected: $hashCode)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (other is! DateSelectingValue)
      return false;
    final DateSelectingValue typedOther = other;
    return selected == null ? false
      : DateFormat('yyyy-MM-dd').format(typedOther.selected) ==
      DateFormat('yyyy-MM-dd').format(selected);
  }

  @override
  int get hashCode => selected.hashCode;
}

class DateSelectingController extends ValueNotifier<DateSelectingValue> {
  DateSelectingController({DateTime selected}) : super(
    selected == null ?
    DateSelectingValue.empty :
    DateSelectingValue(selected: selected)
  );

  DateSelectingController.fromValue(DateSelectingValue value)
    : super(value ?? DateSelectingValue.empty);

  DateTime get selected => value.selected;
  set selected(DateTime newItems) {
    value = value.copyWith(selected: newItems);
  }

  void clear() {
    value = DateSelectingValue.empty;
  }
}

class DateSelectField extends StatefulWidget {
  final Key fieldKey;
  final DateTime initialValue;
  final String hintText;
  final String labelText;
  final String helperText;
  final String errorText;
  final FormFieldSetter<DateTime> onChanged;
  final ValueChanged<DateTime> onSubmitted;
  final DateSelectingController controller;
  final bool enabled;

  const DateSelectField({
    this.fieldKey,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.enabled = true,
  });

  @override
  _DateSelectFieldState createState() => _DateSelectFieldState();
}

abstract class _SingleSelectFieldState extends State<DateSelectField> {
  Text subtitle;

  void openPicker();

  Text getSubtitle() {
    if (widget.controller.selected == null) {
      return Text(
        widget.hintText ?? 'Please select...',
        style: TextStyle(fontSize: 14.0, color: Colors.grey),
      );
    }
    return Text(
      DateFormat('yyyy-MM-dd').format(widget.controller.selected),
      style: TextStyle(fontSize: 14.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 80.0,
          decoration: BoxDecoration(
            border: widget.errorText == null ? null : Border.all(
              width: 2.0,
              color: Theme.of(context).errorColor,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: openPicker,
            child: Card(
              margin: EdgeInsets.all(0.0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.labelText,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: subtitle ?? getSubtitle(),
                        )
                      ],
                    ),
                    Icon(Icons.chevron_right),
                  ],
                )
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0, top: 5.0),
          child: Text(
            widget.errorText ?? '',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _DateSelectFieldState extends _SingleSelectFieldState {

  @override
  Future<void> openPicker() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.initialValue ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null) {
      widget.controller.selected = picked;
      setState(() {
        subtitle = getSubtitle();
      });
    }
  }
}

class DateSelectFormField extends FormField<DateTime> {
  final DateSelectingController controller;

  DateSelectFormField({
    Key key,
    this.controller,
    DateTime initialValue,
    String hintText,
    String labelText,
    String helperText,
    ValueChanged<DateTime> onFieldSubmitted,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    bool enabled,
  }) :
      assert(initialValue == null || controller == null),
      super(
      key: key,
      initialValue: getInitialValue(controller, initialValue),
      onSaved: onSaved,
      validator: validator,
      builder: (FormFieldState<DateTime> field) {
        final _DateSelectFormFieldState state = field;
        return DateSelectField(
          controller: state._effectiveController,
          initialValue: getInitialValue(controller, initialValue),
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          errorText: field.errorText,
          onChanged: field.didChange,
          onSubmitted: onFieldSubmitted,
          enabled: enabled,
        );
      },
    );

  static DateTime getInitialValue(
    DateSelectingController controller,
    DateTime initialValue,
    ) {
    return controller != null ?
    controller.selected : (initialValue ?? DateSelectingValue.empty.selected);
  }

  @override
  _DateSelectFormFieldState createState() => _DateSelectFormFieldState();
}

class _DateSelectFormFieldState
  extends FormFieldState<DateTime> {
  DateSelectingController _controller;

  DateSelectingController get _effectiveController =>
    widget.controller ?? _controller;

  @override
  DateSelectFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = DateSelectingController(selected: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(DateSelectFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = DateSelectingController.fromValue(
          oldWidget.controller.value,
        );
      if (widget.controller != null) {
        setValue(widget.controller.selected);
        if (oldWidget.controller == null)
          _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.selected = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController.selected != value)
      didChange(_effectiveController.selected);
  }
}
