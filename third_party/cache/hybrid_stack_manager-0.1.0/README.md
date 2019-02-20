# hybrid_stack_manager

In hybrid scenarios where there are flutter pages and native pages, and they can jump to flutter/native at will. In other words, hybrid stack management would be the first important problem we should consider. This package can manage the hybrid stack and supports any jumping between flutter/native and native/flutter.

# Architecture

![](https://raw.githubusercontent.com/kangwang1988/kangwang1988.github.io/master/img/hybrid-stack-manangement.png)

# Snapshot

iOS

![hybrid_stack_management_ios](https://raw.githubusercontent.com/kangwang1988/kangwang1988.github.io/master/img/hybrid_stack_management_ios.gif)

Android

![hybrid_stack_management_android](https://raw.githubusercontent.com/kangwang1988/kangwang1988.github.io/master/img/hybrid_stack_management_android.gif)

# Usage

Add dependency in pubspec.yaml:

	hybrid_stack_manager:0.1.0

After getting the package using "flutter packages get",you can check the examples within the package to see how to use it.


## Usage in iOS side

1.Construct a navigationController as the rootWindow's rootViewController for later use when pushing.

2.Set the XURLRouter's nativeOpenUrlHandler where you can implement your own business related router logic，as below:

```
    [[XURLRouter sharedInstance] setNativeOpenUrlHandler:^UIViewController *(NSString *url,NSDictionary *query,NSDictionary *params){
        NSURL *tmpUrl = [NSURL URLWithString:url];
        if([@"ndemo" isEqualToString:tmpUrl.host]){
            return [XDemoController new];
        }
        return nil;
    }];
```
3. All scheme's query will be checked whehter to jump Flutter(flutter=true) or Native(flutter=false/nil)。 This is a universal logic applying in ios/android/flutter. As below:
```
void XOpenURLWithQueryAndParams(NSString *url,NSDictionary *query,NSDictionary *params){
    NSURL *tmpUrl = [NSURL URLWithString:url];
    UINavigationController *rootNav = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    if(![kOpenUrlPrefix isEqualToString:tmpUrl.scheme])
        return;
    if([[query objectForKey:@"flutter"] boolValue]){
        [[XFlutterModule sharedInstance] openURL:url query:query params:params];
        return;
    }
    NativeOpenUrlHandler handler = [XURLRouter sharedInstance].nativeOpenUrlHandler;
    if(handler!=nil)
    {
        UIViewController *vc = handler(url,query,params);
        if(vc!=nil)
            [rootNav pushViewController:vc animated:YES];
    }
}
```

## Usage in Android side

1.Set the XURLRouter's  appContextcontext with the ApplicationContext for later use when jumping.
```
XURLRouter.sharedInstance().setAppContext(getApplicationContext());
```
2.Set XURLRouter's NativeRouterHandler with one always existing instance. This instance should implements XURLRouterHandler and implement method:openUrlWithQueryAndParams where you can implement your own business related router logic，as below:
```
  void setupNativeOpenUrlHandler(){
    XURLRouter.sharedInstance().setNativeRouterHandler(this);
  }
  public Class openUrlWithQueryAndParams(String url, HashMap query, HashMap params){
    Uri tmpUri = Uri.parse(url);
    if("ndemo".equals(tmpUri.getHost())){
      return XDemoActivity.class;
    }
    return null;
  }
```

# Usage in Flutter side

1.Init a global key for later use to fetch a context and pass it to the Router.
2.Set the Router's routerWidgetHandler where Flutter side router logic is implemented，as below:
```
    Router.sharedInstance().routerWidgetHandler =
        ({RouterOption routeOption, Key key}) {
      if (routeOption.url == "hrd://fdemo") {
        return new FDemoWidget(routeOption, key: key);
      }
      return null;
    };
    return _singleton;
```

# Attention
1.In Flutter，the NavigatorState class located in flutter/lib/src/widgets/navigator.dart is modified by adding a getter function to fetch the history as below:
```
  List<Route<dynamic>> get history => _history;
```
2.In iOS，I reuse the XFlutterViewController singleton which is embedded in FlutterViewWrapperController with the help of addChildVC/removeFromParentVC。It is necessary to ensure that the viewWill/DidAppear/Disappear call could be passed from ParentVC Appear to ChildVC(Especially the viewWillAppear: and viewDidDisappear:)。
```
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return TRUE;
}
```

3.Environment

```
KyleWongdeMacBook-Pro:ios kylewong$ /Users/kylewong/Codes/Flutter/official/flutter/bin/flutter doctor -v
[✓] Flutter (Channel unknown, v0.9.6, on Mac OS X 10.14.1 18B57c, locale en-CN)
• Flutter version 0.9.6 at /Users/kylewong/Codes/Flutter/master/flutter
• Framework revision 13684e4f8e (4 weeks ago), 2018-10-02 14:15:17 -0400
• Engine revision f6af1f20ba
• Dart version 2.1.0-dev.6.0.flutter-8a919426f0

[✓] Android toolchain - develop for Android devices (Android SDK 28.0.3)
• Android SDK at /Users/kylewong/Library/Android/sdk
• Android NDK at /Users/kylewong/Library/Android/sdk/ndk-bundle
• Platform android-28, build-tools 28.0.3
• Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
• Java version OpenJDK Runtime Environment (build 1.8.0_152-release-1136-b06)
• All Android licenses accepted.

[!] iOS toolchain - develop for iOS devices (Xcode 10.0)
• Xcode at /Applications/Xcode.app/Contents/Developer
• Xcode 10.0, Build version 10A254a
• ios-deploy 1.9.2
! CocoaPods out of date (1.5.0 is recommended).
CocoaPods is used to retrieve the iOS platform side's plugin code that responds to your plugin usage on the Dart side.
Without resolving iOS dependencies with CocoaPods, plugins will not work on iOS.
For more info, see https://flutter.io/platform-plugins
To upgrade:
brew upgrade cocoapods
pod setup

[✓] Android Studio (version 3.2)
• Android Studio at /Applications/Android Studio.app/Contents
• Flutter plugin version 29.1.1
• Dart plugin version 181.5656
• Java version OpenJDK Runtime Environment (build 1.8.0_152-release-1136-b06)

[✓] Connected device (2 available)
• SM G950U          • 988837355242375644                       • android-arm64 • Android 7.0 (API 24)
```
Though  flutter beta v0.6.0 is used in my environment. In fact, this hybrid stack management  logic works even in v0.3.1 and above.

# Contact me

[Contact me](mailto:kang.wang1988@gmail.com)
