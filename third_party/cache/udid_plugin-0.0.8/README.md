# udid_plugin

有盾插件，非官方版。

## Getting Started

## Android集成

本SDK包含两种so文件
```
abiFilters 'armeabi', 'armeabi-v7a'
```
[不同的so文件会导致冲突](https://blog.csdn.net/u012400885/article/details/52923765)
目前Flutter默认打包的文件
flutter build apk --release --target-platform android-arm64
flutter run --target-platform android-arm64
```
arm64-v8a
```

项目设置
```
abiFilters 'armeabi'
```
使用以下命令打包
flutter build apk --release --target-platform android-arm
flutter run --target-platform android-arm

armeabi-v7a支持
https://github.com/flutter/flutter/issues/18494


compileSdkVersion 28 Flutter TextField不能编辑，降回27


## iOS集成

1.设置Build Settings ->Enable Bitcode 为No；  
2.若您的app需要支持iOS10系统，请在info.plist里添加以下字段：  
* Privacy - Camera Usage Description
* Privacy - Microphone Usage Description
* Privacy - Photo Library Usage Description

如有ver_app参数获取不到的问题，请修改
Runner->target->identity->Version 为真实版本号。


This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
