#import "FlutterFolioreaderPlugin.h"
#import <flutter_folioreader/flutter_folioreader-Swift.h>

@implementation FlutterFolioreaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFolioreaderPlugin registerWithRegistrar:registrar];
}
@end
