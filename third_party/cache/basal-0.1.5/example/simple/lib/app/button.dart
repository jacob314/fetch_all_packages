import 'package:flutter/material.dart';

import 'package:basal/basal.dart';

import 'package:example_simple/models.dart';

class SetNameButton extends StatelessWidget {
  final String firstName;
  final String lastName;

  SetNameButton({Key key, this.firstName, this.lastName}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    Consumer(
      models: [User],
      builder: (context, models, [managers]) {
        final User user = models[0];
        final Manager<User> manager = managers[0];
        return RaisedButton(
          child: new Text(firstName),
          onPressed: () => manager.model = User(firstName, lastName),
        );
      },
    );
}
