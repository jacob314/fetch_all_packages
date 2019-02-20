#import "MediaRefreshPlugin.h"

@implementation MediaRefreshPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"media_refresh"
            binaryMessenger:[registrar messenger]];
  MediaRefreshPlugin* instance = [[MediaRefreshPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"scanFile" isEqualToString:call.method]) {
    result(true);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
