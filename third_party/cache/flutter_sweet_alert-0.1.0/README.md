# flutter_sweet_alert

SweetAlert plugin for Flutter.

> Supported  Platforms
> * Android
> * IOS

## How to Use
### Android
1.add ```flutter_sweet_alert: ^0.0.2``` to your pubspec.yaml

将```flutter_sweet_alert: ^0.0.2``` 添加到pubspec.yaml


2.add ```xmlns:tools="http://schemas.android.com/tools"``` to the manifest tag in AndroidManifest.xml .

将```xmlns:tools="http://schemas.android.com/tools"``` 添加到AndroidManifest.xml的manifest标签。
``` xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.fmtol.xxx"
    xmlns:tools="http://schemas.android.com/tools">

```
3.add ```tools:replace="android:label,android:icon"``` to the application tag in AndroidManifest.xml.

将```tools:replace="android:label,android:icon"``` 添加到AndroidManifest.xml的application标签。
``` xml
<application
        tools:replace="android:label,android:icon"
        ...
</application>
```

4.import 'package:flutter_sweet_alert/flutter_sweet_alert.dart' in your dart file.

在dart文件中import 'package:flutter_sweet_alert/flutter_sweet_alert.dart'
```
SweetAlert.dialog(
    type: AlertType.WARNING,
    title: "auto close",
    content: "auto close in 2 seconds",
    autoClose: 2000,
);
```
## API Documentation API文档
1. AlertType

|Type|description|
|----|-----------|
|AlertType.NORMAL|dialog without icon. 无图标弹窗|
|AlertType.ERROR|dialog with a error icon. 带失败图标的弹窗|
|AlertType.SUCCESS|dialog with a success icon. 带成功图标的弹窗|
|AlertType.WARNING|dialog with a warning icon. 带警告图标的弹窗|
|AlertType.CUSTOM_IMAGE_TYPE|not support. 暂不支持|
|AlertType.PROGRESS|dialog with a progress icon. 带进度图标的弹窗|
2. SweetAlert.dialog()

|Property|Type|Default|Description|
|-----|----|-------|-----------|
|type|AlertType|AlertType.NORMAL|弹窗类型|
|title|String|null|弹窗标题|
|confirmButtonText|String|确定|确定按钮文字|
|showCancel|bool|false|是否显示取消按钮|
|cancelButtonText|String|取消|取消按钮文字|
|cancelable|String|null|点击弹窗外部关闭弹窗|
|autoClose|int|0|time of dialog auto close(ms).when 0,never auto close.自动关闭弹窗时间(毫秒)，设为0时不自动关闭。|
|closeOnConfirm|bool|true|Click on the confirm button to close the dialog, just support the dialog with results.点击确认按钮时是否关闭弹窗，仅适用于带结果的弹窗。|
|closeOnCancel|bool|true|Click on the cancel button to close the dialog, just support the dialog with results.点击取消按钮时是否关闭弹窗，仅适用于带结果的弹窗。|

3. Response

|Response|Description|
|-----|----|
|true|clicked the confirm button. 点击确定按钮|
|false|clicked the cancel button. 点击取消按钮|
||autoclose return nothing. 自动关闭无返回值|
