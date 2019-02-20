import 'package:flutter/material.dart';

import 'package:flutter_lock_widget/circle.dart';
import 'package:flutter_lock_widget/lock_container.dart';

class LockConfirmPage extends StatefulWidget {

  final String password;

  LockConfirmPage({@required this.password});

  @override
  State<StatefulWidget> createState() {
    return _LockConfirmPageState();
  }
}

class _LockConfirmPageState extends State<LockConfirmPage> {

  LockState _lockState = LockState.normal;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('确认手势密码'),
      ),
      body: Column(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                margin: const EdgeInsets.only(top: 100.0),
                child: LockContainer(
                  initMessage: '请确认手势密码',
                  errorMessage: '两次输入的手势密码不同',
                  completeCallback: _checkPassword,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  bool _checkPassword(String password) {
    if (password != widget.password) {
      return false;
    }

    return true;
  }
}
