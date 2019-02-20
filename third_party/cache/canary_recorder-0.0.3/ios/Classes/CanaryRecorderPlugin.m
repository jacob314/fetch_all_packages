#import "CanaryRecorderPlugin.h"
#import <canary_recorder/canary_recorder-Swift.h>

@implementation CanaryRecorderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCanaryRecorderPlugin registerWithRegistrar:registrar];
}
@end
