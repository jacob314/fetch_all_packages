#import "CompressimagePlugin.h"
#import <Photos/Photos.h>

@implementation CompressimagePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"compressimage"
            binaryMessenger:[registrar messenger]];
  CompressimagePlugin* instance = [[CompressimagePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"compressImage" isEqualToString:call.method]) {
    NSString *imagePath = call.arguments[@"filePath"];
    int desiredQuality = call.arguments[@"desiredQuality"];
    float calculatedQuality = desiredQuality/1602.0;
    UIImage *highResImage=[UIImage imageWithContentsOfFile:imagePath];
    NSData *compressedImageData = UIImageJPEGRepresentation(highResImage, calculatedQuality);
    [compressedImageData writeToFile:imagePath atomically:YES];
    result(@"Image compressed successfully");
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
