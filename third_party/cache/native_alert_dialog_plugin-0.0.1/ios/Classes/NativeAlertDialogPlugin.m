#import "NativeAlertDialogPlugin.h"
#import <native_alert_dialog_plugin/native_alert_dialog_plugin-Swift.h>

@implementation NativeAlertDialogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeAlertDialogPlugin registerWithRegistrar:registrar];
}
@end
