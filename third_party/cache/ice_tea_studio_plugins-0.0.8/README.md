# Native plugins

A Flutter plugin for show toast in the mobile platform. Supports iOS and Android.

# Usage

To use this plugin, add `ice_tea_studio_plugins` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).


#Example

```
showToastMessage()  {
    try {
       NativeUtilsPlugin.showToast(msg: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", backgroundColor: "#84db00", gravity: ToastGravity.TOP, isFullWidth: true);
    } on PlatformException {
      print('Failed to call show toast message');
    }
  }
 
 ```
 - **Required**
    - **msg**: String message 
 - **Optional**
    - **backgroundColor**: background color of toast. Ex: `#84bd00` 
    - **textColor**: text color of toast. Ex: `#ffffff` 
    - **isFullWidth**: set toast full width of screen. In case `fullwidth=false` toast using default offset of system
    - **toastLength**: time display toast. Only use for _android_. `Toast.LENGTH_SHORT`, ` Toast.LENGTH_LONG` 
    - **time**: time display toast. Only use for _iOS_.
    - **gravity**: place of toast `ToastGravity.TOP`, `ToastGravity.CENTER`,`ToastGravity.BOTTOM` 
    