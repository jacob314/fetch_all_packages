#import "LessqlPlugin.h"
#import <lessql/lessql-Swift.h>

@implementation LessqlPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLessqlPlugin registerWithRegistrar:registrar];
}
@end
