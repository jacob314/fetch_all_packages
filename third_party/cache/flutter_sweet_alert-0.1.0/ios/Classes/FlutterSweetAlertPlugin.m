#import "FlutterSweetAlertPlugin.h"
#import <flutter_sweet_alert/flutter_sweet_alert-Swift.h>

@implementation FlutterSweetAlertPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSweetAlertPlugin registerWithRegistrar:registrar];
}
@end
