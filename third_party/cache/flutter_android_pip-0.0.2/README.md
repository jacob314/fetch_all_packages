# flutter_android_pip

Android PiP for Flutter. Works on Android SDK > 24 include in your AndroidManifest.xml activity:

    android:resizeableActivity="true"
    android:supportsPictureInPicture="true"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|
    layoutDirection|fontScale|screenLayout|density|smallestScreenSize|orientation"
            
## Usage

Start PiP on compatible devices:

    FlutterAndroidPip.enterPictureInPictureMode();

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).