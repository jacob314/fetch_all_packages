#import "StatusbarPlugin.h"
#import "StatusBarColorizer.h"

@implementation StatusbarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"statusbar"
            binaryMessenger:[registrar messenger]];
  StatusbarPlugin* instance = [[StatusbarPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"show" isEqualToString:call.method])
  {
      [StatusBarColorizer show];
      result(@"done");
  }
  else if ([@"hide" isEqualToString:call.method])
  {
      [StatusBarColorizer hide];
      result(@"done");
  }
  else if ([@"color" isEqualToString:call.method])
  {
      [StatusBarColorizer color:[StatusbarPlugin colorFromHexString:call.arguments[@"hex"]]];
      result(@"done");
  }
  else
  {
    result(FlutterMethodNotImplemented);
  }
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
}

@end
