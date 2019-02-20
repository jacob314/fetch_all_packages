#import "PermissionsPlugin.h"
#import <permissions/permissions-Swift.h>

@implementation PermissionsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPermissionsPlugin registerWithRegistrar:registrar];
}
@end
