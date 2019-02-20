# plugin_social


A Flutter plugin for using the native Facebook Account SDK for iOS

## How do I use it?

Since sample code is worth more than one page of documentation, here are the usual cases covered:

```dart
PluginSocial pluginSocial = new PluginSocial();

//show sign-in with sms
void signInWithSMS() async {
    pluginSocial.signInWithSMS();
 }

//show sign-in with email
void signInWithEmail() async {
    pluginSocial.signInWithEmail();
}
```

## Installation

To get things up and running, you'll have to declare a pubspec dependency in your Flutter project.
Also some minimal Android & iOS specific configuration must be done, otherise your app will crash.

### On your Flutter project

See the [installation instructions on pub](https://pub.dartlang.org/packages/plugin_social#-installing-tab-).

### iOS

This assumes that you've done the _"Register and Configure Your App with Facebook AccountKit"_ step in the 
[the Facebook Login documentation for iOS site](https://developers.facebook.com/docs/accountkit/ios).

After you've done that, find out what your _Facebook App ID_ is. You can find your Facebook App ID in your Facebook App's dashboard in the Facebook developer console.

Once you have the Facebook App ID & AccountKit Key figured out, then you'll just have to copy-paste the following to your _Info.plist_ file, before the ending `</dict></plist>` tags.

**\<your project root\>/ios/Runner/Info.plist**

```xml
<key>FacebookAppID</key>
    <string>{xxxxxxxxxxxxxxx}</string>
    <key>AccountKitClientToken</key>
    <string>{xxxxxxxxxxxxxxxxxxxxxxxxxxxx}</string>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>ak{xxxxxxxxxxxxxxx}</string>
            </array>
        </dict>
    </array>

```

Done!

### On new Flutter project

You can create new project with swift on iOS side:

``` bash
flutter create -i swift new_project
```

Go to your new project

``` bash
cd new_project
```

Open pubspec.yaml and add this to this file:

``` bash
dependencies:
  plugin_social: "^0.0.7"
```

Finally, run your new project.

``` bash
flutter run
```

