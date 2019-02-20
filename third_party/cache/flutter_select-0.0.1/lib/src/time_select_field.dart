import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimeSelectingValue {
  TimeOfDay selected;

  TimeSelectingValue({selected}) {
    this.selected = selected ?? null;
  }

  static TimeSelectingValue get empty => TimeSelectingValue();

  TimeSelectingValue copyWith({TimeOfDay selected}) {
    return TimeSelectingValue(
      selected: selected ?? this.selected,
    );
  }

  @override
  String toString() => '$runtimeType(selected: $hashCode)';

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other))
      return true;
    if (other is! TimeSelectingValue)
      return false;
    final TimeSelectingValue typedOther = other;
    return selected == typedOther.selected;
  }

  @override
  int get hashCode => selected.hashCode;
}

class TimeSelectingController extends ValueNotifier<TimeSelectingValue> {
  TimeSelectingController({TimeOfDay selected}) : super(
    selected == null ?
    TimeSelectingValue.empty :
    TimeSelectingValue(selected: selected)
  );

  TimeSelectingController.fromValue(TimeSelectingValue value)
    : super(value ?? TimeSelectingValue.empty);

  TimeOfDay get selected => value.selected;
  set selected(TimeOfDay newItems) {
    value = value.copyWith(selected: newItems);
  }

  void clear() {
    value = TimeSelectingValue.empty;
  }
}

class TimeSelectField extends StatefulWidget {
  final Key fieldKey;
  final TimeOfDay initialValue;
  final String hintText;
  final String labelText;
  final String helperText;
  final String errorText;
  final FormFieldSetter<TimeOfDay> onChanged;
  final ValueChanged<TimeOfDay> onSubmitted;
  final TimeSelectingController controller;
  final bool enabled;

  const TimeSelectField({
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
  _TimeSelectFieldState createState() => _TimeSelectFieldState();
}

abstract class _SingleSelectFieldState extends State<TimeSelectField> {
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
      widget.controller.selected.format(context),
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

class _TimeSelectFieldState extends _SingleSelectFieldState {

  @override
  Future<void> openPicker() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: widget.initialValue ?? TimeOfDay.now(),
    );
    if (picked != null) {
      widget.controller.selected = picked;
      setState(() {
        subtitle = getSubtitle();
      });
    }
  }
}

class TimeSelectFormField extends FormField<TimeOfDay> {
  final TimeSelectingController controller;

  TimeSelectFormField({
    Key key,
    this.controller,
    TimeOfDay initialValue,
    String hintText,
    String labelText,
    String helperText,
    ValueChanged<TimeOfDay> onFieldSubmitted,
    FormFieldSetter<TimeOfDay> onSaved,
    FormFieldValidator<TimeOfDay> validator,
    bool enabled,
  }) :
      assert(initialValue == null || controller == null),
      super(
      key: key,
      initialValue: getInitialValue(controller, initialValue),
      onSaved: onSaved,
      validator: validator,
      builder: (FormFieldState<TimeOfDay> field) {
        final _TimeSelectFormFieldState state = field;
        return TimeSelectField(
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

  static TimeOfDay getInitialValue(
    TimeSelectingController controller,
    TimeOfDay initialValue,
    ) {
    return controller != null ?
    controller.selected : (initialValue ?? TimeSelectingValue.empty.selected);
  }

  @override
  _TimeSelectFormFieldState createState() => _TimeSelectFormFieldState();
}

class _TimeSelectFormFieldState
  extends FormFieldState<TimeOfDay> {
  TimeSelectingController _controller;

  TimeSelectingController get _effectiveController =>
    widget.controller ?? _controller;

  @override
  TimeSelectFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TimeSelectingController(selected: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TimeSelectFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = TimeSelectingController.fromValue(
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
