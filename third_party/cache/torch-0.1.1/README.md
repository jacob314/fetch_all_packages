# torch

A Flutter plugin to access the device's torch on Android and iOS.

## Usage
To use this plugin, add `torch` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

For android, add the following to your manifest

## Example
``` dart
// Import package
import 'package:torch/torch.dart';

// Turn the torch on:
Torch.turnOn();

// Turn the torch off:
Torch.turnOff();

// Make a flash:
Torch.flash(Duration(milliseconds: 300));

// Check if the device has torch:
bool hasTorch = await Torch.hasTorch;

```