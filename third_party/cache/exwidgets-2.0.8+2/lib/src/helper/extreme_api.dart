import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtremeApi {
  static callPhone(BuildContext context, String phoneNumber) async {
    var url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static sendSms(BuildContext context, String phoneNumber) async {
    var url = 'sms:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static sendWhatsapp(BuildContext context, String phoneNumber) async {
    //var url = 'whatsapp://send?phone=$phoneNumber';
    var url = 'https://api.whatsapp.com/send?phone=$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static sendEmail(BuildContext context, String email,String subject, String body) async {
    var url = 'mailto:$email?subject=$subject=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
