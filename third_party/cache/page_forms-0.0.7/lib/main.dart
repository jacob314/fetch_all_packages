
import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
import 'package:page_forms/page_forms.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  final _fullNameController = BehaviorSubject<String>(seedValue: 'John Doe');
  final _emailController = BehaviorSubject<String>();

  Stream<String> get fullNameStream => _fullNameController.stream;
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get dataStream => Observable.concat([
    Observable.just(''),
    Observable.combineLatest2(
      fullNameStream,
      emailStream,
      (fullName, email) => '$fullName <$email>',
    ),
  ]);
  Stream<PageFormStates> get stateStream => Observable.concat([
    Observable.just(PageFormStates.Disabled),
    Observable.combineLatest2(
      fullNameStream,
      emailStream,
      (fullName, email) => (fullName == null || email == null) ? PageFormStates.Disabled : PageFormStates.Enabled,
    ),
  ]);

  @override
  Widget build(BuildContext cxt) {
    return MaterialApp(
      home: PageForms<String>(
        data: PageFormData(
          startIndex: 0,
          dataStream: dataStream,
          stateStream: stateStream,
          onSubmit: (String author) {
            print('Author: $author');
            return Future.value(30);
          },
          onCancel: () {
            print('Cancelled');
          },
        ),
        pages: <PageField>[
          PageField(
            color: Colors.green,
            fieldStream: fullNameStream,
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  helperText: 'Enter your full name here',
                ),
              ),
            ),
          ),
          PageField(
            color: Colors.orange,
            fieldStream: emailStream,
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  helperText: 'Enter your email here',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}