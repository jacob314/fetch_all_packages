# tinycolor
> TinyColor is a small library for  Flutter color manipulation and conversion

A port of [tinycolor2](https://github.com/bgrins/TinyColor) by [Brian Grinstead](https://github.com/bgrins)

## Getting Started

A tinycolor receives a `Color` as parameter.

```dart
import 'package:tinycolor/tinycolor.dart';

final TinyColor = TinyColor(Colors.green);
```

### From a Hex String

The package uses [Pigment](https://pub.dartlang.org/packages/pigment) by [Bregy Malpartida Ramos](https://github.com/bregydoc/) to convert strings to `Color`

````dart
TinyColor.fromString('#FE5567';
````

### From RGB int values

````dart
TinyColor.fromRGB(r: 255, g: 255, b:255);
````

### From HSL color

```dart
HslColor color = HslColor(h: 250, s: 57, l: 30);
TinyColor.fromHSL(color);
```

### From HSV color

```dart
HSVColor color = HSVColor(h: 250, s: 57, v: 30);
TinyColor.fromHSV(color);
```

## Properties

### color

Returns de flutter `Color` after operations 

```dart
final Color color = TinyColor(Colors.white).color;
```

## Methods

### getBrightness

Returns the perceived brightness of a color, from `0-255`, as defined by [Web Content Accessibility Guidelines (Version 1.0)](http://www.w3.org/TR/AERT#color-contrast).

```dart
TinyColor.fromString("#ffffff").getBrightness(); // 255
TinyColor.fromString("#000000").getBrightness(); // 0
```

### isLight

Return a boolean indicating whether the color's perceived brightness is light.

```dart
TinyColor.fromString("#ffffff").isLight(); // true
TinyColor.fromString("#000000").isLight(); // false
```

### isDark

Return a boolean indicating whether the color's perceived brightness is dark.

```dart
TinyColor.fromString("#ffffff").isDark(); // false
TinyColor.fromString("#000000").isDark(); // true
```

### getLuminance

Return the perceived luminance of a color, a shorthand for flutter `Color.computeLuminance`

```dart
TinyColor.fromString("#ffffff").getLuminance();
```

### setAlpha

Sets the alpha value on the current color.

```dart
final color = TinyColor(Colors.red).setAlpha(10);
```

### setOpacity

Sets the opacity value on the current color.

```dart
final color = TinyColor(Colors.red).setOpacity(0.5);
```

## Color Modification

These methods manipulate the current color, and return it for chaining. For instance:

```dart
TinyColor(Colors.red).lighten().desaturate().color;
```

### lighten

`lighten: function(amount = 10) -> TinyColor`. Lighten the color a given amount, from 0 to 100. Providing 100 will always return white.

```dart
TinyColor(Colors.red).lighten().color;
TinyColor(Colors.red).lighten(100).color;
```

### brighten

`brighten: function(amount = 10) -> TinyColor`. Brighten the color a given amount, from 0 to 100.

```dart
TinyColor(Colors.white).brighten().color;'
```

### darken

`darken: function(amount = 10) -> TinyColor`. Darken the color a given amount, from 0 to 100. Providing 100 will always return black.

```dart
TinyColor(Colors.red).darken().color;
TinyColor(Colors.red).darken(100).color;
```

### tint

Mix the color with pure white, from 0 to 100. Providing 0 will do nothing, providing 100 will always return white.

```dart
TinyColor(Color.red).tint().color;
TinyColor(Color.red).tint(100).color;
```

### shade

Mix the color with pure black, from 0 to 100. Providing 0 will do nothing, providing 100 will always return black.

```dart
TinyColor(Colors.red).shade().color;
TinyColor(Colors.red).shade(100).color;
```

### desaturate

`desaturate: function(amount = 10) -> TinyColor`. Desaturate the color a given amount, from 0 to 100. Providing 100 will is the same as calling `greyscale`.

```dart
TinyColor(Colors.red).desaturate().color;
TinyColor(Colors.red).desaturate(100).color;
```

### saturate

`saturate: function(amount = 10) -> TinyColor`. Saturate the color a given amount, from 0 to 100.

```dart
TinyColor(Colors.red).saturate().color;
```

### greyscale

`greyscale: function() -> TinyColor`. Completely desaturates a color into greyscale. Same as calling `desaturate(100)`.

```dart
TinyColor(Colors.red).greyscale().color;"
```

### spin

`spin: function(amount = 0) -> TinyColor`. Spin the hue a given amount, from -360 to 360. Calling with 0, 360, or -360 will do nothing (since it sets the hue back to what it was before).

```dart
TinyColor(Colors.red).spin(180).color;

// spin(0) and spin(360) do nothing
TinyColor(Colors.red).spin(0).color;
TinyColor(Colors.red).spin(360).color;
```

## Common operations

### clone

`clone: function() -> TinyColor`.
Instantiate a new TinyColor object with the same color. Any changes to the new one won't affect the old one.

```dart
final color1 = new TinyColor(Colors.red);
final color2 = color1.clone();
color2.setAlpha(20);
```