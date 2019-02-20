#import "QuantizePlugin.h"
#import <quantize_plugin/quantize_plugin-Swift.h>

@implementation QuantizePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQuantizePlugin registerWithRegistrar:registrar];
}
@end
