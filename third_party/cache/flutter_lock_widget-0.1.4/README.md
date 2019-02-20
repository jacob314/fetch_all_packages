# Flutter 手势密码

Flutter 手势密码 Widget。

## 效果

![](https://github.com/southpeak/flutter_lock_widget/blob/master/demo.gif?raw=true)

## 使用

* 在 `pubspec.yaml` 中添加以下依赖

```dart
dependencies:
  flutter_lock_widget: '^0.1.1'
```

* 安装

```sh
flutter packages get
```

在 VS Code 下会自动安装

* 在文件中导入

```dart
import 'package:flutter_lock_widget/lock_container.dart';
import 'package:flutter_lock_widget/circle.dart';
```

## 说明

### circle.dart

该文件中主要包括手势密码的基本控件及样子属性设置

* class **CircleAttribute**：用于设置手势密码的整体样式；
* class **Circle**：九宫格中圆的数据结构；
* enum **CircleState**：圆的状态，分普通状态和选中状态；
* enum **LockState**：手势密码整体的状态，分普通状态和出错状态；

### circle_painter.dart

* class **CirclePainter**：绘制圆

### lock_widget.dart

* class **LockWidget**：手势密码区域 Widget。在此类中检测手势操作，并绘制手势路线；

### lock_container.dart

* class **LockContainer**：手势密码容器，可以根据需要修改；目前只包含一个提示文本和手势密码；

## 示例

详细示例可以查看 `example` 目录下的工程，以下是 set.dart 的代码

```dart
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
```

## 参考

[flutter_gesture_password](https://github.com/zhangruiyu/flutter_gesture_password)


