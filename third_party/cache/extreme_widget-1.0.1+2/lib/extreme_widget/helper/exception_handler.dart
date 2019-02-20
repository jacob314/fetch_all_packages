import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/helper/nav.dart';

class ValidationHandler {
  static showMessage(BuildContext context,String title,String message){
    Msg.info(context, "", message);
  }
}