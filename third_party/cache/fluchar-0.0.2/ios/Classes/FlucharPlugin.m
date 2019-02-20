#import "FlucharPlugin.h"

@implementation FlucharPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"fluchar"
            binaryMessenger:[registrar messenger]];
  FlucharPlugin* instance = [[FlucharPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"char" isEqualToString:call.method]) {
    NSDictionary *dict = call.arguments;
    NSString *str = dict[@"str"];
    int asciiCode = [str intValue];
    NSString *string = [NSString stringWithFormat:@"%C", asciiCode];
    result(string);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
