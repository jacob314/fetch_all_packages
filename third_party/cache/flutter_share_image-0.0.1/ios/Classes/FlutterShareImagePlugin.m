#import "FlutterShareImagePlugin.h"
#import <flutter_share_image/flutter_share_image-Swift.h>

@implementation FlutterShareImagePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterShareImagePlugin registerWithRegistrar:registrar];
}
@end
