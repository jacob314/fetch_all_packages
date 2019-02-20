import 'package:flutter/material.dart';

import 'package:basal/basal.dart';

import 'package:example_simple/models.dart';
import 'package:example_simple/app/app.dart' show App;

void main() => runApp(
  Provider(
    managers: <Manager>[
      Manager<User>(User('Initial', 'State'))
    ],
    child: () => App()
  )
);
