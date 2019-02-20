#import "FlutterPedometerPlugin.h"
#import <flutter_pedometer/flutter_pedometer-Swift.h>

@implementation FlutterPedometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPedometerPlugin registerWithRegistrar:registrar];
}
@end
