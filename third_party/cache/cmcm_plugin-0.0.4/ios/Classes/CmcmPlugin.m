#import "CmcmPlugin.h"

@implementation CmcmPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"cmcm_plugin"
            binaryMessenger:[registrar messenger]];
  CmcmPlugin* instance = [[CmcmPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"init" isEqualToString:call.method]) {
    NSString* pageId = call.arguments[@"pageId"];
    NSString* gameId = call.arguments[@"gameId"];
    NSString* gameName = call.arguments[@"gameName"];
    NSError* error = nil;
    result(@(numberWithBool:YES));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
