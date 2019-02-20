#import "GeofirePlugin.h"
#import <geofire/geofire-Swift.h>

@implementation GeofirePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGeofirePlugin registerWithRegistrar:registrar];
}
@end
