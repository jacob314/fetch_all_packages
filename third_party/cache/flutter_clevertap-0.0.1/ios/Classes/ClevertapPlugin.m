#import "ClevertapPlugin.h"
#import <clevertap/clevertap-Swift.h>

@implementation ClevertapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftClevertapPlugin registerWithRegistrar:registrar];
}
@end
