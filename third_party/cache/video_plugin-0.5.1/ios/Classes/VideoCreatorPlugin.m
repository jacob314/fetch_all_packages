#import "VideoCreatorPlugin.h"
#import <video_plugin/video_plugin-Swift.h>

@implementation VideoCreatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVideoCreatorPlugin registerWithRegistrar:registrar];
}
@end
