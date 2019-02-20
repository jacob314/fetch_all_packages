# biometric

A new flutter plugin project.

Flutter Plugin for biometric authentication (android)

Supported
* Android

## Example

main.dart

```dart
import 'package:biometric_example/login.dart';
import 'package:biometric_example/page.dart';
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
      routes: <String, WidgetBuilder> {
        '/page': (BuildContext context) => new Page(),
      },
      home: Login(),
    );
  }
}
```

login.dart

```dart
import 'package:flutter/material.dart';

import 'package:biometric/biometric.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final Biometric biometric = Biometric();
  String _hintPass = "Password";
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _initializeBiometric();
    });
  }

  Future<void> _initializeBiometric() async {

    String errorMessage = "";
    String erroCode = "";
    bool authStatus = false;
    bool authAvailable;

    try {
      authAvailable = await biometric.biometricAvailable();
    } on PlatformException catch (e) {
      print(e);
    }

    if (authAvailable) {

      setState(() {
        _hintPass = "Password or Biometric";
      });

      try {
        authStatus = await biometric.biometricAuthenticate(keepAlive: true);
      } on PlatformException catch (e) {
        errorMessage = e.message.toString();
        errorCode = e.message.toString();
      }
      if (!mounted) return;

      if ( authStatus ) {
        Navigator.of(context).pushReplacementNamed("/page");
      } else {

        if ( errorCode != "BIO-CANCEL" && errorCode != "BIO-PROGRESS") {
          setState(() {
            _errorMessage = errorMessage;
            _initializeBiometric();
          });
        }
      }

    }

  }

  Future<void> _cancelAuthenticate() async {
    try {
      await biometric.biometricCancel();
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Pluggin'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              SizedBox(height: 16.0,),
              Text("Login", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

              SizedBox(height: 16.0,),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                maxLength: 14,
                keyboardType: TextInputType.emailAddress,
                validator: (text) {
                  if(text.isEmpty)
                    return "Email is required";
                },
              ),

              SizedBox(height: 16.0,),
              TextFormField(
                controller: _passController,
                decoration: InputDecoration(
                  hintText: _hintPass,
                ),
                obscureText: true,
                maxLength: 20,
                validator: (text) {
                  if(text.isEmpty)
                    return "Password is required";
                },
              ),

              SizedBox(height: 30.0,),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: Text("Login", style: TextStyle(fontSize: 18.0),),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: (){
                      _cancelAuthenticate();
                      Navigator.of(context).pushReplacementNamed("/page");
                    }
                ),
              ),


              SizedBox(height: 30.0,),
              Text(_errorMessage, style: TextStyle(color: Colors.red),),

            ],
          ),

        ),
      ),
    );;
  }
}
```

page.dart

```dart
import 'package:flutter/material.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Container(
          child: Text("Welcome"),
        ),
      ),
    );
  }
}
```

## Android Permission

Update your project's `AndroidManifest.xml` file to include the `USE_FINGERPRINT` permissions:

```xml
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

## Error Codes

List of possible errors during authentication. It can be manually replaced by local language if necessary.

errorCode | errorMessage
------------ | -------------
BIO-PROGRESS | Authentication already in progress
BIO-CANCEL | Authentication Cancelled
BIO-ERROR | Internal Error
BIO-ERROR | Phone not secured by PIN, pattern or password, or SIM is currently locked.
BIO-ERROR | No fingerprint enrolled on this device.
BIO-ERROR | Fingerprint is not available on this device.
BIO-ERROR | Generic Error
BIO-ERROR | "Error message return by device"

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
