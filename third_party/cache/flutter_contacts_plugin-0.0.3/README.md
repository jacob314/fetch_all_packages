# flutter_contacts_plugin

A Flutter plugin to retrieve and manage contacts on Android and iOS devices.

## Usage

To use this plugin, add `flutter_contacts_plugin` as a [dependency in your `pubspec.yaml` file](https://flutter.io/platform-plugins/).

Make sure you add the following permissions to your Android Manifest:

```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
```

On iOS, make sure to set `NSContactsUsageDescription` in the `Info.plist` file

```xml
<key>NSContactsUsageDescription</key>
<string>This app requires contacts access to function properly.</string>
```

## Example

``` dart
// Import package
import 'package:flutter_contacts_plugin/flutter_contacts_plugin.dart';

// Get all contacts
Iterable<Contact> contacts = await FlutterContactsPlugin.getContacts();

// Get contacts matching a string
Iterable<Contact> johns = await FlutterContactsPlugin.getContacts(query : "john");

// Add a contact
// The contact must have a firstName / lastName to be successfully added
await FlutterContactsPlugin.addContact(newContact);

//Delete a contact
await FlutterContactsPlugin.deleteContact(contact);


