// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../../card_settings.dart';

/// This field allows a time to be selected.
class CardSettingsTimePicker extends FormField<TimeOfDay> {
  CardSettingsTimePicker({
    Key key,
    String label: 'Label',
    TextAlign labelAlign,
    TextAlign contentAlign,
    TimeOfDay initialValue,
    Icon icon,
    Widget requiredIndicator,
    bool autovalidate: false,
    bool visible: true,
    FormFieldSetter<TimeOfDay> onSaved,
    this.onChanged,
    FormFieldValidator<TimeOfDay> validator,
  }) : super(
            key: key,
            initialValue: initialValue ?? TimeOfDay.now(),
            onSaved: onSaved,
            validator: validator,
            autovalidate: autovalidate,
            builder: (FormFieldState<TimeOfDay> field) {
              final _CardSettingsTimePickerState state = field;
              return GestureDetector(
                onTap: () {
                  state._showDialog();
                },
                child: CardSettingsField(
                  label: label,
                  labelAlign: labelAlign,
                  visible: visible,
                  errorText: field.errorText,
                  icon: icon,
                  requiredIndicator: requiredIndicator,
                  content: Text(
                    state.value == null
                        ? ''
                        : state.value.format(field.context),
                    style: Theme.of(field.context).textTheme.subhead,
                    textAlign: contentAlign ??
                        CardSettings.of(field.context).contentAlign,
                  ),
                  pickerIcon: Icons.arrow_drop_down,
                ),
              );
            });

  final ValueChanged<TimeOfDay> onChanged;

  @override
  _CardSettingsTimePickerState createState() => _CardSettingsTimePickerState();
}

class _CardSettingsTimePickerState extends FormFieldState<TimeOfDay> {
  @override
  CardSettingsTimePicker get widget => super.widget as CardSettingsTimePicker;

  void _showDialog() {
    showTimePicker(
      context: context,
      initialTime: value,
    ).then((value) {
      if (value != null) {
        didChange(value);
        if (widget.onChanged != null) widget.onChanged(value);
      }
    });
  }
}
