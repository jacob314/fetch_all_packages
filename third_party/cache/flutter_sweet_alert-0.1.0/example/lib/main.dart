import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SweetAlert Plugin Demo'),
        ),
        body: Center(
          child: new Column(
            children: <Widget>[
              FlatButton(
                child: Text("Normal dialog 普通弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    content: "Content 弹窗内容",
                    confirmButtonText: "OK 确定",
                  );
                },
              ),
              FlatButton(
                child: Text("Normal dialog with title. 带标题的普通弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    title: "Title 标题",
                    content: "Content 弹窗内容",
                    confirmButtonText: "OK 确定",
                  );
                },
              ),
              FlatButton(
                child: Text("Success dialog 成功弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    type: AlertType.SUCCESS,
                    title: "Title 标题",
                    content: "Content 弹窗内容",
                    confirmButtonText: "OK 确定",
                  );
                },
              ),
              FlatButton(
                child: Text("Warning dialog 警告弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    type: AlertType.WARNING,
                    title: "Title 标题",
                    content: "Content 弹窗内容",
                    showCancel: true,
                    cancelButtonText: "Cancel 取消",
                    confirmButtonText: "Confirm 确定",
                  );
                },
              ),
              FlatButton(
                child: Text("Error dialog 失败弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    type: AlertType.ERROR,
                    title: "Title 标题",
                    content: "Content 弹窗内容",
                    showCancel: false,
                    confirmButtonText: "Confirm 确定",
                  );
                },
              ),
              FlatButton(
                child: Text("auto close dialog 自动关闭弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    type: AlertType.WARNING,
                    title: "Title 标题",
                    content: "auto close in 2 seconds. 2秒后自动关闭",
                    autoClose: 2000,
                    confirmButtonText: "Close 关闭",
                    cancelable: false,
                  );
                },
              ),
              FlatButton(
                child: Text("manual close dialog. 手动关闭弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    type: AlertType.WARNING,
                    title: "Title 标题",
                    content: "manual close dialog in 1 second. 1秒后手动关闭弹窗",
                    confirmButtonText: "Close 关闭",
                    autoClose: 2000,
                    cancelable: false,
                  );
                  //delay 1 second then close the dialog. 延迟1秒后关闭
                  Future.delayed(Duration(seconds: 1)).then((_) {
                    SweetAlert.close();
                  });
                },
              ),
              FlatButton(
                child: Text("progress dialog 加载弹窗"),
                onPressed: () {
                  SweetAlert.loading(
                    cancelable: true,
                    title: "Title 标题",
                    content: "Content 内容",
                  );
                },
              ),
              FlatButton(
                child: Text("dialog with result 带结果的弹窗"),
                onPressed: () {
                  SweetAlert.dialog(
                    type: AlertType.WARNING,
                    cancelable: true,
                    title: "Title 标题",
                    content: "Content 内容",
                    showCancel: true,
                    cancelButtonText: "Cancel 取消",
                    confirmButtonText: "Confirm 确定",
                    closeOnConfirm: false,
                    closeOnCancel: false,
                  ).then((value) {
                    print(value);
                    if (value) {
                      SweetAlert.update(
                        type: AlertType.SUCCESS,
                        cancelable: true,
                        title: "done 完成",
                        content: "you pressed confirme 你点了确认",
                        showCancel: false,
                        closeOnConfirm: true,
                        confirmButtonText: "Confirm 确定",
                      ).then((value) {
                        print(value);
                      });
                    } else {
                      SweetAlert.update(
                        type: AlertType.SUCCESS,
                        cancelable: true,
                        title: "canceled 取消操作",
                        content: "you pressed cancele 你点了取消",
                        showCancel: false,
                        closeOnConfirm: true,
                        confirmButtonText: "Confirm 确定",
                      ).then((value) {
                        print(value);
                      });
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
