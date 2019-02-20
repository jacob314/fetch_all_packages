import 'package:flutter/material.dart';

import 'package:basal/basal.dart';

import 'package:example_simple/models.dart';

class NameLabel extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
    Consumer(
      models: [User],
      builder: (context, models, [manager]) {
        /// Currently throws on startup because the app tries to render before
        /// before the streams are initialized.
        final User user = models[0];

        return Text('Name: ${user.firstName} ${user.lastName}');
      },
    );
}
