#import "NativeTimezonePlugin.h"
#import <native_timezone/native_timezone-Swift.h>

@implementation NativeTimezonePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeTimezonePlugin registerWithRegistrar:registrar];
}
@end
