#import "BeaconsPlugin.h"
#import <flutter_beacons/flutter_beacons-Swift.h>

@implementation BeaconsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBeaconsPlugin registerWithRegistrar:registrar];
}
@end
