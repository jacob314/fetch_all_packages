#import "IceteaStudioUtilsPlugin.h"
#import <icetea_studio_utils_plugin/icetea_studio_utils_plugin-Swift.h>

@implementation IceteaStudioUtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIceteaStudioUtilsPlugin registerWithRegistrar:registrar];
}
@end
