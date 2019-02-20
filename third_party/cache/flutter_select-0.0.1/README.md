# flutter_select

A Flutter package implements different kinds of select fields.

## Usage

To use this plugin, add `flutter_select` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
import 'flutter_select/flutter_select.dart';

// single select
SingleSelectFormField(
  controller: _singleSelectController,
  labelText: 'Single Select',
  validator: (value) {
    if (value.isEmpty) return 'Please select an option';
  },
  options: _options,
  onSaved: (Map<String, dynamic> value) => _data['singleSelect'] = value,
);

// date select
DateSelectFormField(
  controller: _dateController,
  labelText: 'Date',
  validator: (value) {
    if (value == null) return 'Please select a date';
  },
  onSaved: (DateTime value) => _data['date'] = value,
);

// time select
TimeSelectFormField(
  controller: _timeController,
  labelText: 'Time',
  validator: (value) {
    if (value == null) return 'Please select time';
  },
  onSaved: (TimeOfDay value) => _data['time'] = value,
);

// multiple select
MultipleSelectFormField(
  controller: _multipleSelectController,
  labelText: 'Multiple Select',
  validator: (value) {
    if (value.isEmpty) {
      return 'Please select at least one option';
    }
  },
  options: _options,
  onSaved: (List<Map<String, dynamic>> value) => _data['multipleSelect'] = value,
);
```
