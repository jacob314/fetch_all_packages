# Usage

* No permissions are required for this plugin.
* Requires **iOS 9** or above

## Methods

``` dart
class NativeContactDialog {

  static Future<String> addContact(Contact contact)

}
```

## Example - Adding a contact
``` dart
// import package
import 'package:native_contact_dialog/native_contact_dialog.dart';

// create a contact
final contactToAdd = Contact(...args...);

// open the native add contact dialog
NativeContactDialog.addContact(contactToAdd).then((result) {
    // NOTE: The user could cancel the dialog, but not add
    // them to their addressbook. Whether or not the user decides
    // to add [contactToAdd] to their addressbook, you will end up
    // here.

    print('add contact dialog closed.')
}).catchError((error) {
    // FlutterError, most likely unsupported operating system.
    print('Error adding contact!');
});
```
