#import "FlutterWebviewPlugin.h"
#import <flutter_webview/flutter_webview-Swift.h>

@implementation FlutterWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWebviewPlugin registerWithRegistrar:registrar];
}
@end
