import 'package:exwidgets/src/helper/msg.dart';
import 'package:flutter/material.dart';

class ValidationHandler {
  static showMessage(BuildContext context,String title,String message){
    Msg.info(context, "", message);
  }
}