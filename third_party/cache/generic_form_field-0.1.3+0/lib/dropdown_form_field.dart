import 'package:flutter/material.dart';

class DropdownFormField<T> extends FormField<T> {
  DropdownFormField(
      {String labelText,
      FormFieldSetter<T> onSaved,
      ValueChanged<T> onChanged,
      FormFieldValidator<T> validator,
      bool autovalidate: false,
      bool enabled: true,
      @required List<T> items,
      @required ValueNotifier<T> valueListenable})
      : assert(items != null),
        assert(valueListenable != null),
        super(
          builder: (FormFieldState<T> state) {
            return ValueListenableBuilder<T>(
              builder: (BuildContext _, T v, Widget w) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: labelText,
                    errorText: state.hasError ? state.errorText : null,
                  ),
                  isEmpty: valueListenable.value == null,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: valueListenable.value,
                      isDense: true,
                      onChanged: (t) {
                        valueListenable.value = t;
                        state.didChange(t);
                        if (onChanged != null) onChanged(t);
                      },
                      items: items
                          .map(
                            (t) => DropdownMenuItem<T>(
                                  value: t,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('$t'),
                                  ),
                                ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
              valueListenable: valueListenable,
            );
          },
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          enabled: enabled,
        );
}
