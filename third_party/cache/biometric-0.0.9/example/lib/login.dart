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
	String errorCode = "";
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
		errorCode = e.code.toString();
      }
      if (!mounted) return;

      if ( authStatus ) {
        Navigator.of(context).pushReplacementNamed("/page");
      } else {

        if ( errorCode != "BIO-CANCEL" && errorCode != "BIO-PROGRESS" ) {
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
