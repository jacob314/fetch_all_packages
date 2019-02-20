import 'package:flutter/material.dart';
import 'package:flrouter/flrouter.dart';

void main() => runApp(MaterialApp(
  onGenerateRoute: Flrouter({
    '/accounts/{id}': (context, match) => Account(match.parameters['id']),
    '/': (context, match) => Index(),
  }).get,
));

class Account extends StatelessWidget {
  final String id;

  Account(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(this.id)));
  }
}

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Index')));
  }
}
