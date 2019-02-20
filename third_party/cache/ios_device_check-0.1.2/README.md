# ios_device_check

A flutter plugin for iOS DeviceCheck.

## Installation

To use this plugin, add `ios_device_check` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Usage

```dart
bool isSupported = await IosDeviceCheck.isSupported
String token = await IosDeviceCheck.generateToken()
```

## Note

DeviceCheck API is only supported on iOS 11.0 or newer.

If the plugin is invoked on unsupported platform, it will throw error.
