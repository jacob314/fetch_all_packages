import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Nav {
  static Future open(BuildContext context, dynamic screen) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static void close(BuildContext context) {
    Navigator.pop(context);
  }
}

class Msg {
  static info(BuildContext context,String title, String message,{isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title,style: TextStyle(color: isSuccess? Colors.green : Colors.red),),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                child: Text("Okay !", style: TextStyle(color: Colors.blue),),
                // icon: Icon(Icons.),
                borderSide: BorderSide(color: Colors.blue),
                onPressed: () {
                  if(isSuccess){
                    Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  }
                  else{
                    Nav.close(context);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
