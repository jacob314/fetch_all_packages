#import "IceTeaStudioPluginsPlugin.h"
#import "UIView+Toast.h"

@implementation IceTeaStudioPluginsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ice_tea_studio_plugins"
            binaryMessenger:[registrar messenger]];
  IceTeaStudioPluginsPlugin* instance = [[IceTeaStudioPluginsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"showToast" isEqualToString:call.method]) {
      // set default value
      float durationTime = 1.0;
      float textSize = 16.0;
      NSString *msg = @"Message";
      NSString *gravity = @"top";
      NSString *bgColor = @"#000000";
      NSString *titleColor = @"#ffffff";
      
      NSString *tmpMsg = call.arguments[@"msg"];
      if (tmpMsg && tmpMsg != nil && tmpMsg != NULL && ![tmpMsg isKindOfClass:[NSNull class]]) {
          msg = tmpMsg;
      }
      
      NSString *tmpTextSize = call.arguments[@"textSize"];
      if (tmpTextSize && tmpTextSize != nil && tmpTextSize != NULL && ![tmpTextSize isKindOfClass:[NSNull class]]) {
          textSize = [tmpTextSize floatValue];
      }
      
      NSString *tmpTime = call.arguments[@"time"];
      if (tmpTime && tmpTime != nil && tmpTime != NULL && ![tmpTime isKindOfClass:[NSNull class]]) {
          durationTime = [tmpTime floatValue];
      }
      
      NSString *tmpGravity = call.arguments[@"gravity"];
      if (tmpGravity && tmpGravity != nil && tmpGravity != NULL && ![tmpGravity isKindOfClass:[NSNull class]]) {
          gravity = tmpGravity;
      }
      
      NSString *tmpBgColor = call.arguments[@"backgroundColor"];
      if (tmpBgColor && tmpBgColor != nil && tmpBgColor != NULL && ![tmpBgColor isKindOfClass:[NSNull class]]) {
          bgColor = tmpBgColor;
      }
      
      NSString *tmpTitleColor = call.arguments[@"textColor"];
      if (tmpTitleColor && tmpTitleColor != nil && tmpTitleColor != NULL && ![tmpTitleColor isKindOfClass:[NSNull class]]) {
          titleColor = tmpTitleColor;
      }
      
      //BOOL isFullWidth = call.arguments[@"isFullWidth"]?([call.arguments[@"isFullWidth"] isEqualToString:@"true"] ? true : false):true;
      CSToastStyle *toast = [[CSToastStyle alloc] initWithDefaultStyle];
      toast.backgroundColor = [self colorFromHexString:bgColor];
      toast.messageAlignment = NSTextAlignmentCenter;
      toast.titleAlignment = NSTextAlignmentCenter;
      toast.messageFont = [UIFont systemFontOfSize:textSize];
      toast.titleColor = [self colorFromHexString:titleColor];
      id defaultPosition = CSToastPositionBottom;
      if ([gravity isEqualToString:@"top"]) {
          defaultPosition = CSToastPositionTop;
      } else if ([gravity isEqualToString:@"center"]) {
          defaultPosition = CSToastPositionCenter;
      }
      //toast.isFullWidth = isFullWidth;
      [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg duration:durationTime position:defaultPosition style:toast];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
