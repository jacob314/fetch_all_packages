#include "AppDelegate.h"
#import<SystemConfiguration/CaptiveNetwork.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* wifiChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"samples.ly.com/wifiinfo"
                                          binaryMessenger:controller];

  [wifiChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    if ([@"getWiFiName" isEqualToString: call.method]) {
        NSString *wifiName = [self getSSID];
        if ([wifiName isEqualToString: @"Not Found"]) {
          result([FlutterError errorWithCode:@"UNAVAILABLE"
                                     message:@"wifi name unavailable"
                                     details:nil]);
        } else {
          result(@(wifiName));
        }
      } else {
        result(FlutterMethodNotImplemented);
      }
  }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

+ (NSString *) getSSID {
    NSString *ssid = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
       if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];
        }
    }
    return ssid;
}

@end