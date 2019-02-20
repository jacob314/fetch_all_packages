import 'dart:typed_data';

import 'dart:async';
import 'package:native_contact_dialog/native_contact_dialog.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Contacts View Plugin Example App'),
        ),
        body: Column(
          children: [
            ContactButton(),
          ]
        ),
      ),
    );
  }
}

final imageDataController = StreamController<Uint8List>();
Stream<Uint8List> get outImageData => imageDataController.stream;
Sink<Uint8List> get inImageData => imageDataController.sink;

class ContactButton extends StatelessWidget {

  Future<Null> _getImageUInt8List() async {
    // TODO: Find a way to convert a network image to a Uint8List for ios and android
    // With the current implementation, the image can  be shown when adding a contact in ios; however,
    // that image will somehow cause the contact to not be added to the address book when pressing 'Done'
    final image = NetworkImage("https://ui-avatars.com/api/?name=Andrew+Fulton");
    image.obtainKey(ImageConfiguration()).then((obtainedKey) {
      final loadedImage = image.load(obtainedKey);
      loadedImage.addListener((listener, error) {
          listener.image.toByteData().then((imageData) {
              final imageDataList = imageData.buffer.asUint8List();
              inImageData.add(imageDataList);
          });
      });
    });

    return null;
  }

  @override
  StatelessElement createElement() {
    _getImageUInt8List();
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: outImageData,
      builder: (context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.hasData) {
          return FlatButton.icon(
            icon: Icon(Icons.person_add, color: Colors.white,),
            color: Colors.black87,
            textColor: Colors.white,
            label: Text("Add to contacts"),
            onPressed: () {
              debugPrint("Pressed add to contacts!");
                NativeContactDialog.addContact(Contact(
                  company: "The Testing Company",
                  familyName: "Testers",
                  givenName: "Test",
                  prefix: "Mr",
                  jobTitle: "Tester",
                  middleName: "Is",
                  avatar: snapshot.data,
                  phones: [
                    Item(label: 'Mobile', value: '999999999')
                  ],
                  emails: [
                    Item(label: 'School', value: 'email@email.com')
                  ]
                ));
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

}