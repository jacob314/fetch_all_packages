#import "ItsCachePlugin.h"
#import <its_cache/its_cache-Swift.h>

@implementation ItsCachePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftItsCachePlugin registerWithRegistrar:registrar];
}
@end
