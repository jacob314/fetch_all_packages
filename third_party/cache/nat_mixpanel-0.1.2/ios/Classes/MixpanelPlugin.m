#import "MixpanelPlugin.h"
#import <mixpanel/mixpanel-Swift.h>

@implementation MixpanelPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMixpanelPlugin registerWithRegistrar:registrar];
}
@end
