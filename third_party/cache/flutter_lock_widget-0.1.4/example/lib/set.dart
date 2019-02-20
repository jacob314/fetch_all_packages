import 'package:flutter/material.dart';

import 'package:flutter_lock_widget/lock_container.dart';
import 'package:flutter_lock_widget/circle.dart';

import './confirm.dart';

class LockSetPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LockSetPageState();
  }
}

class _LockSetPageState extends State<LockSetPage> {

  LockState _lockState = LockState.normal;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置手势密码'),
      ),
      body: Column(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                // color: Colors.red,
                margin: const EdgeInsets.only(top: 100.0),
                child: LockContainer(
                  initMessage: '请设置手势密码',
                  errorMessage: '手势密码最少 4 位',
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

    if (password.length < 4) {
      return false;
    }

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => LockConfirmPage(password: password,)
    ));

    return true;
  }
}
