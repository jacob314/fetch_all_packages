#import "ClipboardPlugin.h"

@implementation ClipboardPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"clipboard_plugin"
            binaryMessenger:[registrar messenger]];
  ClipboardPlugin* instance = [[ClipboardPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"copyToClipBoard" isEqualToString:call.method]) {
      NSString *text = call.arguments[@"text"];
      if (text != nil && text.length > 0) {
          UIPasteboard *pastoard = [UIPasteboard generalPasteboard];
          pastoard.string = text;
          result(@YES);
      }else{
          result(@NO);
      }
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
