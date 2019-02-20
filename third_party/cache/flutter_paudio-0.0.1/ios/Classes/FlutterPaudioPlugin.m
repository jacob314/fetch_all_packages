#import "FlutterPaudioPlugin.h"

@implementation FlutterPaudioPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_paudio"
            binaryMessenger:[registrar messenger]];
  FlutterPaudioPlugin* instance = [[FlutterPaudioPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"playAudio" isEqualToString:call.method]) {
    NSLog(@"playAudio");
    result(@(100.90));
  } else if ([@"stopAudio" isEqualToString:call.method]) {
    result(@(100.90));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
