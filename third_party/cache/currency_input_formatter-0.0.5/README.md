# currency_input_formatter

A custom Flutter TextInputFormatter for currency values.

![Demo](https://i.imgur.com/cLpO08U.gif)

## Usage

Initialize it in the `inputFormatters` parameter of a `TextField` or `TextFormField`.

Currently, there are two parameters:

`allowSubdivisions` - Whether or not to allow non-whole number values.  
`subdivisionMarker` - The string separator in between the whole number and subdivision parts of a currency value.

## Short Example

```dart
new TextField(
    autofocus: true,
    keyboardType: TextInputType.number,
    decoration: const InputDecoration(
        labelText: "Salary",
        prefixText: '\$',
    ),
    inputFormatters: <TextInputFormatter>[
      new CurrencyInputFormatter(
          allowSubdivisions: true,
          subdivisionMarker: "."
      ),
    ],
),
```
