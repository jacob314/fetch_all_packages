import 'package:flutter/material.dart';
import 'dart:async';

import './lock_widget.dart';
import './circle.dart';

class LockContainer extends StatefulWidget {
  final String message;
  final LockState state;
  final CircleAttribute attribute;
  final LockCompleteCallback completeCallback;

  LockContainer(
      {this.message: '',
      this.state: LockState.normal,
      this.attribute: CircleAttribute.normalAttribute,
      this.completeCallback: null});

  @override
  State<StatefulWidget> createState() {
    return _LockContainerState();
  }
}

class _LockContainerState extends State<LockContainer> {

  Color _messageColor = Colors.black;

  LockState _lockState = LockState.normal;

  Timer _timer;

  @override
  void initState() {
    super.initState();

    _lockState = widget.state;
  }

  @override
  Widget build(BuildContext context) {

    String message = widget.message;
    Color messageColor = widget.state == LockState.normal ? Colors.black : Colors.red;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
            child: Text(
          message,
          style: TextStyle(color: messageColor),
        )),
        SizedBox(
          height: 20.0,
        ),
        LockWidget(
          lockState: _lockState,
          attribute: widget.attribute,
          completeCallback: (String password) {
            if (widget.completeCallback != null) {
              setState(() {
                bool success = widget.completeCallback(password);

                if (success) {
                  _lockState = LockState.normal;
                } else {
                  _lockState = LockState.error;
                  _timer = Timer(Duration(seconds: 2), _handleTimer);
                }
              });
            }
          },
        )
      ],
    );
  }

  void _handleTimer() {
    setState(() {
      _lockState = LockState.normal;

      _timer.cancel();
      _timer = null;
    });
  }
}
