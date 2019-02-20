# Permissions (Don't use this plugin, it doesn't work on iOS)

A flutter plugin for checking and requesting permissions on iOS and Android.
This plugin is basically the same plugin as Vladimir Mbassi's Simple Permissions Plugin.
The only difference between his plugin and mine is that mine will run on iOS 8 and above.
The contacts permission only works on iOS 9 and above.
## Getting Started

Make sure you add the needed permissions to your Android Manifest  [Permission](https://developer.android.com/reference/android/Manifest.permission.html)
and Info.plist.

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## API
### List of currently available permissions

```dart
enum Permission {
  // Microphone
  RecordAudio,

  // Camera
  Camera,

  // Read External Storage (Android)
  ReadExternalStorage

  // Write External Storage (Android)
  WriteExternalStorage,

  // Access Coarse Location (Android) / When In Use iOS
  AccessCoarseLocation,

  // Access Fine Location (Android) / When In Use iOS
  AccessFineLocation,

  // Access Fine Location (Android) / When In Use iOS
  WhenInUseLocation,

  // Access Fine Location (Android) / Always Location iOS
  AlwaysLocation

  // Write contacts (Android) / Contacts iOS
  WriteContacts

  // Read contacts (Android) / Contacts iOS
  ReadContacts
}
```

```dart
/// Permissions status enum (iOS)
enum PermissionStatus { notDetermined, restricted, denied, authorized }
```

### Methods
```dart
  /// Check a [permission] and return a [Future] with the result
  static Future<bool> checkPermission(Permission permission);

  /// Request a [permission] and return a [Future] with the result
  static Future<bool> requestPermission(Permission permission);

  /// Open app settings on Android and iOS
  static Future<bool> openSettings();
  
  /// Get iOs permission status 
  static Future<PermissionStatus> getPermissionStatus(Permission permission)
```