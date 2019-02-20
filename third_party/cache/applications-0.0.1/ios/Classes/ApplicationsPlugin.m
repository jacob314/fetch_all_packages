#import "ApplicationsPlugin.h"
#import <applications/applications-Swift.h>

@implementation ApplicationsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftApplicationsPlugin registerWithRegistrar:registrar];
}
@end
