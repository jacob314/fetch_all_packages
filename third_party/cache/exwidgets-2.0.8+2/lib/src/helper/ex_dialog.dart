import 'package:flutter/material.dart';

class ExDialog {
  static String dialogResult = "";
  static Future showConfirm(BuildContext context,String title,String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return;
          },
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  dialogResult = "close";
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Ya",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  dialogResult = "yes";
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
