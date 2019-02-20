#import "VoyagerPlugin.h"
#import <voyager_plugin/voyager_plugin-Swift.h>

@implementation VoyagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVoyagerPlugin registerWithRegistrar:registrar];
}
@end
