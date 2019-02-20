#import "SimpleStepHistoryPlugin.h"
#import <simple_step_history/simple_step_history-Swift.h>

@implementation SimpleStepHistoryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleStepHistoryPlugin registerWithRegistrar:registrar];
}
@end
