#import "MdnsPlugin.h"
#import <mdns/mdns-Swift.h>

@implementation MdnsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMdnsPlugin registerWithRegistrar:registrar];
}
@end
