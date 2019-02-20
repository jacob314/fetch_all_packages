import 'package:flutter/material.dart';
import '../models/album.dart';
import '../models/user.dart';
import '../pages/photos_album.dart';
import '../pages/posts_user.dart';
import '../routes.dart';
import 'package:generic_form_field/generic_form_field.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  User _user;
  Album _album;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<List<User>> _find(String text) async => await Routes.users();
  Future<List<Album>> _albums(String text) async => await Routes.albums(_user);

  bool _isValid() {
    bool result = _key.currentState.validate();
    if (result) _key.currentState.save();
    return result;
  }

  Widget _buttons(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.primaryColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            color: theme.primaryColor,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Posts',
                style: theme.textTheme.button
                    .copyWith(color: theme.dialogBackgroundColor),
              ),
            ),
            onPressed: () {
              if (_isValid())
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Posts(user: _user)));
            },
          ),
          RaisedButton(
            color: theme.primaryColor,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Photos',
                style: theme.textTheme.button
                    .copyWith(color: theme.dialogBackgroundColor),
              ),
            ),
            onPressed: () {
              if (_isValid())
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Photos(album: _album)));
            },
          )
        ],
      ),
    );
  }

  Widget _form() {
    ThemeData theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: theme.primaryColor),
            child: Text(
              'Form',
              style: theme.textTheme.button
                  .copyWith(color: theme.dialogBackgroundColor),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _key,
              child: Column(
                children: <Widget>[
                  GenericFormField<User>(
                    minimumLenghtRequired: 0,
                    dialogTitle: 'User',
                    decoration: InputDecoration(labelText: 'User'),
                    searchCallback: _find,
                    initialValue: _user,
                    validator: (u) => u == null ? 'Must select a user' : null,
                    onSaved: (u) => setState(() => _user = u),
                  ),
                  GenericFormField<Album>(
                    minimumLenghtRequired: 0,
                    dialogTitle: 'Album',
                    decoration: InputDecoration(labelText: 'Album'),
                    searchCallback: _albums,
                    initialValue: _album,
                    validator: (a) => a == null ? 'Must select a album' : null,
                    onSaved: (a) => setState(() => _album = a),
                  )
                ],
              ),
            ),
          ),
          _buttons(theme),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_form()],
      ),
    );
  }
}
