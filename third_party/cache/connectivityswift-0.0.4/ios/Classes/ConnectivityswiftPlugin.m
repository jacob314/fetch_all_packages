#import "ConnectivityswiftPlugin.h"
#import <connectivityswift/connectivityswift-Swift.h>

@implementation ConnectivityswiftPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftConnectivityswiftPlugin registerWithRegistrar:registrar];
}
@end
