#import "UiPlugin.h"
#import <ui/ui-Swift.h>

@implementation UiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUiPlugin registerWithRegistrar:registrar];
}
@end
