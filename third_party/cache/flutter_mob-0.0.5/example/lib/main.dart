import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_mob/flutter_mob.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var phone = '', code = '';
  var wechat = HashMap<String, Object>();
  var wechatMoments = HashMap<String, Object>();
  var qq = HashMap<String, Object>();
  var sina = HashMap<String, Object>();

  void initState() {
    super.initState();
    wechat["Id"] = "1";
    wechat["SortId"] = "1";
    wechat["AppId"] = "wx3d5ef1595c9625b6";
    wechat["AppSecret"] = "aa92102390fff4576812bb9bfb447525";
    wechat["BypassApproval"] = "false";
    wechat["Enable"] = "true";

    wechatMoments["Id"] = "2";
    wechatMoments["SortId"] = "2";
    wechatMoments["AppId"] = "wx3d5ef1595c9625b6";
    wechatMoments["AppSecret"] = "aa92102390fff4576812bb9bfb447525";
    wechatMoments["BypassApproval"] = "false";
    wechatMoments["Enable"] = "true";

    qq["Id"] = "3";
    qq["SortId"] = "3";
    qq["AppId"] = "1108090420";
    qq["AppSecret"] = "VsvYgXoIfsRdJOQ7";
    qq["ShareByAppClient"] = "true";
    qq["Enable"] = "true";

    sina["Id"] = "4";
    sina["SortId"] = "4";
    sina["AppKey"] = "1597528454";
    sina["AppSecret"] = "0a2f5f06569c2f0e10f1308162724569";
    sina["RedirectUrl"] = "http://www.sina.com.cn";
    sina["ShareByAppClient"] = "true";
    sina["Enable"] = "true";
  }

  @override
  Widget build(BuildContext context) {
    FlutterMob.init("299a1a3ee5b34", "ca063d7be8d7a80004ab353c50982f4b");
    FlutterMob.config(wechat:wechat, wechatMoments:wechatMoments, qq:qq, sina:sina);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onChanged: (v) {
                  phone = v;
                },
              ),
            ),
            MaterialButton(
              onPressed: getCode,
              color: Colors.blueAccent,
              child: Text('getCode'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: TextField(
                decoration: InputDecoration(labelText: 'Code'),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  code = v;
                },
              ),
            ),
            MaterialButton(
              onPressed: submitCode,
              color: Colors.blueAccent,
              child: Text('submitCode'),
            ),
            MaterialButton(
              onPressed: qqLogin,
              color: Colors.blueAccent,
              child: Text('QQLogin'),
            ),
            MaterialButton(
              onPressed: wechatLogin,
              color: Colors.blueAccent,
              child: Text('WechatLogin'),
            ),
            MaterialButton(
              onPressed: sinaLogin,
              color: Colors.blueAccent,
              child: Text('SinaLogin'),
            ),
            MaterialButton(
              onPressed: () {
                FlutterMob.share('FlutterMob', '我是分享文本', imagePath:'https://flutter.io/images/favicon.png', url:'http://mob.com', titleUrl:'http://mob.com');
              },
              color: Colors.blueAccent,
              child: Text('Share'),
            ),
          ],
        ),
      ),
    );
  }

  void getCode() async {
    var get = await FlutterMob.getCode(phone);
    print(get.status);
    print(get.msg);
  }

  void submitCode() async {
    var submit = await FlutterMob.submitCode(phone, code);
    print(submit.status);
    print(submit.msg);
  }

  void qqLogin() async {
    var login = await FlutterMob.qqLogin();
    print(login.status);
    print(login.msg);
  }

  void wechatLogin() async {
    var login = await FlutterMob.wechatLogin();
    print(login.status);
    print(login.msg);
  }

  void sinaLogin() async {
    var login = await FlutterMob.sinaLogin();
    print(login.status);
    print(login.msg);
  }
}
