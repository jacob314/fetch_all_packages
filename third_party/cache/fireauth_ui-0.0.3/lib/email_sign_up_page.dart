import 'dart:async';

import 'package:fireauth_ui/dialog.dart';
import 'package:fireauth_ui/localizations.dart';
import 'package:fireauth_ui/password_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FireAuthEmailSignUpPage extends StatefulWidget {
  final String _email;

  FireAuthEmailSignUpPage(String email) : _email = email;

  @override
  State<StatefulWidget> createState() {
    return new FireAuthEmailSignUpPageState(_email);
  }
}

class FireAuthEmailSignUpPageState extends State<FireAuthEmailSignUpPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _email;
  String _displayName;
  String _password;
  bool _loading = false;
  FocusNode _displayNameFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();

  FireAuthEmailSignUpPageState(String email) : _email = email;

  String _validateEmail(String value) {
    if (value.isEmpty)
      return FireAuthUILocalizations.of(context).emptyEmailWarning;
    final RegExp nameExp =
        new RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
    if (!nameExp.hasMatch(value))
      return FireAuthUILocalizations.of(context).invalidEmailWarning;
    return null;
  }

  Future _onSignUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _loading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = _displayName;
        FirebaseAuth.instance.updateProfile(userUpdateInfo);
        int popCount = 4;
        Navigator.popUntil(context, (Route<dynamic> route) {
          popCount--;
          return popCount == 0;
        });
      } catch (e) {
        showErrorDialog(context:context, error: e);
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(FireAuthUILocalizations.of(context).signIn),
      ),
      body: new Stack(
        children: <Widget>[
          _loading ? new LinearProgressIndicator() : new Container(),
          new Form(
              key: _formKey,
              child: new SingleChildScrollView(
                  child: new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new TextFormField(
                      initialValue: _email,
                      decoration: new InputDecoration(
                        hintText: FireAuthUILocalizations.of(context).emailHint,
                        labelText: FireAuthUILocalizations.of(context).email,
                        filled: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String val) {
                        _email = val;
                      },
                      validator: _validateEmail,
                      enabled: !_loading,
                      onFieldSubmitted: (_) {
                        FocusScope
                            .of(context)
                            .requestFocus(_displayNameFocusNode);
                      },
                    ),
                    new SizedBox(
                      height: 24.0,
                    ),
                    new TextFormField(
                      focusNode: _displayNameFocusNode,
                      decoration: new InputDecoration(
                        hintText:
                            FireAuthUILocalizations.of(context).displayNameHint,
                        labelText:
                            FireAuthUILocalizations.of(context).displayName,
                        filled: true,
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (String val) {
                        _displayName = val;
                      },
                      enabled: !_loading,
                      onFieldSubmitted: (_) {
                        FocusScope
                            .of(context)
                            .requestFocus(_passwordFocusNode);
                      },
                    ),
                    new SizedBox(
                      height: 24.0,
                    ),
                    new FireAuthUIPasswordField(
                      labelText: FireAuthUILocalizations.of(context).password,
                      onSaved: (String val) {
                        _password = val;
                      },
                      enabled: !_loading,
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) {
                        _onSignUp();
                      },
                    ),
                    new RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: _loading ? null : _onSignUp,
                      child: new Text(
                        FireAuthUILocalizations.of(context).signUp,
                        style: Theme
                            .of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )))
        ],
      ),
    );
  }
}
