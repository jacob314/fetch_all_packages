#import "GetIosDeviceIdfaPlugin.h"
#import <get_ios_device_idfa/get_ios_device_idfa-Swift.h>

@implementation GetIosDeviceIdfaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGetIosDeviceIdfaPlugin registerWithRegistrar:registrar];
}
@end
