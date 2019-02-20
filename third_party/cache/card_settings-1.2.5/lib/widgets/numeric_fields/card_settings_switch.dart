// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../../card_settings.dart';

/// This is a field that allows a boolean to be set via a switch widget.
class CardSettingsSwitch extends FormField<bool> {
  CardSettingsSwitch({
    Key key,
    String label: 'Label',
    TextAlign labelAlign,
    TextAlign contentAlign,
    Icon icon,
    Widget requiredIndicator,
    String trueLabel: 'Yes',
    String falseLabel: 'No',
    bool initialValue: false,
    bool autovalidate: false,
    bool visible: true,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    ValueChanged<bool> onChanged,
  }) : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            autovalidate: autovalidate,
            builder: (FormFieldState<bool> field) {
              final _CardSettingsSwitchState state = field;
              return CardSettingsField(
                label: label,
                labelAlign: labelAlign,
                visible: visible,
                icon: icon,
                requiredIndicator: requiredIndicator,
                errorText: field.errorText,
                content: Row(children: <Widget>[
                  Expanded(
                    child: Text(
                      state.value ? trueLabel : falseLabel,
                      style: Theme.of(field.context).textTheme.subhead,
                      textAlign: contentAlign ??
                          CardSettings.of(field.context).contentAlign,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(0.0),
                    child: Container(
                      height: 20.0,
                      child: Switch(
                        value: state.value,
                        onChanged: (value) {
                          state.didChange(value);
                          if (onChanged != null) onChanged(value);
                        },
                      ),
                    ),
                  ),
                ]),
              );
            });

  @override
  _CardSettingsSwitchState createState() => _CardSettingsSwitchState();
}

class _CardSettingsSwitchState extends FormFieldState<bool> {}
