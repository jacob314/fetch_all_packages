#import "ShareWidgetPlugin.h"

@implementation ShareWidgetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"channel:share_widget"
            binaryMessenger:[registrar messenger]];
  ShareWidgetPlugin* instance = [[ShareWidgetPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"shareImage" isEqualToString:call.method]) {
      [self shareImage:(NSDictionary*)call.arguments];
  } else if ([@"shareText" isEqualToString:call.method]) {
      [self shareText:(NSDictionary*)call.arguments];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)shareImage:(NSDictionary*)args {
    NSString* fileName = args[@"fileName"];
    
    NSString* docsPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSURL* imagePath = [[NSURL fileURLWithPath:docsPath] URLByAppendingPathComponent:fileName];
    NSData* imageData = [NSData dataWithContentsOfURL:imagePath];
    UIImage* imageToShare = [UIImage imageWithData:imageData];
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[imageToShare] applicationActivities:nil];
    FlutterViewController* controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [activityViewController popoverPresentationController].sourceView = controller.view;
    [controller showViewController:activityViewController sender:self];
    
}

- (void)shareText:(NSDictionary*)args {
    NSString* text = args[@"text"];
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[text] applicationActivities:nil];
    FlutterViewController* controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [activityViewController popoverPresentationController].sourceView = controller.view;
    [controller showViewController:activityViewController sender:self];
}


@end
