# mixpanel

A native mixpanel plugin.
Currently it works only for Android.

# Example
``` Dart
    import 'package:nat_mixpanel/nat_mixpanel.dart';
    
    void main(){
        NatMixpanel mixpanel = new NatMixpanel();
        initMixpanel();
        mixpanel.track("track_event_name");
        /// or
        Map<String, dynamic> props;
        mixpanel.track("track_event_name", props);
    }
    
    void initMixpanel() async => mixpanel.init("your_token");
```



## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
