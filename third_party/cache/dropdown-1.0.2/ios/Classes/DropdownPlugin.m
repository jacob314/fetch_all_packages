#import "DropdownPlugin.h"
#import "EZDropdown.h"

@implementation DropdownPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"dropdown"
            binaryMessenger:[registrar messenger]];
  DropdownPlugin* instance = [[DropdownPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
  if ([@"show" isEqualToString:call.method])
  {
    [EZDropdown message:call.arguments[@"message"]
             background:[DropdownPlugin colorFromHexString:call.arguments[@"background"]]
             foreground:[DropdownPlugin colorFromHexString:call.arguments[@"foreground"]]];
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
