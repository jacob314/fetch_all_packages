#import "ContactPlugin.h"
#import <LJContactManager.h>

@implementation ContactPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"contact_plugin"
            binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  ContactPlugin* instance = [[ContactPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"selectContact" isEqualToString:call.method]) {
      [[LJContactManager sharedInstance] selectContactAtController:_viewController complection:^(NSString *name, NSString *phone) {
          result(@{@"name":name,@"phone":phone});
      }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
