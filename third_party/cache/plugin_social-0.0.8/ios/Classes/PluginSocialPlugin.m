#import "PluginSocialPlugin.h"
#import <plugin_social/plugin_social-Swift.h>

@implementation PluginSocialPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPluginSocialPlugin registerWithRegistrar:registrar];
}
@end
