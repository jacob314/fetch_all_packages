#import "MyBattLevelKotlinSwiftPlugin.h"
#import <my_batt_level_kotlin_swift/my_batt_level_kotlin_swift-Swift.h>

@implementation MyBattLevelKotlinSwiftPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMyBattLevelKotlinSwiftPlugin registerWithRegistrar:registrar];
}
@end
